close all
clear all
format long


%%-------------------------------------------------------------------------
%%Envelope Detector
%%-------------------------------------------------------------------------
nt = (1/1.354)
R1 = 250e3;
R2 = 100e3;
C1 = 250e-6;
v_amp = 230*nt
t_off = (1/(100*pi))*atan(1/(100*pi*R1*C1))
numb = 20

function y = v_o(t, t_off, v_amp)
R1 = 100e3;
C1 = 100e-6;
np = floor(t/0.01);
y1 = abs(v_amp*cos(100*pi*t));
y2 = v_amp*cos(200*pi*(t_off+np*0.01))*exp(-(t-(t_off+np*0.01))/(R1*C1));
if (y1 > y2)
y = y1;
else
y = y2;
endif
endfunction

t = 0:1e-4:0.01*numb;
ed = [];
for j = 1:1:size(t,2)
ed = horzcat(ed, v_o(t(1, j), t_off, v_amp));
endfor

he = figure();
plot(t, ed);
hold on;
plot(t, abs(v_amp*cos(100*pi*t)));
grid on;
xlabel("Time (ms)");
ylabel("Voltage (V)");
title("Envelope Detector Output");
legend("v_{ED}(t)", "v_S(t)", "location", "northwestoutside");
print(he, "ed.pdf");

%%-------------------------------------------------------------------------
%%Voltage Regulator
%%-------------------------------------------------------------------------


function y = r(v, v_o)
R2 = 100e3;
Is = 1e-14;
Vt = 0.0258649170201;
n = 18;
f = v + R2*Is*(exp(v/(n*Vt))-1)-v_o;
df = 1 + ((R2*Is)/(n*Vt))*exp(v/(n*Vt));
y = f/df;
endfunction


function y = nr(v_o)
nr_m = 20;
nr_n = nr_m - r(nr_m, v_o);
while (abs(nr_m - nr_n) > 1e-8)
nr_m = nr_n;
nr_n = nr_m - r(nr_m, v_o);
endwhile
y = nr_n;
endfunction

v = 0;
vr=[];
for j=1:1:size(t,2)
vo = v_o(t(1,j), t_off, v_amp);
vr = horzcat(vr, nr(vo)); 	
disp(j)
endfor

sum = 0;
for j=1:1:size(vr, 2)
sum = sum + vr(1, j);
endfor
average = sum/size(vr, 2);

offset = average - 12
ripple = max(vr) - min(vr)
cost = 2.2 + R1/1000 + R2/1000 + C1*1000000
merit = 1/(cost*(ripple + abs(offset) + 1e-6))

table_end = '\\ \hline';

filename = "output.tex";
fid = fopen(filename, "w");
fprintf(fid, "\\begin{tabular}{|c|c|}\n");
fprintf(fid, "\\hline\n");
fprintf(fid, "Mean (v4) - 12 & %f %s\n", offset, table_end);
fprintf(fid, "Ripple  & %f %s\n", ripple, table_end);
fprintf(fid, "Cost of the components  & %f %s\n", cost, table_end);
fprintf(fid, "Merit figure & %f %s\n", merit, table_end);
fprintf(fid, "\\end{tabular}\n");
fclose(fid);

vr12 = [];
for j=1:1:size(vr, 2)
vr12 = horzcat(vr12, vr(1, j) - 12);
endfor

hf = figure();
plot(t, ed);
hold on;
plot(t, 230*cos(100*pi*t));
hold on;
plot([0, 0.01*numb], [12, 12]);
hold on;
plot(t, vr)
grid on;
xlabel("Time (ms)");
ylabel("Voltage (V)");
title("Envelope Detector and Voltage Regulator Outputs");
legend("v_{ED}(t)", "v_S(t)", "12V", "v_O(t)", "location", "northwestoutside");
print(hf, "ed+vr_th.pdf");

hg = figure();
plot(t, vr12);
grid on;
xlabel("Time (ms)");
ylabel("Voltage (V)");
title("Voltage Regulator Output (offset by - 12V)");
legend("v_o(t) - 12", "location", "northwestoutside");
print(hg, "vo_th.pdf");

hi = figure();
plot(t, vr);
hold on;
plot(t, 230*cos(100*pi*t));
grid on;
xlabel("Time (ms)");
ylabel("Voltage (V)");
title("Input and Output Voltage");
legend("v_O(t)", "v_S(t)","location", "northwestoutside");
print(hi, "converter_th.pdf");
