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

R1 = 1250;
C1 = 3000e-9;
R2 = 50e3;
C2 = 220e-9;
Z1 = R1 + 1/(C1*i*w);
Z2 = 120e3;
Zl = 1/(C2*i*w);

%-------------------------------------------------------------------------
%Mesh Analysis
%-------------------------------------------------------------------------

M = [[Z1-Zin, 0, -Zin];[Av*Zin, Zout+Zl, Zout+Av*Zin];[Av*Zin-Zin, Zout, Z2+Zout+Av*Zin-Zin]];

B = [Vin; 0; 0];

I = M\B;

Vout = Zl*I(2);

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
	gain_mag = horzcat(gain_mag, 20*log10(abs(eval(Vout)/Vin)));
	bruh = arg(eval(Vout)/Vin)*180/pi;
	gain_ph = horzcat(gain_ph, bruh);
endfor

gain_max = gain_mag(1, 1);
for j=1:1:size(gain_mag, 2)
	if gain_mag(1, j) > gain_max
		gain_max = gain_mag(1, j);
	endif
endfor

cutoff = gain_max - 3;
cut = [];
for j=1:1:size(gain_mag, 2)
cut = horzcat(cut, cutoff);
endfor

cf = [];
for j=1:1:size(gain_mag, 2)
	if abs(gain_mag(1, j) - cutoff) < 0.6
		cf = horzcat(cf, f(1, j));
	endif
endfor

f_central = sqrt(cf(1, 1) * cf(1, 2))
freq_dev = abs(f_central - 1000)
gain_dev = abs(gain - 40)
cost = 13322.9920387+324.228
merit = 1/(cost*(gain_dev + freq_dev + 1e-6))

hf = figure();
semilogx(f, gain_mag);
hold on;
semilogx(f, cut);
grid on;
xlabel ("frequency (Hz)");
ylabel ("Magnitude");
title ("Magnitude plot");
legend("vo/vi(f)", "cutoff", "location", "northwestoutside");
saveas(hf, "gain_mag.pdf");

hg = figure();
semilogx(f, gain_ph);
grid on;
xlabel ("frequency (Hz)");
ylabel ("Phase");
title ("Phase plot");
legend("vo/vi(f)","location", "northwestoutside");
saveas(hg, "gain_ph.pdf");
