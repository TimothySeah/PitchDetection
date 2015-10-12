function [totalSong, notes] = genSong(numNotes)
% given the number of notes to combine,
% return the combination of the notes
% also return names of constituent notes, of form InstrumentAs
% assumes all notes 1) have sample sampling frequency 2) are mp3

% names of instruments
INST_NAMES = {'Saxophone'; 'Clarinet'; 'Cello'; 'Flute'; 'Horn';
    'Trumpet'; 'Tuba'; 'Violin'};

% acquire relevant files (first 3 junk), then get random indices
fileList = dir('../Data2');
fileNames = {};
for i = 4:size(fileList, 1)
    fileNames = [fileNames; fileList(i).name];
end
indices = randsample(size(fileNames, 1), numNotes);

% get names of indices
INST_NAMES = upper(INST_NAMES);
notes = cell(size(indices));
for i = 1:size(indices, 1)
    fileName = upper(fileNames(indices(i)));
    
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


% add songs together
totalSong = audioread(strcat('../Data2/', fileNames{indices(1)})); % first song
for i = 2:size(indices, 1)
    song = audioread(strcat('../Data2/', fileNames{indices(i)}));
    
    % make sure songs have same length
    len = max(size(totalSong, 1), size(song, 1));
    if size(totalSong, 1) < len
        padding = len - size(totalSong, 1);
        totalSong = [totalSong; zeros(padding, 1)];
    elseif size(song, 1) < len
        padding = len - size(song, 1);
        song = [song; zeros(padding, 1)];
    end
    
    totalSong = totalSong + song;
end

end