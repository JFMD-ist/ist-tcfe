close all
clear all
format long
pkg load miscellaneous
pkg load symbolic

filename = "../doc/Data.txt";
fid = fopen(filename, "r");
data = dlmread(filename);
fclose(fid);

%Resisances and conductances
R1 = data(1).*10e2
G1 = 1/R1
R2 = data(2).*10e2
G2 = 1/R2
R3 = data(3).*10e2
G3 = 1/R3
R4 = data(4).*10e2
G4 = 1/R4
R5 = data(5).*10e2
G5 = 1/R5
R6 = data(6).*10e2
G6 = 1/R6
R7 = data(7).*10e2
G7 = 1/R7

%Voltage source
Vs = data(8)

%Capacitance
C = data(9).*10e-7

%Dependency constants
Kb = data(10).*10e-4
Kd = data(11).*10e2

%%-------------------------------------------------------------------------
%%Question 1 Nodal Analysis
%%-------------------------------------------------------------------------

printf("\n\nNodal Analysis\n\n");
N1 = [G1, -G1-G2-G3, G2, 0, G3, 0, 0, 0; 0, Kb+G2, -G2, 0, -Kb, 0, 0, 0; 0, Kb, 0, 0, -Kb-G5, G5, 0, 0; 0, 0, 0, G6, 0, 0, -G6-G7, G7; 0, 0, 0, 1, 0, 0, 0, 0; 1, 0, 0, -1, 0, 0,0, 0; 0, 0, 0, Kd*G6, -1, 0, -Kd*G6, 1; 0, G3, 0, G4, -G3-G4-G5, G5, G7, -G7]

B1 = [0; 0; 0; 0; 0; Vs; 0; 0]

V1 = N1\B1

voltages1 = textable (V1, "rlines", "clines", "align", "c");
v1_rep = strfind(voltages1, "&");
for j = 1:length(v1_rep)
	voltages1(v1_rep(1)) = "";
	v1_rep = strfind(voltages1, "&");
endfor

filename = "voltages1.tex";
fid = fopen(filename, "w");
fputs(filename, voltages1);
fclose(fid);

T1 = [R1, 0, 0; 0, R2, 0; 0, 0, R3]; C1 = [V1(1)-V1(2); V1(3)-V1(2); V1(7)-V1(8)];

I1 = T1\C1;

I1 = [I1(1,1); I1(2,1); 0; I1(3,1)];

currents1 = textable (I1, "rlines", "clines", "align", "c");
i1_rep = strfind(currents1, "&");
for j = 1:length(i1_rep)
	currents1(i1_rep(1)) = "";
	i1_rep = strfind(currents1, "&");
endfor

filename = "currents1.tex";
fid = fopen(filename, "w");
fputs(filename, currents1);
fclose(fid);

%%-------------------------------------------------------------------------
%%Question 2 Nodal Analysis
%%-------------------------------------------------------------------------

Vx = V1(6)-V1(8)

filename = "Vx.tex";
fid = fopen(filename, "w");
fputs(filename, num2str(Vx));
fclose(fid);

printf("\n\nNodal Analysis\n\n");
N2 = [G1, -G1-G2-G3, G2, 0, G3, 0, 0, 0; 0, Kb+G2, -G2, 0, -Kb, 0, 0, 0; 0, 0, 0, 0, 0, 1,0, -1; 0, 0, 0, G6, 0, 0, -G6-G7, G7; 0, 0, 0, 1, 0, 0, 0, 0; 1, 0, 0, -1, 0, 0, 0, 0; 0, 0, 0, Kd*G6, -1, 0, -Kd*G6, 1; G1, -G1, 0, G4+G6, -G4, 0, -G6, 0]

B2 = [0; 0; Vx; 0; 0; 0; 0; 0]

V2 = N2\B2

voltages2 = textable (V2, "rlines", "clines", "align", "c");
v2_rep = strfind(voltages2, "&");
for j = 1:length(v2_rep)
	voltages2(v2_rep(1)) = "";
	v2_rep = strfind(voltages2, "&");
endfor

filename = "voltages2.tex";
fid = fopen(filename, "w");
fputs(filename, voltages2);
fclose(fid);

Ix = (V2(6)-V2(5))/R5
Req = Vx/Ix

filename = "Ix.tex";
fid = fopen(filename, "w");
fputs(filename, num2str(Ix));
fclose(fid);

filename = "Req.tex";
fid = fopen(filename, "w");
fputs(filename, num2str(Req));
fclose(fid);

%%-------------------------------------------------------------------------
%%Question 3 Natural Response
%%-------------------------------------------------------------------------

function [y] = V6n(Vx, R5, C, t)
	y = Vx.*exp(-t./(R5.*C));
endfunction

t = 0:0.0001:0.02;
hf = figure ();
plot (t, V6n(Vx, R5, C, t));
hold on;
xlabel ("Time (ms)");
ylabel ("Voltage (V)");
title ("Natural solution of V6");
saveas(hf, "natural")


%%-------------------------------------------------------------------------
%%Question 4 Forced Response
%%-------------------------------------------------------------------------

omega = 2*pi*1000
Yc = i*omega*C

N3 = [G1, -G1-G2-G3, G2, 0, G3, 0, 0, 0; 0, Kb+G2, -G2, 0,-Kb, 0, 0, 0; 0, Kb, 0, 0, -Kb-G5, Yc+G5, 0, -Yc; 0, 0, 0, G6, 0, 0, -G6-G7, G7; 0, 0, 0, 1, 0, 0, 0, 0; 1, 0, 0, -1, 0, 0,0, 0; 0, 0, 0, Kd*G6, -1, 0, -Kd*G6, 1; 0, G3, 0, G4, -G3-G4-G5, G5+Yc, G7, -G7-Yc]

B3 = [0; 0; 0; 0; 0; 1; 0; 0]

V3 = N3\B3
V3_mag = abs(V3);
v6m = abs(V3(6));
v6ph = arg(V3(6));

voltages3 = textable (V3_mag, "rlines", "clines", "align", "c");
v3_rep = strfind(voltages3, "&");
for j = 1:length(v3_rep)
	voltages3(v3_rep(1)) = "";
	v3_rep = strfind(voltages3, "&");
endfor

filename = "v3_mag.tex";
fid = fopen(filename, "w");
fputs(filename, voltages3);
fclose(fid);

%%-------------------------------------------------------------------------
%%Question 5 Total Response
%%-------------------------------------------------------------------------

x = -0.005:0.00005:0.02;

function [y] = v6f(x, v6m, v6ph, Vx, R5, C)
	if x >= 0
		y = v6m.*sin(6283.18530717958.*x + v6ph) + Vx.*exp(-x./(R5.*C));
	else
		y = v6m.*sin(v6ph) + Vx;
	endif
endfunction

results1 = zeros(1, size(x,2));

w = 1;
for j = x
	results1(1,w) = v6f(x(1,w), v6m, v6ph, Vx, R5, C)
	w = w + 1;
endfor

function [y] = Vss(x, Vs)
	if x >= 0
		y = sin(6283.18530717958.*x);
	else
		y = Vs;
	endif
endfunction

results2 = zeros(1, size(x,2));

w = 1;
for j = x
	results2(1,w) = Vss(x(1,w), Vs);
	w = w + 1;
endfor

hf = figure();
plot(x, results1);
hold on;
plot(x, results2);
grid on;
xlabel("Time (ms)");
ylabel("Voltage (V)");
title("Final total solution V6f(t) and voltage source Vs(t)");
legend("V6f(t)","Vs(t)", "location", "northwestoutside");
print(hf, "plot.pdf");


%%-------------------------------------------------------------------------
%%Question 6 Frequency Response
%%-------------------------------------------------------------------------


syms w
Yc = i*w*C

N4 = [[G1, -G1-G2-G3, G2, 0, G3, 0, 0, 0]; [0, Kb+G2, -G2, 0,-Kb, 0, 0, 0]; [0, Kb, 0, 0, -Kb-G5, Yc+G5, 0, -Yc]; [0, 0, 0, G6, 0, 0, -G6-G7, G7]; [0, 0, 0, 1, 0, 0, 0, 0]; [1, 0, 0, -1, 0, 0,0, 0]; [0, 0, 0, Kd*G6, -1, 0, -Kd*G6, 1]; [0, G3, 0, G4, -G3-G4-G5, G5+Yc, G7, -G7-Yc]]

B4 = [0;0;0;0;0;1;0;0]

V4 = N4\B4

v6_m = abs(V4(6))
function [y] = v6m(v6_m, f)
	w = 2*pi*f	
	y = 20.*log10(eval(v6_m))
endfunction

v6_ph = arg(V4(6))
function [y] = v6ph(v6_ph, f)
	w = 2*pi*f	
	y = eval(v6_ph)*180/pi
endfunction

vc_m = abs(V4(6) - V4(8))
function [y] = vcm(vc_m, f)
	w = 2*pi*f	
	y = 20.*log10(eval(vc_m))
endfunction

vc_ph = arg(V4(6) - V4(8))
function [y] = vcph(vc_ph, f)
	w = 2*pi*f	
	y = eval(vc_ph)*180/pi
endfunction

f = logspace(-1, 6);
hg = figure();
semilogx(f, v6m(v6_m, f));
hold on;
semilogx(f, vcm(vc_m, f));
grid on;
xlabel ("frequency (Hz)");
ylabel ("Magnitude in dB (V)");
title ("Magnitude Bode Plot")
legend("v6m(f)","vcm(f)", "location", "northwestoutside");
saveas(hg, "theory_mag.pdf");

hi = figure();
semilogx(f, v6ph(v6_ph, f));
hold on;
semilogx(f, vcph(vc_ph, f));
grid on;
xlabel ("frequency (Hz)");
ylabel ("Phase (degrees)");
title ("Phase Bode Plot")
legend("v6ph(f)","vcph(f)", "location", "northwestoutside");
saveas(hi, "theory_ph.pdf");

