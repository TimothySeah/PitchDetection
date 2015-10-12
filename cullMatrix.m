function [A, ANotes, y, cols] = cullMatrix(A, ANotes, y, thres, binsPerSemitone)
% given matrix A and binned song y, perform the following:
% 1) only keep columns of A that are potential candidates (amp above thres)
% 2) remove rows of A and y that are all 0

% setup
LOGSEMI = 0.057763;
INC = LOGSEMI / binsPerSemitone;

% given a column of A and possible fundamental frequencies OPTIONS,
% return 1 if the fundamental frequency is one of the options
function fundamental = findFundamental(col)
    
    % upper and lower bounds
    lbb = options - binsPerSemitone;
    ubb = options + binsPerSemitone;
    
    % see if fundamental frequency of col matches fundamental frequency of
    % options
    bigIndices = find(col > thres);
    if length(bigIndices) < 1
        fundamental = 0; 
    elseif sum((bigIndices(1) > lbb) .* (bigIndices(1) < ubb))
        fundamental = 1;
    else
        fundamental = 0;
    end
end



% indices = sum(A(y > thres,:) > thres) >= 1; % old way: keep loud cols of
% A

% 1) only keep columns of A that are potential candidates
% get options = indices of frequency bins that are base frequencies
yIndices = find(y/norm(y)>thres); % frequency bins with high amplitudes
ilf = yIndices * INC; % yIndices in log frequencies
options = []; %BASE frequency bins with high amplitudes
for i=1:length(ilf)
    below2 = ilf(i) - log(3); below1 = ilf(i) - log(2);
    above1 = ilf(i) + log(2); above2 = ilf(i) + log(3);
    lb = ilf - LOGSEMI; ub = ilf + LOGSEMI;
    if ~sum((below1 > lb) .* (below1 < ub)) % if base guy
        options = [options; yIndices(i)];
    elseif sum((above1 > lb) .* (above1 < ub)) % if has harmonic above
        options = [options; yIndices(i)];
    end
end
% get columns of A that have base frequencies close to options
cols = cellfun(@findFundamental, num2cell(A,1));
A = A(:,find(cols));
ANotes = ANotes(find(cols));

% 2): remove rows of A and y that have tiny values
rowIndices = sum(A,2) + y > 0.001;
A = A(rowIndices, :);
y = y(rowIndices);

end