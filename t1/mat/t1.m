close all
clear all
format long
pkg load miscellaneous
%%Define the circuit constants

%%Sources
Va = 5.00662232904
Id = 1.01708754235e-3

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
Kc = 8.37701206687e-3

%%Mesh Analysis
printf("\n\nMesh Analysis\n\n");
M = [R1+R3+R4, R3, R4, 0; Kb*R3, Kb*R3 - 1, 0, 0; R4, 0, R4+R6+R7-Kc, 0; 0, 0, 0, 1]
Bm = [Va; 0; 0; Id]

I = M\Bm

currents = textable (I, "rlines", "clines", "align", "c");
c_rep = strfind(currents, "&");
for i = 1:length(c_rep)
	currents(c_rep(1)) = "";
	c_rep = strfind(currents, "&");
endfor

filename = "currents.tex";
fid = fopen(filename, "w");
fputs(filename, currents);
fclose(fid);

%%Nodal Analysis
printf("\n\nNodal Analysis\n\n");
N = [0, G1, -(G1+G2+G3), G2, 0, 0, 0, G3; 0, 0, Kb+G2, -G2, 0, 0, 0, -Kb; 0, 0, Kb, 0, G5, 0, 0, -(Kb+G5); 0, 0, 0, 0, 0, G7, -(G6+G7), 0; 0, 1, 0, 0, 0, 0, 0, 0; 0, 0, 0, 0, 0, -1, Kc*G6, 1; 0, R4*G1, -R4*G1, 0, 0, 0, -R4*G6, -1; 1, 0, 0, 0, 0, 0, 0, 0]
Bn = [0; 0; Id; 0; Va; 0; 0; 0]

V = N\Bn

voltages = textable (V, "rlines", "clines", "align", "c");
v_rep = strfind(voltages, "&");
for i = 1:length(v_rep)
	voltages(v_rep(1)) = "";
	v_rep = strfind(voltages, "&");
endfor

filename = "voltages.tex";
fid = fopen(filename, "w");
fputs(filename, voltages);
fclose(fid);
