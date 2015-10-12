function [score, rec] = fscore(trueNotes, guessNotes, option)
% given true notes and guessed notes, compute f score

% count number of correctly labelled instrument-notes
if option == 0 % instrument-notes
elseif option == 1 % instruments
    for i = 1:length(trueNotes)
        noteStart = regexp(trueNotes{i}, '[ABCDEFG]S?[0123456789]');
        trueNotes{i} = trueNotes{i}(1:(noteStart - 1));
    end
    for i = 1:length(guessNotes)
        noteStart = regexp(guessNotes{i}, '[ABCDEFG]S?[0123456789]');
        guessNotes{i} = guessNotes{i}(1:(noteStart - 1));
    end
    
else % notes
    for i = 1:length(trueNotes)
        noteStart = regexp(trueNotes{i}, '[ABCDEFG]S?[0123456789]');
        trueNotes{i} = trueNotes{i}(noteStart:length(trueNotes{i}));
    end
    for i = 1:length(guessNotes)
        noteStart = regexp(guessNotes{i}, '[ABCDEFG]S?[0123456789]');
        guessNotes{i} = guessNotes{i}(noteStart:length(guessNotes{i}));
    end 
end
trueNotes = unique(trueNotes);
guessNotes = unique(guessNotes);
numCorrect = sum(ismember(trueNotes, guessNotes));

% calculate fscore
prec = numCorrect / length(guessNotes);
rec = numCorrect / length(trueNotes);
if ((prec == 0) && (rec == 0)) || isempty(guessNotes)
    score = 0;
else
    score = 2 * prec * rec / (prec + rec);
end

end