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

syms w
Yc = i*w*C

N = [[G1, -G1-G2-G3, G2, 0, G3, 0, 0, 0]; [0, Kb+G2, -G2, 0,-Kb, 0, 0, 0]; [0, Kb, 0, 0, -Kb-G5, Yc+G5, 0, -Yc]; [0, 0, 0, G6, 0, 0, -G6-G7, G7]; [0, 0, 0, 1, 0, 0, 0, 0]; [1, 0, 0, -1, 0, 0,0, 0]; [0, 0, 0, Kd*G6, -1, 0, -Kd*G6, 1]; [0, G3, 0, G4, -G3-G4-G5, G5+Yc, G7, -G7-Yc]]

B = [0;0;0;0;0;1;0;0]

V = N\B

v6_m = abs(V(6))
function [y] = v6m(v6_m, f)
	w = 2*pi*f	
	y = 20.*log10(eval(v6_m))
endfunction

v6_ph = arg(V(6))
function [y] = v6ph(v6_ph, f)
	w = 2*pi*f	
	y = eval(v6_ph)*180/pi
endfunction

vc_m = abs(V(6) - V(8))
function [y] = vcm(vc_m, f)
	w = 2*pi*f	
	y = 20.*log10(eval(vc_m))
endfunction

vc_ph = arg(V(6) - V(8))
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
ylabel ("Magnitude of v6");
title ("Magnitude Bode Plot")
print(hg, "magnitude", "-depsc");

hi = figure();
semilogx(f, v6ph(v6_ph, f));
hold on;
semilogx(f, vcph(vc_ph, f));
grid on;
xlabel ("frequency (Hz)");
ylabel ("Phase of v6");
title ("Phase Bode Plot")
print(hi, "phase", "-depsc");

