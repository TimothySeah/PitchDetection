function [x, y] = getFFT(y, Fs)
% given signal, return x and y coordinates of fft of signal

N = size(y, 1);
y = fftshift(fft(double(y)));
x = (-1 * Fs / 2):(Fs / (N-1)):(Fs / 2);

end