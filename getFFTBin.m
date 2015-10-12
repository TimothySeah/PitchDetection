function v = getFFTBin(y, fs, binsPerSemitone)
% given audio clip y, sampling frequency fs, and #bins per
% semitone, return binned audio cip v

% setup
LOGSEMI = 0.057763;
INC = LOGSEMI / binsPerSemitone;
NUMBINS = ceil(log(22050) / INC);
    
% process y vector and compute its fft
if size(y, 2) == 2
    y = (y(:,1) + y(:,2)) / 2;
end
y = y - mean(y); % remove dc bias
[x, y] = getFFT(y, fs);
y = abs(y);

% produce binned vector v
v = zeros(NUMBINS, 1);
for j = 1:size(x, 2)
   if x(j) > 0 % only look at positive frequencies
       % index: numbins when freq really high, 1 when freq close to 0
       index = max(min(ceil(log(x(j)) / INC), NUMBINS), 1);
       v(index) = v(index) + y(j);
   end
end
v = v / norm(v);

end