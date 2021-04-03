close all
clear all
format long
pkg load miscellaneous
%%Define the circuit constants

%%Voltage Source
Vs = 5.00662232904

%%Capacitance
C = 1.017087542350000e-06

%%Resistances and conductances
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

%%Depdency constants
Kb = 7.32769926486e-3
Kd = 8.37701206687e3

%%-------------------------------------------------------------------------
%%Question 1 Nodal Analysis
%%-------------------------------------------------------------------------

printf("\n\nNodal Analysis\n\n");
N1 = [G1, -G1-G2-G3, G2, 0, G3, 0, 0, 0; 0, Kb+G2, -G2, 0, -Kb, 0, 0, 0; 0, Kb, 0, 0, -Kb-G5, G5, 0, 0; 0, 0, 0, G6, 0, 0, -G6-G7, G7; 0, 0, 0, 1, 0, 0, 0, 0; 1, 0, 0, -1, 0, 0,0, 0; 0, 0, 0, Kd*G6, -1, 0, -Kd*G6, 1; 0, G3, 0, G4, -G3-G4-G5, G5, G7, -G7]

B1 = [0; 0; 0; 0; 0; Vs; 0; 0]

V1 = N1\B1

voltages1 = textable (V1, "rlines", "clines", "align", "c");
v1_rep = strfind(voltages1, "&");
for i = 1:length(v1_rep)
	voltages1(v1_rep(1)) = "";
	v1_rep = strfind(voltages1, "&");
endfor

filename = "voltages1.tex";
fid = fopen(filename, "w");
fputs(filename, voltages1);
fclose(fid);

%%-------------------------------------------------------------------------
%%Question 2 Nodal Analysis
%%-------------------------------------------------------------------------

Vx = V1(6)-V1(8)

printf("\n\nNodal Analysis\n\n");
N2 = [G1, -G1-G2-G3, G2, 0, G3, 0, 0, 0; 0, Kb+G2, -G2, 0, -Kb, 0, 0, 0; 0, 0, 0, 0, 0, 1,0, -1; 0, 0, 0, G6, 0, 0, -G6-G7, G7; 0, 0, 0, 1, 0, 0, 0, 0; 1, 0, 0, -1, 0, 0, 0, 0; 0, 0, 0, Kd*G6, -1, 0, -Kd*G6, 1; G1, -G1, 0, G4+G6, -G4, 0, -G6, 0]

B2 = [0; 0; Vx; 0; 0; 0; 0; 0]

V2 = N2\B2

voltages2 = textable (V2, "rlines", "clines", "align", "c");
v2_rep = strfind(voltages2, "&");
for i = 1:length(v2_rep)
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
for i = 1:length(v3_rep)
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

function [y] = v6f(x, v6m, v6ph)
	y = v6m.*sin(6283.18530717958.*x + v6ph)
endfunction

x = 0:0.0001:0.02;
hf = figure();
plot(x, v6f(x, v6m, v6ph));
hold on;
plot(x, sin(6283.18530717958.*x));
print(hf, "plot.pdf", "-dpdflatexstandalone");

