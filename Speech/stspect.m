function stspect(x, nstart, ninc, nwin, nfft, nsect, pltinc)
% x: input signal
% nstart: sample number that first window is centered on
% ninc: offset between windowed segments
% nwin: window length
% nfft: fft size
% nsect: number of sections to plot
% plinc: offset of spectra in plot (in dB)

J = sqrt(-1);
x = x(:); %--- make it a column
X = zeros(nfft, nsect);
con = 1;
coninc = 10^(pltinc/20);

ncenter = nstart;

for k=1:nsect
    n1 = ncenter - fix(nwin/2);
    n2 = ncenter + fix(nwin/2);
    Lh = n2-n1+1;
    X(:,k) = con*fft(x(n1:n2).*hamming(Lh), nfft);
    con = con/coninc;
    
    ncenter = n2 + ninc + fix(nwin/2);
end

f = (0:nfft/2)*(8000/nfft);
X = J*20*log10(abs(X(1:nfft/2+1,:))) + (ones(nsect,1)*f).';
plot(X)
xlabel('Frequency in Hz')
ylabel('Log Magnitude in dB')
title( 'Short-Time Spectra with Different Window Positions')