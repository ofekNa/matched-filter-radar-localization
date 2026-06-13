clear; clc; close all;

%load known signal
A = load("sigvec.mat");     
%row vector
SIGVEC = A.sigvec(:).'; 
L = length(SIGVEC);

%Load given vectors
B = load("delayedvecs.mat");
R1VEC = B.r1vec(:);             
R2VEC = B.r2vec(:);
M = length(R1VEC);             

figure;
plot(R1VEC);
grid on;
title("Given vector R1VEC");
xlabel("Sample index n");
ylabel("Amplitude");

figure;
plot(R2VEC);
grid on;
title("Given vector R2VEC");
xlabel("Sample index n");
ylabel("Amplitude");

%part of building the filter
%reverse signal
REVERSED_SIGNAL = flip(SIGVEC);

%R1 -> Filter -> Y1
Y1 = filter(REVERSED_SIGNAL, 1, R1VEC); 
%R2 -> Filter -> Y2
Y2 = filter(REVERSED_SIGNAL, 1, R2VEC);

%define search range for valid delays
START = L + 1;
RANGE = START:M;

[PEAK1, IDX1_LOCAL] = max(Y1(RANGE));
IDX1 = IDX1_LOCAL + START - 1;
DELAY1 = IDX1 - L;           
[PEAK2, IDX2_LOCAL] = max(Y2(RANGE));
IDX2 = IDX2_LOCAL + START - 1;
DELAY2 = IDX2 - L;

figure;
plot(Y1); grid on; hold on;
plot(IDX1, Y1(IDX1), "ro", "LineWidth", 2);
title(sprintf("Matched filter output for R1VEC (ŵ=%d)", DELAY1));
xlabel("n"); ylabel("Matched filter output");

figure;
plot(Y2); grid on; hold on;
plot(IDX2, Y2(IDX2), "ro", "LineWidth", 2);
title(sprintf("Matched filter output for R2VEC (ŵ=%d)", DELAY2));
xlabel("n"); ylabel("Matched filter output");
