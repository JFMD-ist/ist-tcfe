close all
clear all
format long
%%Define the circuit constants

filename = "../doc/Data.txt";
fid = fopen(filename, "r");
data = dlmread(filename);
fclose(fid);

%Resisances and conductances
R1 = data(1)
G1 = 1/R1
R2 = data(2)
G2 = 1/R2
R3 = data(3)
G3 = 1/R3
R4 = data(4)
G4 = 1/R4
R5 = data(5)
G5 = 1/R5
R6 = data(6)
G6 = 1/R6
R7 = data(7)
G7 = 1/R7

%Voltage source
Vs = data(8)

%Capacitance
C = data(9)

%Dependency constants
Kb = data(10)
Kd = data(11)

%---------------------------------------------------------------------
%t2_1
%---------------------------------------------------------------------

filename = 't2_1.cir';
fid = fopen(filename, 'w');
fprintf(fid, ".OP \n\n");
fprintf(fid, "*Voltage source\n");
fprintf(fid, "vs 1 0 dc %f\n\n", Vs);
fprintf(fid, "*Capacitor\n");
fprintf(fid, "c1 6 8 %f%s\n\n", C, 'u');
fprintf(fid, "*Resistors\n");
fprintf(fid, "r1 1 2 %f%s\n", R1, 'k');
fprintf(fid, "r2 3 2 %f%s\n", R2, 'k');
fprintf(fid, "r3 2 5 %f%s\n", R3, 'k');
fprintf(fid, "r4 5 0 %f%s\n", R4, 'k');
fprintf(fid, "r5 5 6 %f%s\n", R5, 'k');
fprintf(fid, "r6 0 7 %f%s\n", R6, 'k');
fprintf(fid, "vr6 7 9 dc 0\n");
fprintf(fid, "r7 9 8 %f%s\n\n", R7, 'k');
fprintf(fid, "*VCCS\n");
fprintf(fid, "g1 6 3 2 5 %f%s\n\n", Kb, 'm');
fprintf(fid, "*CCVS\n");
fprintf(fid, "h1 5 8 vr6 %f%s\n\n", Kd, 'k');
fprintf(fid, ".END\n");
fclose(fid);

%---------------------------------------------------------------------
%t2_2
%---------------------------------------------------------------------

filename = "../doc/vx.txt";
fid = fopen(filename, "r");
Vx = dlmread(filename);
fclose(fid);

filename = 't2_2.cir';
fid = fopen(filename, 'w');
fprintf(fid, ".OP \n\n");
fprintf(fid, "*Voltage source\n");
fprintf(fid, "vs 1 0 dc 0\n\n");
fprintf(fid, "*Capacitor voltage source\n");
fprintf(fid, "vx 6 8 dc %f\n\n", Vx);
fprintf(fid, "*Resistors\n");
fprintf(fid, "r1 1 2 %f%s\n", R1, 'k');
fprintf(fid, "r2 3 2 %f%s\n", R2, 'k');
fprintf(fid, "r3 2 5 %f%s\n", R3, 'k');
fprintf(fid, "r4 5 0 %f%s\n", R4, 'k');
fprintf(fid, "r5 5 6 %f%s\n", R5, 'k');
fprintf(fid, "r6 0 7 %f%s\n", R6, 'k');
fprintf(fid, "vr6 7 9 dc 0\n");
fprintf(fid, "r7 9 8 %f%s\n\n", R7, 'k');
fprintf(fid, "*VCCS\n");
fprintf(fid, "g1 6 3 2 5 %f%s\n\n", Kb, 'm');
fprintf(fid, "*CCVS\n");
fprintf(fid, "h1 5 8 vr6 %f%s\n\n", Kd, 'k');
fprintf(fid, ".END\n");
fclose(fid);

%---------------------------------------------------------------------
%t2_3
%---------------------------------------------------------------------

filename = 't2_3.cir';
fid = fopen(filename, 'w');
fprintf(fid, ".OP \n\n");
fprintf(fid, "*Voltage source\n");
fprintf(fid, "vs 1 0 dc 0\n\n");
fprintf(fid, "*Capacitor\n");
fprintf(fid, "c1 6 8 %f%s\n\n", C, 'u');
fprintf(fid, "*Resistors\n");
fprintf(fid, "r1 1 2 %f%s\n", R1, 'k');
fprintf(fid, "r2 3 2 %f%s\n", R2, 'k');
fprintf(fid, "r3 2 5 %f%s\n", R3, 'k');
fprintf(fid, "r4 5 0 %f%s\n", R4, 'k');
fprintf(fid, "r5 5 6 %f%s\n", R5, 'k');
fprintf(fid, "r6 0 7 %f%s\n", R6, 'k');
fprintf(fid, "vr6 7 9 dc 0\n");
fprintf(fid, "r7 9 8 %f%s\n\n", R7, 'k');
fprintf(fid, "*VCCS\n");
fprintf(fid, "g1 6 3 2 5 %f%s\n\n", Kb, 'm');
fprintf(fid, "*CCVS\n");
fprintf(fid, "h1 5 8 vr6 %f%s\n\n", Kd, 'k');
fprintf(fid, ".END\n");
fclose(fid);

%---------------------------------------------------------------------
%t2_4
%---------------------------------------------------------------------

filename = 't2_4.cir';
fid = fopen(filename, 'w');
fprintf(fid, ".OP \n\n");
fprintf(fid, "*Voltage source\n");
fprintf(fid, "vs 1 0 sin(0 1 1k) ac 1\n\n");
fprintf(fid, "*Capacitor\n");
fprintf(fid, "c1 6 8 %f%s\n\n", C, 'u');
fprintf(fid, "*Resistors\n");
fprintf(fid, "r1 1 2 %f%s\n", R1, 'k');
fprintf(fid, "r2 3 2 %f%s\n", R2, 'k');
fprintf(fid, "r3 2 5 %f%s\n", R3, 'k');
fprintf(fid, "r4 5 0 %f%s\n", R4, 'k');
fprintf(fid, "r5 5 6 %f%s\n", R5, 'k');
fprintf(fid, "r6 0 7 %f%s\n", R6, 'k');
fprintf(fid, "vr6 7 9 dc 0\n");
fprintf(fid, "r7 9 8 %f%s\n\n", R7, 'k');
fprintf(fid, "*VCCS\n");
fprintf(fid, "g1 6 3 2 5 %f%s\n\n", Kb, 'm');
fprintf(fid, "*CCVS\n");
fprintf(fid, "h1 5 8 vr6 %f%s\n\n", Kd, 'k');
fprintf(fid, ".END\n");
fclose(fid);
