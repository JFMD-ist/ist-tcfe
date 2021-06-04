close all
clear all
format long

%-------------------------------------------------------------------------
%Capacitors
%-------------------------------------------------------------------------

%Ct is the value which we want to get out of this
Ct = input("Ct (in nF) = ");
nC1 = input("Number of 220n capacitors = ");
nC2 = input("Number of 1u capacitors = ");
err = 1000000000;
tries = 10000;

while(tries>=0)
	tries -= 1;
	n = round((nC1+nC2-1)*rand(1))+1; 
	n1 = round(nC1*rand(1));  %the numbers inside the round function are the number of capacitors of that type which are available (in this case 3 of 220nF and 3 of 1uF)
	n2 = round(nC2*rand(1));

	cn1 = [];
	cn2 = [];
	for i=1:1:n
		cn1 = horzcat(cn1, 0);
		cn2 = horzcat(cn2, 0);
	endfor

	if(n1>0)
		for i=1:1:n1
			a = round((n-1)*rand(1))+1;
			cn1(a) += 1;
		endfor
	endif
	if(n2>0)
		for i=1:1:n2
			a = round((n-1)*rand(1))+1;
			cn2(a) += 1;
		endfor
	endif

	Cv = [];
	G = 0;
	for i=1:1:n
		Cv = horzcat(Cv, cn1(i)*220 + cn2(i)*1000);
	endfor
	for i=1:1:n
		if(Cv(i))
			G += 1/(Cv(i));
		endif
	endfor
	if(G>0)
		C = 1/G;
	endif	
	
	if(abs(Ct - C) < err)
		err = abs(Ct - C)
		Cb = C;
		b = cn1;
		c = cn2;
	endif
endwhile

disp(Cb)   %Cb is the best aproximation to the value of the capacitor
disp(b)    %b c and d are the capacitor choices for each of the branches (a column of 1 2 means we have 1 220nF and 2 1uF capacitors in parallel in that branch)
disp(c)

