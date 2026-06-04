%% ELEC 3TR4 - LAB 4 EXPERIMENT 3

clear;
format long e;
tend = 10;
tbegin = -10;
N = 100000;
tstep = (tend - tbegin) / N;
sampling_rate = 1 / tstep;

% Time window =
tt = tbegin : tstep : tend - tstep;

% load('lab4_num_expt1')
% load('lab4_num_expt2')
load('lab4_num_expt3');  % Contains 'xt' and 'yt'

maxlag = 200;  % Large enough to capture the delay

% cross-correlation between y(t) and x(t)
Ryx = xcorr(yt, xt, maxlag);

% tau vector
tau_vec = (-maxlag : maxlag) * tstep;

% find the lag at which cross-correlation is maximum
[max_val, max_idx] = max(Ryx);
estimated_tau = tau_vec(max_idx);

% estimated delay T = -tau_peak (since R_yx peaks at tau = -T)
estimated_T = -estimated_tau;

% autocorrelation of y(t) for comparison
Ryy = xcorr(yt, yt, maxlag);

%% Plots

% Figure 1: Transmitted signal x(t)
figure(1);
plot(tt, xt, 'b-', 'LineWidth', 1.5);
xlabel('Time t (seconds)');
ylabel('x(t)');
title('Transmitted Signal: Gaussian Pulse x(t) = e^{-(t-T)^2}');
grid on;

% Figure 2: Received signal y(t) (buried in noise)
figure(2);
plot(tt, yt, 'r-', 'LineWidth', 0.5);
xlabel('Time t (seconds)');
ylabel('y(t)');
title('Received Signal: y(t) = x(t-T) + w(t) (Noise Buried)');
grid on;

% Figure 3: Cross-correlation R_yx(tau)
figure(3);
plot(tau_vec, Ryx, 'g-', 'LineWidth', 1.5);
hold on;
plot(estimated_tau, max_val, 'ro', 'MarkerSize', 10, 'MarkerFaceColor', 'r');
xlabel('Lag \tau (seconds)');
ylabel('R_{yx}(\tau)');
title('Cross-Correlation Between y(t) and x(t)');
legend('R_{yx}(\tau)', 'Peak', 'Location', 'best');
grid on;
xlim([-0.1, 0.1]);

% Add text annotation
text(estimated_tau + 0.1, max_val*0.8, ...
     sprintf('Peak at \\tau = %.4f s', estimated_tau), ...
     'FontSize', 10, 'Color', 'red');

% Figure 4: Autocorrelation of y(t) for comparison
figure(4);
plot(tau_vec, Ryy, 'm-', 'LineWidth', 1.5);
xlabel('Lag \tau (seconds)');
ylabel('R_{yy}(\tau)');
title('Autocorrelation of y(t) - No Delay Information');
grid on;
xlim([-0.05, 0.05]);

%% Print Results

fprintf('Cross-correlation peak occurs at τ = %.6f seconds\n', estimated_tau);
fprintf('Estimated delay T = -τ_peak = %.6f seconds\n', estimated_T);

fprintf('\nInterpretation:\n');
fprintf('The transmitted pulse x(t) is centered at t = T.\n');
fprintf('The received pulse is centered at t = 2T (delayed by T).\n');
fprintf('Cross-correlation finds the delay by matching x(t) with y(t).\n');