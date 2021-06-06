close all
clear all
format long
pkg load symbolic
syms w

%Incremental Model Specs

Vin = 10e-3;
Zin = 10e6;
Zout = 10;
Av = 1e4;

R1 = 1000;
C1 = 2220e-9;
Zc1 = 1/(C1*i*w);
R2 = 103.7233188894238e3;
C2 = 220e-9;
Zc2 = 1/(C2*i*w);

%-------------------------------------------------------------------------
%Mesh Analysis
%-------------------------------------------------------------------------

M = [[Zc1+R1, -R1, 0, 0];[-R1, R1+Zin, Zin, 0];[0, Zin+Av*Zin, Zin+Av*Zin+Zout+R2, Zout];[0, Av*Zin, Av*Zin+Zout, Zout+Zc2]];

B = [Vin; 0; 0; 0];

I = M\B;

Vout = Zc2*I(4);

%-------------------------------------------------------------------------
%Central Frequency Analysis
%-------------------------------------------------------------------------

w = 2*pi*1000;
Vout_mag = abs(Vout);
input_imp = Vin/eval(I(1))
output_imp = eval(Vout)/eval(I(4))
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
	if abs(gain_mag(1, j) - cutoff) < 0.5
		cf = horzcat(cf, f(1, j));
	endif
endfor

f_low = cf(1, 1)
f_high = cf(1, end)
f_central = sqrt(f_low*f_high)
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
