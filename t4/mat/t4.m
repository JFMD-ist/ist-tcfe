close all
clear all
format long

%-------------------------------------------------------------------------
%Gain stage
%-------------------------------------------------------------------------

%Constants and circuit specs
VT=0.0258649170201;
BFN=178.7;
VAFN=69.7;
RE1=50;
RC1=8.05e3;
RB1=149e3;
RB2=10e3;
VBEON=0.7;
VCC=12;
RS=100;

%OP analysis
RB=1/(1/RB1+1/RB2);
VEQ=RB2/(RB1+RB2)*VCC;
IB1=(VEQ-VBEON)/(RB+(1+BFN)*RE1);
IC1=BFN*IB1;
IE1=(1+BFN)*IB1;
VE1=RE1*IE1;
VO1=VCC-RC1*IC1;
VCE=VO1-VE1;

table_end = '\\ \hline';
filename = "gs_theory.tex";
fid = fopen(filename, "w");
fprintf(fid, "\\begin{tabular}{|c|c|}\n");
fprintf(fid, "\\hline\n");
fprintf(fid, "$V_{eq}$ & %f %s\n", VEQ, table_end);
fprintf(fid, "$R_B$  & %f %s\n", RB, table_end);
fprintf(fid, "$I_{B1}$  & %f %s\n", IB1, table_end);
fprintf(fid, "$I_{C1}$  & %f %s\n", IC1, table_end);
fprintf(fid, "$V_{O1}$  & %f %s\n", VO1, table_end);
fprintf(fid, "$I_{E1}$  & %f %s\n", IE1, table_end);
fprintf(fid, "$V_{E1}$  & %f %s\n", VE1, table_end);
fprintf(fid, "$V_{CE}$  & %f %s\n", VCE, table_end);
fprintf(fid, "\\end{tabular}\n");
fclose(fid);

%Incremental analysis
gm1=IC1/VT;
rpi1=BFN/gm1;
ro1=VAFN/IC1;

%Gain calculation (w/o bypass capacitor)
AV1 = RC1*(RE1-gm1*rpi1*ro1)/((ro1+RC1+RE1)*(RB+rpi1+RE1)+gm1*RE1*ro1*rpi1 - RE1^2);
AV1simple = gm1*RC1/(1+gm1*RE1);

%Gain calculation (w/ bypass capacitor in high frequency range)
RE1=0;
AV1 = RC1*(RE1-gm1*rpi1*ro1)/((ro1+RC1+RE1)*(RB+rpi1+RE1)+gm1*RE1*ro1*rpi1 - RE1^2);
AV1simple = gm1*RC1/(1+gm1*RE1);

%Input and Output impedance
RE1=100;

ZI1 = ((ro1+RC1+RE1)*(RB+rpi1+RE1)+gm1*RE1*ro1*rpi1 - RE1^2)/(ro1+RC1+RE1)

ZX = ro1*((RB+rpi1)*RE1/(RB+rpi1+RE1))/(1/(1/ro1+1/(rpi1+RB)+1/RE1+gm1*rpi1/(rpi1+RB)));

ZO1 = 1/(1/ZX+1/RC1)


%-------------------------------------------------------------------------
%Ouput stage
%-------------------------------------------------------------------------

%Constants and circuit specs
BFP = 227.3;
VAFP = 37.2;
RE2 = 360;
VEBON = 0.7;

%OP analysis
VI2 = VO1;
IE2 = (VCC-VEBON-VI2)/RE2;
IC2 = BFP/(BFP+1)*IE2;
VO2 = VCC - RE2*IE2;

filename = "os_theory.tex";
fid = fopen(filename, "w");
fprintf(fid, "\\begin{tabular}{|c|c|}\n");
fprintf(fid, "\\hline\n");
fprintf(fid, "$I_{E2}$  & %f %s\n", IB1, table_end);
fprintf(fid, "$I_{C2}$  & %f %s\n", IC1, table_end);
fprintf(fid, "$V_{O2}$  & %f %s\n", VO1, table_end);
fprintf(fid, "\\end{tabular}\n");
fclose(fid);

%Incremental analysis
gm2 = IC2/VT;
go2 = IC2/VAFP;
gpi2 = gm2/BFP;
ge2 = 1/RE2;

%Gain calculation
AV2 = gm2/(gm2+gpi2+go2+ge2);

%Input and Output impedance
ZI2 = (gm2+gpi2+go2+ge2)/gpi2/(gpi2+go2+ge2)

ZO2 = 1/(gm2+gpi2+go2+ge2)

%-------------------------------------------------------------------------
%Frequency response
%-------------------------------------------------------------------------

f = logspace(1, 8, 70);
%Input stage gain
function y = is_t(f, Rs)
C1 = 5e-6;
y = 1/(1+2*pi*f*i*C1*Rs);
endfunction

%Gain stage gain (w/ frequency dependency)
function y = gs_t(f, Rc, gm1, ro1, rpi1, Re1, Rb)
Cb = 1e-4;
ge1 = 1/Re1;
Zeq = 1/(ge1 + 2*pi*f*i*Cb);
y = -Rc*(-gm1*ro1*rpi1+Zeq)/(Zeq*(-gm1*ro1*rpi1+Zeq)+(Rc+ro1+Zeq)*(-rpi1-Zeq));
endfunction

%Output resistor + capacitor gain
function y = out_t(f)
Cout = 1e-6;
Rl = 8;
y = 2*pi*f*i*Cout*Rl/(1+2*pi*f*i*Cout*Rl);
endfunction

tf = [];
for j=1:1:size(f, 2)
tf = horzcat(tf, is_t(f(1, j), RS)*gs_t(f(1, j), RC1, gm1, ro1, rpi1, RE1, RB)*AV2*out_t(f(1, j)));
endfor
tf_mag = [];
tf_ph = [];

for j=1:1:size(tf, 2)
tf_mag = horzcat(tf_mag, 20*log10(abs(tf(1, j))));
tf_ph = horzcat(tf_ph, arg(tf(1, j))*180/pi);
endfor

t_max = tf_mag(1, 1);
for j=1:1:size(tf_mag, 2)
if tf_mag(1, j) > t_max
t_max = tf_mag(1, j);
endif
endfor

cutoff = t_max - 3;

t = [];
for j=1:1:size(tf_mag, 2)
t = horzcat(t, cutoff);
endfor

cf = [];
for j=1:1:size(tf_mag, 2)
if abs(tf_mag(1, j) - cutoff) < 0.6
cf = horzcat(cf, f(1, j));
endif
endfor

bandwidth = cf(1, 2) - cf(1, 1)
lower_cutoff = cf(1, 1)
gain = t_max
merit = bandwidth*abs(t_max)/(273.568*lower_cutoff)

hf = figure();
semilogx(f, tf_mag);
hold on;
semilogx(f, t);
grid on;
xlabel ("frequency (Hz)");
ylabel ("Magnitude (dB)");
title ("Magnitude plot");
legend("vo/vi(f)", "cutoff","location", "northwestoutside");
saveas(hf, "theory_mag.pdf");

hg = figure();
semilogx(f, tf_ph);
grid on;
xlabel ("frequency (Hz)");
ylabel ("Phase (degrees)");
title ("Phase Plot");
legend("vo/vi(f)", "location", "northwestoutside");
saveas(hg, "theory_ph.pdf");

filename = "theory_sec2.tex";
fid = fopen(filename, "w");
fprintf(fid, "\\begin{tabular}{|c|c|}\n");
fprintf(fid, "\\hline\n");
fprintf(fid, "Gain (gain stage) & %f %s\n", AV1, table_end);
fprintf(fid, "Input Impedance (gain stage)  & %f %s\n", ZI1, table_end);
fprintf(fid, "Output Impedance (gain stage)  & %f %s\n", ZO1, table_end);
fprintf(fid, "Gain (output stage) & %f %s\n", AV2, table_end);
fprintf(fid, "Input Impedance (output stage)  & %f %s\n", ZI2, table_end);
fprintf(fid, "Output Impedance (output stage)  & %f %s\n", ZO2, table_end);
fprintf(fid, "\\end{tabular}\n");
fclose(fid);

Gain_calc_input = is_t(1000, RS)
Gain_calc_gs = gs_t(1000, RC1, gm1, ro1, rpi1, RE1, RB)
Gain_calc_os = AV2
Gain_calc_out = out_t(1000)

Gain_total = Gain_calc_input*Gain_calc_gs*Gain_calc_os*Gain_calc_out;
vout = [];
t_ms = 0:2.5e-5:10e-3; 
for j=1:1:size(t_ms, 2)
vout = horzcat(vout, 10*abs(Gain_total)*sin(2000*pi*t_ms(1, j)+arg(Gain_total)));
endfor

hi = figure();
plot(t_ms*1000, vout);
grid on;
xlabel ("Time (ms)");
ylabel ("Voltage (mV)");
title ("Output Signal");
legend("v_{out}(t)", "location", "northwestoutside");
saveas(hi, "theory_out.pdf");
