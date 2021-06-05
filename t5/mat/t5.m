close all
clear all
format long
pkg load symbolic
syms w

%Incremental Model Specs

Vin = 10e-3;
Zin = 1e6;
Zout = 50;
Av = 1e5;

R1 = 2000+1/(1/1000 + 2/100000);
C1 = 1/(1/220e-9 + 1/1e-6);
Z1 = R1 + 1/(C1*i*w);
Z2 = 120e3;
Rl = 8;

%-------------------------------------------------------------------------
%Mesh Analysis
%-------------------------------------------------------------------------

M = [[Z1-Zin, 0, -Zin];[Av*Zin, Zout+Rl, Zout+Av*Zin];[Av*Zin-Zin, Zout, Z2+Zout+Av*Zin-Zin]];

B = [Vin; 0; 0];

I = M\B;

Vout = Rl*I(2);

%-------------------------------------------------------------------------
%Central Frequency Analysis
%-------------------------------------------------------------------------

w = 2*pi*1000;
Vout_mag = abs(Vout);
input_imp = Vin/eval(I(1))
output_imp = eval(Vout)/eval(I(2))
gain = eval(Vout_mag)/Vin

%-------------------------------------------------------------------------
%Frequency response
%-------------------------------------------------------------------------

f = logspace(1, 8, 70);
gain_mag = [];
gain_ph = [];
for j=1:1:size(f, 2)
	w = 2*pi*f(j);
	gain_mag = horzcat(gain_mag, abs(eval(Vout)/Vin));
	bruh = arg(eval(Vout)/Vin)*180/pi;
	gain_ph = horzcat(gain_ph, bruh);
endfor

hf = figure();
semilogx(f, gain_mag);
grid on;
xlabel ("frequency (Hz)");
ylabel ("Magnitude");
title ("Magnitude plot");
legend("vo/vi(f)","location", "northwestoutside");
saveas(hf, "gain_mag.pdf");

hg = figure();
semilogx(f, gain_ph);
grid on;
xlabel ("frequency (Hz)");
ylabel ("Phase");
title ("Phase plot");
legend("vo/vi(f)","location", "northwestoutside");
saveas(hg, "gain_ph.pdf");
