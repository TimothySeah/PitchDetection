function [fundFreq] = plotFFT(y, Fs, outputName)
% given signal, process it and write analyses to files. Return highest peak

% compute variables
[x, y] = getFFT(y, Fs);

% output frequency with highest peak
[maxVal, indexval] = max(y);
fundFreq = x(indexval);

% write png of graph
if 0
plot(x, abs(y));
print(strcat(outputName, '.png', '-dpng'));
end

end