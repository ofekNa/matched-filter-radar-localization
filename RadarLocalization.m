function [w1vec,w2vec,xvec,yvec] = radardetect(r1vec,r2vec,sigvec)
r1vec = r1vec(:);
r2vec = r2vec(:);
sigvec = sigvec(:);
Fs = 5e6;
T  = 4.096e-4;
Delta = 3840;
c = 3e8;
%samples per pulse
sampsPerPulse = round(T * Fs);
%num of pulsees
N = length(r1vec) / sampsPerPulse;
%divide pulses
r1mat = reshape(r1vec, sampsPerPulse, N);
r2mat = reshape(r2vec, sampsPerPulse, N);
L = length(sigvec);
reversed_signal = flip(sigvec);
%output
w1vec = zeros(N,1);
w2vec = zeros(N,1);
xvec  = zeros(N,1);
yvec  = zeros(N,1);
%valid delay search region
startIdx = L + 1;
rangeIdx = startIdx:sampsPerPulse;

for k = 1:N
    %current received pulse at each tower
    r1pulse = r1mat(:,k);
    r2pulse = r2mat(:,k);
    %filter output
    y1 = filter(reversed_signal, 1, r1pulse);
    y2 = filter(reversed_signal, 1, r2pulse);
    %delay estimate for tower 1
    [~, idx1_local] = max(y1(rangeIdx));
    idx1 = idx1_local + startIdx - 1;
    w1 = idx1 - L;
    %delay estimate for tower 2
    [~, idx2_local] = max(y2(rangeIdx));
    idx2 = idx2_local + startIdx - 1;
    w2 = idx2 - L;
    w1vec(k) = w1;
    w2vec(k) = w2;
    %change to meters
    R1 = (c/(2*Fs)) * w1;
    R2 = (c/Fs) * w2 - R1;
    %solve for x and y from the two circles
    x = (R1^2 - R2^2 + Delta^2) / (2*Delta);
    y_sq = R1^2 - x^2;
    y = sqrt(max(0, y_sq));
    xvec(k) = x;
    yvec(k) = y;

end
%plot the path
figure;
plot(xvec, yvec);
grid on;
xlabel("x [meter]");
ylabel("y [meter]");
title("Estimated path");
end



A = load("radarreception.mat");
B = load("sigvec.mat");

[w1vec,w2vec,xvec,yvec] = radardetect(A.r1vec, A.r2vec, B.sigvec);
