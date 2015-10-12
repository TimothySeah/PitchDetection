% convert flats to sharps

files = dir;
for i = 1:size(files, 1)
   fileName = files(i).name;
   noteStart = regexp(fileName, '[ABCDEFG]b[0123456789]');
   if noteStart
       newNote = '';
       if fileName(noteStart) == 'D'
           newNote = 'C';
       elseif fileName(noteStart) == 'E'
           newNote = 'D';
       elseif fileName(noteStart) == 'G'
           newNote = 'F';
       elseif fileName(noteStart) == 'A'
           newNote = 'G';
       elseif fileName(noteStart) == 'B'
           newNote = 'A';
       else
           newNote = 'X';
       end
      
       movefile(fileName, [fileName(1:(noteStart-1)) newNote 's' fileName((noteStart+2):size(fileName,2))]);
       
   end
end