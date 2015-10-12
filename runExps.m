function [avgFScores, avgFI, avgFN, avgSNRs, BRecall, BRed] = runExps(binsPerSemitone, iters, thres1, thres2)
% compute the average f score of the pitch detection algorithm
% thres1: value that x has to cross in order for us to count it as
% instrument
% thres: value that y must cross for ust to consider it a note
% BRecall: the recall of the matrix culling step

% global variables
[A, ANotes] = createMatrix(binsPerSemitone);
avgFScores = zeros(4, 21);
avgSNRs = zeros(4, 21);
avgFI = zeros(4, 21);
avgFN = zeros(4, 21);
totalBRecall = 0; totalBRed = 0;

% for each numNotes, lambda
for numNotes = 1:2:7
    for lambda = 0:0.05:1

        % sum f scores and SNR's of random songs
        totalFScore = 0;
        totalSNR = 0;
        totalFI = 0;
        totalFN = 0;
        for i = 1:iters
           [song, trueNotes] = genSong(numNotes);
           binnedSong = getFFTBin(song, 44100, binsPerSemitone);
           [B, BNotes, nbinnedSong] = cullMatrix(A, ANotes, binnedSong, thres2, binsPerSemitone);
           % B = A; BNotes = ANotes; nbinnedSong = binnedSong;
           x = nnlasso(nbinnedSong, B, lambda);

           % add to totalFScore
           guessNotes = cell(0,0);
           notGuessIndices = [];
           index = 1;
           for j = 1:size(x)
                if (x(j)/norm(x)) > thres1
                    guessNotes{index} = BNotes{j};
                    index = index + 1;
                else
                    notGuessIndices = [notGuessIndices j];
                end
           end
           totalFScore = totalFScore + fscore(trueNotes, guessNotes, 0);
           totalFI = totalFI + fscore(trueNotes, guessNotes, 1);
           totalFN = totalFN + fscore(trueNotes, guessNotes, 2);

           % add to total SNR
           x(notGuessIndices) = 0;
           reconSong = B * x;
           totalSNR = totalSNR + snr(reconSong, reconSong - nbinnedSong);
           
           % add to total BRecall, BRed
           [,rec] = fscore(trueNotes, BNotes, 0);
           totalBRecall = totalBRecall + rec;
           totalBRed = totalBRed + size(B, 1) * size(B, 2) / size(A, 1) / size(A, 2);
        end
        
        % fill in matrices
        avgFScores(round((numNotes - 1) / 2 + 1), round(20 * lambda + 1)) = totalFScore / iters;
        avgSNRs(round((numNotes - 1) / 2 + 1), round(20 * lambda + 1)) = totalSNR / iters;
        avgFI(round((numNotes - 1) / 2 + 1), round(20 * lambda + 1)) = totalFI / iters;
        avgFN(round((numNotes - 1) / 2 + 1), round(20 * lambda + 1)) = totalFN / iters;
        
    end
end

BRecall = totalBRecall / (iters * 4 * 21);
BRed = totalBRed / (iters * 4 * 21);

end