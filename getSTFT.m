function [S, F, T] = getSTFT(y, Fs, window)
% window: length (in seconds) of each window in the stft
% given signal and window, return its stft

[S, F, T] = getSTFT(y, window * Fs, [], [], Fs);

end