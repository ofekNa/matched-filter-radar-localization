
%load known signal
A = load("sigvec.mat");
%make it row vector
SIGVEC = A.sigvec(:).';
%length is 128
L = length(SIGVEC);

%part of building the filter
%reverse signal
REVERSED_SIGNAL = flip(SIGVEC);

%signal energy ||s||^2
SIGENERGY = sum(SIGVEC.^2);

%Load given vectors for Q2
B = load("delayedvecsQ2.mat");

%put the 3 vectors and their parameters in list for looping
R_LIST = {B.r1(:), B.r2(:), B.r3(:)};
DELTA_LIST = [B.delta1, B.delta2, B.delta3];
SIGMA2_LIST = [B.sigma2_1, B.sigma2_2, B.sigma2_3];

for i = 1:3
    %take current vector and parameters
    R = R_LIST{i};
    DELTA = DELTA_LIST(i);
    SIGMA2 = SIGMA2_LIST(i);
    %length of current reception vector
    N = length(R);
    %matched filter output
    Y = filter(REVERSED_SIGNAL, 1, R);

    %valid delays only
    START = L + 1;
    RANGE = START:N;
    %find maximum in the filter output
    [PEAK, IDX_LOCAL] = max(Y(RANGE));
    IDX = IDX_LOCAL + START - 1;
    DELAY = IDX - L;
    %compute threshold
    %M-1 = number of possible delays = N-L
    NUM_DELAYS = N - L;
    THRESHOLD = 0.5 * SIGENERGY + SIGMA2 * log(((1 - DELTA) / DELTA) * NUM_DELAYS);
    %decide if signal returned
    RETURNED = (PEAK >= THRESHOLD);
    %plot matched filter output with max point and threshold line
    figure;
    plot(Y);
    grid on;
    hold on;
    plot(IDX, Y(IDX), "ro", "LineWidth", 2);
    %horizontal line at threshold
    yline(THRESHOLD, "--", "LineWidth", 2);
    %title says whats the decision
    if RETURNED
        title(sprintf("r%d matched filter delay=%d", i, DELAY));
    else
        title(sprintf("r%d matched filter NO RETURN", i));
    end
    xlabel("n");
    ylabel("Matched filter output");

end
