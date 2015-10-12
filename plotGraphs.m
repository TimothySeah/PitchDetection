i = 1;
plot(x, fn(i, :), 'b');
hold on
plot(x, f(i,:), 'r');
plot(x, fi(i, :), 'g');
legend('pitch', 'instrument-pitch', 'instrument');
title(strcat('F Score vs Lambda (N = ', int2str(2*i-1), ')'));
ylabel('F Score');
xlabel('Lambda');


i = 1;
plot(x, snr(i, :));
title(strcat('SNR vs Lambda (N = ', int2str(2*i-1), ')'));
ylabel('SNR (decibels)');
xlabel('Lambda');