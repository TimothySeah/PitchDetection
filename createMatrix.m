function [A, notes] = createMatrix(binsPerSemitone)
% A: a matrix. Each row corresponds to frequency bin. Each column
% corresponds to instrument/note.
% notes: a vector containing the note names (e.g. ViolinAs5), 1 for
% each column

% setup
LOGSEMI = 0.057763;
INC = LOGSEMI / binsPerSemitone;
NUMBINS = ceil(log(22050) / INC);

% acquire relevant files (first 3 junk)
fileList = dir('../Data');
fileNames = {};
for i = 4:size(fileList, 1)
    fileNames = [fileNames; fileList(i).name];
end



% names of instruments
INST_NAMES = {'Saxophone'; 'Clarinet'; 'Cello'; 'Flute'; 'Horn';
    'Trumpet'; 'Tuba'; 'Violin'};

% get names of instruments
INST_NAMES = upper(INST_NAMES);
notes = cell(size(fileNames));
for i = 1:size(fileNames)
    fileName = upper(fileNames(i));
    
    % find instrument
    inst = '';
    for j = 1:size(INST_NAMES, 1)
        foundCell = strfind(fileName, INST_NAMES{j});
        if foundCell{1}
           inst = INST_NAMES{j};
           break;
        end
    end
    
    % find note
    noteStartCell = regexp(fileName, '[ABCDEFG]S?[0123456789]');
    noteStart = noteStartCell{1};
    noteEnd = noteStart + 1;
    if fileName{1}(noteStart + 1) == 'S'
        noteEnd = noteStart + 2;
    end
    note = fileName{1}(noteStart:noteEnd);
    
    notes{i} = [inst note];
end




% for each file, add binned vector to matrix A
numFiles = size(fileNames, 1);
A = zeros(NUMBINS, numFiles);
for i = 1:numFiles
    [y, fs] = aiffread(strcat('../Data/', fileNames{i}));
    A(:, i) = getFFTBin(y, fs, binsPerSemitone);
end

end