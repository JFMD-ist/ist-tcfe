close all
clear all
format long
pkg load miscellaneous
pkg load symbolic

%%Defining the constants used
%Resistances and conductances
R1 = 1.03301019518e3
G1 = 1/R1
R2 = 2.0748608676e3
G2 = 1/R2
R3 = 3.05514376545e3
G3 = 1/R3 
R4 = 4.15047871791e3
G4 = 1/R4
R5 = 3.02449899207e3
G5 = 1/R5
R6 = 2.08776908673e3
G6 = 1/R6
R7 = 1.03338176153e3
G7 = 1/R7 

%Capacitance
C = 1.017087542350000e-06

%Depdency constants
Kb = 7.32769926486e-3
Kd = 8.37701206687e3

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

f = logspace(-1, 6);
hg = figure();
semilogx(f, v6m(v6_m, f));
xlabel ("frequency (Hz)");
ylabel ("Magnitude of v6");
title ("Magnitude Bode Plot")
print(hg, "magnitude.pdf", "-dpdflatexstandalone");

hi = figure();
semilogx(f, v6ph(v6_ph, f));
xlabel ("frequency (Hz)");
ylabel ("Phase of v6");
title ("Phase Bode Plot")
print(hi, "phase.pdf", "-dpdflatexstandalone");

