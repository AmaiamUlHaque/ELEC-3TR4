%% ELEC 3TR4 - LAB 4 EXPERIMENT 1

clear 
format long e
tend = 10;
tbegin = -10;
N=100000;
tstep = (tend-tbegin)/N;
sampling_rate = 1/tstep;

% Time window =
tt = tbegin:tstep:tend-tstep;

load('lab4_num_expt1')
% load('lab4_num_expt2')
% load('lab4_num_expt3')

maxlag = 100;

% Autocorrelation of yt
Ry  = xcorr(yt,yt,maxlag);

% tau vector
tau_vec = -(maxlag*tstep):tstep:maxlag*tstep;

% Abs. PSD corresponding to yt
Sy = abs(fftshift(fft(fftshift(Ry))));

% define the frequency vector corresponding to tau_vec
Ntau = length(tau_vec);

% Nyquist sampling rate
fmax = sampling_rate/2; 
fmin = -fmax;
fstep = (fmax-fmin)/Ntau;

% Frequency window
freq = fmin:fstep:fmax-fstep;

%% Plots
figure(1);
plot(tau_vec, Ry, 'b-', 'LineWidth', 1.5);
xlabel('\tau (seconds)'); ylabel('R_y(\tau)');
title('Autocorrelation of LPF Output');
grid on; xlim([-0.01, 0.01]);

figure(2);
plot(freq, Sy, 'r-', 'LineWidth', 1.5);
xlabel('f (Hz)'); ylabel('S_y(f)');
title('Power Spectral Density of LPF Output');
grid on; xlim([-500, 500]);
