%% LAB 3 - SIMULATION

clear
hold off
format long e
figureNum = 1;

N = 4096; %No. of FFT samples
sampling_rate = 100.0e3; %unit Hz
tstep = 1/sampling_rate;
tmax = N*tstep/2;

tmin = -tmax;
tt = tmin:tstep:tmax-tstep;
fmax = sampling_rate/2; 
fmin = -fmax;
fstep = (fmax-fmin)/N;
freq = fmin:fstep:fmax-fstep;

%% PART I

fc = 64000; % freq of ct
fm = 4000; %freq of mt
Ac = 1;
ct=Ac*cos(2*pi*fc*tt);
mt = cos(2*pi*fm*tt);
st = mt.*ct;

% CARRIER - TIME DOMAIN
figure(figureNum)
Hp1 = plot(tt,ct);
set(Hp1,'LineWidth',2)
Ha = gca;
set(Ha,'Fontsize',16)
Hx=xlabel('Time (sec) ');
set(Hx,'FontWeight','bold','Fontsize',16)
Hx=ylabel('Carrier c(t)  (Volt)');
set(Hx,'FontWeight','bold','Fontsize',16)
title('Carrier : Time domain');  
axis([-1e-3 1e-3 -1.1 1.1])
pause(1)

% MESSAGE - TIME DOMAIN
figureNum = figureNum+1;
figure(figureNum)
Hp1 = plot(tt,mt);
set(Hp1,'LineWidth',2)
Ha = gca;
set(Ha,'Fontsize',16)
Hx=xlabel('Time (sec) ');
set(Hx,'FontWeight','bold','Fontsize',16)
Hx=ylabel('message  m(t)  (Volt)');
set(Hx,'FontWeight','bold','Fontsize',16)
title('message signal : Time domain');  
axis([-0.01 0.01 -1.1 1.1])
pause(1)

% DSB SC - TIME DOMAIN
figureNum = figureNum+1;
figure(figureNum)
Hp1 = plot(tt,st);
set(Hp1,'LineWidth',2)
Ha = gca;
set(Ha,'Fontsize',16)
Hx=xlabel('Time (sec) ');
set(Hx,'FontWeight','bold','Fontsize',16)
Hx=ylabel('s(t)  (Volt)');
set(Hx,'FontWeight','bold','Fontsize',16)
title('DSB-SC modulated wave : Time domain');  
axis([-10/fc 10/fc min(st) max(st)])
pause(1)

% MESSAGE - FREQ DOMAIN
Mf = fftshift(fft(fftshift(mt)))/(2*fmax);
figureNum = figureNum+1;
figure(figureNum)
%The amplitude of the spectrum is different from the Fourier transform
%amplitude due to discretization of discrete Fourier transform
Hp1=plot(freq,abs(Mf));
set(Hp1,'LineWidth',2)
Ha = gca;
set(Ha,'Fontsize',16)
Hx=xlabel('Frequency (Hz) ');
set(Hx,'FontWeight','bold','Fontsize',16)
Hx=ylabel('|M(f)|');
set(Hx,'FontWeight','bold','Fontsize',16)
title('Spectrum of the message signal');  
pause(1)

% DSB SC - FREQ DOMAIN
Sf = fftshift(fft(fftshift(st)))/(2*fmax);
figureNum = figureNum+1;
figure(figureNum)
Hp1=plot(freq,abs(Sf));
set(Hp1,'LineWidth',2)
Ha = gca;
set(Ha,'Fontsize',16)
Hx=xlabel('Frequency (Hz) ');
set(Hx,'FontWeight','bold','Fontsize',16)
Hx=ylabel('|S(f)|');
set(Hx,'FontWeight','bold','Fontsize',16)
title('Spectrum of the DSB-SC wave S(f)');  
pause(1)




%% PART III

%DSB-SC demodulation

%Local oscillator at the receiver perfectly synchronized
thet=0;
lo = cos(2*pi*fc*tt + thet); 

st1 = st .* lo;
figureNum = figureNum+1;
figure(figureNum)
Hp1=plot(tt,st1);
set(Hp1,'LineWidth',2)
Ha = gca;
set(Ha,'Fontsize',16)
Hx=xlabel('Time (sec) ');
set(Hx,'FontWeight','bold','Fontsize',16)
Hx=ylabel('s hat(t)  (Volt)');
set(Hx,'FontWeight','bold','Fontsize',16)
title('signal after remodulation at Rx, s hat(t) : Time domain');
axis([-10/fc 10/fc min(st1) max(st1)])
pause(1)

Sf1 = fftshift(fft(fftshift(st1)))/(2*fmax);
figureNum = figureNum+1;
figure(figureNum)
Hp1=plot(freq,abs(Sf1));
set(Hp1,'LineWidth',2)
Ha = gca;
set(Ha,'Fontsize',16)
Hx=xlabel('Frequency (Hz) ');
set(Hx,'FontWeight','bold','Fontsize',16)
Hx=ylabel('|S hat(f)|');
set(Hx,'FontWeight','bold','Fontsize',16)
title('Spectrum S hat(f)');
pause(1)
%Low pass filtering
f_cutoff = 5000;
%ideal low pass filter
n=1;
for f = freq
    if abs(f) < f_cutoff
        Hf(n) = 1;
    else
        Hf(n) = 0;
    end
n=n+1;
end

Mf1 = Sf1 .* Hf;
mt1 = 2*fmax*fftshift(ifft(fftshift(Mf1)));
figureNum = figureNum+1;
figure(figureNum)
Hp1=plot(tt,mt1,'r',tt,mt*0.5,'g:');
set(Hp1,'LineWidth',2)
Ha = gca;
set(Ha,'Fontsize',16)
Hx=xlabel('Time (sec) ');
set(Hx,'FontWeight','bold','Fontsize',16)
Hx=ylabel('m hat(t)(Volt)');
set(Hx,'FontWeight','bold','Fontsize',16)
title('Output of low pass filter,  m hat(t)  : Time domain');
axis([-0.01 0.01 -1.1 1.1])
legend('LPF output', 'message sig');

figureNum = figureNum+1;
figure(figureNum)
Hp1=plot(freq, 2*abs(Mf1), 'r', freq, abs(Mf), 'g:');
% Hp1=plot(tt,mt1,'r',tt,mt*0.5,'g:');
set(Hp1,'LineWidth',2)
Ha = gca;
set(Ha,'Fontsize',16)
Hx=xlabel('Frequency (Hz) ');
set(Hx,'FontWeight','bold','Fontsize',16)
Hx=ylabel('|M hat(f)|');
set(Hx,'FontWeight','bold','Fontsize',16)
title('Spectrum M hat(t)  : Freq domain');
% axis([-5 5 -1.1 1.1]) 
legend('LPF output', 'message sig');
pause(1)




%% PART II

% SUBPART i : carrier = 1/2

% mt = Am*cos(2*pi*fc*t)
% st = Ac*[1+ka*mt]cos(2*pi*fc*t) 
%    = Ac*[1+ka*Am*cos(2*pi*fm*t)]*cos(2*pi*fc*t)

% signal params
pRatio = 1/2;
Am = sqrt(2/pRatio);
fm = 4000;
mt = Am*cos(2*pi*fm*tt);

fc = 64000; 
ka = 1;
Ac = 1;
st = Ac*(1+ka.*mt).*cos(2*pi*fc*tt);
% st = mt.*ct;

% AM SIGNAL - TIME DOMAIN - HALF POWER
figureNum = figureNum+1;
figure(figureNum)
Hp1 = plot(tt,st);
set(Hp1,'LineWidth',2)
Ha = gca;
set(Ha,'Fontsize',16)
Hx=xlabel('Time (sec) ');
set(Hx,'FontWeight','bold','Fontsize',16)
Hx=ylabel('AM Wave s(t)  (Volt)');
set(Hx,'FontWeight','bold','Fontsize',16)
title('AM Wave  PRatio = 1/2 : Time domain');  
axis([-1e-3 1e-3 -1.1 1.1])
pause(1) 

% AM SIGNAL - FREQ DOMAIN - HALF POWER
Sf = fftshift(fft(fftshift(st)))/(2*fmax);
figureNum = figureNum+1;
figure(figureNum)
Hp1=plot(freq,abs(Sf));
set(Hp1,'LineWidth',2)
Ha = gca;
set(Ha,'Fontsize',16)
Hx=xlabel('Frequency (Hz) ');
set(Hx,'FontWeight','bold','Fontsize',16)
Hx=ylabel('|S(f)|');
set(Hx,'FontWeight','bold','Fontsize',16)
title('Spectrum of the AM Wave S(f) - PRatio = 1/2'); 
pause(1)


% SUBPART ii : carrier = 3

% signal params
pRatio = 3;
Am = sqrt(2/pRatio);
fm = 4000;
mt = Am*cos(2*pi*fm*tt);

fc = 64000; 
ka = 1;
Ac = 1;
st = Ac*(1+ka.*mt).*cos(2*pi*fc*tt);
% st = mt.*ct;

% AM SIGNAL - TIME DOMAIN - THREE POWER
figureNum = figureNum+1;
figure(figureNum)
Hp1 = plot(tt,st);
set(Hp1,'LineWidth',2)
Ha = gca;
set(Ha,'Fontsize',16)
Hx=xlabel('Time (sec) ');
set(Hx,'FontWeight','bold','Fontsize',16)
Hx=ylabel('AM Wave s(t)  (Volt)');
set(Hx,'FontWeight','bold','Fontsize',16)
title('AM Wave PRatio = 3 : Time domain');  
axis([-1e-3 1e-3 -1.1 1.1])
pause(1)

% AM SIGNAL - FREQ DOMAIN - THREE POWER
Sf = fftshift(fft(fftshift(st)))/(2*fmax);
figureNum = figureNum+1;
figure(figureNum)
Hp1=plot(freq,abs(Sf));
set(Hp1,'LineWidth',2)
Ha = gca;
set(Ha,'Fontsize',16)
Hx=xlabel('Frequency (Hz) ');
set(Hx,'FontWeight','bold','Fontsize',16)
Hx=ylabel('|S(f)|');
set(Hx,'FontWeight','bold','Fontsize',16)
title('Spectrum of the AM Wave S(f) - PRatio = 3');
pause(1)


% SUBPART iii : carrier = 25 > 3

% signal params
pRatio = 25;
Am = sqrt(2/pRatio);
fm = 4000;
mt = Am*cos(2*pi*fm*tt);

fc = 64000; 
ka = 1;
Ac = 1;
st = Ac*(1+ka.*mt).*cos(2*pi*fc*tt);

% AM SIGNAL - TIME DOMAIN - HALF POWER
figureNum = figureNum+1;
figure(figureNum)
Hp1 = plot(tt,st);
set(Hp1,'LineWidth',2)
Ha = gca;
set(Ha,'Fontsize',16)
Hx=xlabel('Time (sec) ');
set(Hx,'FontWeight','bold','Fontsize',16)
Hx=ylabel('AM Wave s(t)  (Volt)');
set(Hx,'FontWeight','bold','Fontsize',16)
title('AM Wave PRatio = 25 : Time domain');  
axis([-1e-3 1e-3 -1.1 1.1])
pause(1)

% AM SIGNAL - FREQ DOMAIN - MORE THREE POWER
Sf = fftshift(fft(fftshift(st)))/(2*fmax);
figureNum = figureNum+1;
figure(figureNum)
Hp1=plot(freq,abs(Sf));
set(Hp1,'LineWidth',2)
Ha = gca;
set(Ha,'Fontsize',16)
Hx=xlabel('Frequency (Hz) ');
set(Hx,'FontWeight','bold','Fontsize',16)
Hx=ylabel('|S(f)|');
set(Hx,'FontWeight','bold','Fontsize',16)
title('Spectrum of the AM Wave S(f) - PRatio = 25');
pause(1)



