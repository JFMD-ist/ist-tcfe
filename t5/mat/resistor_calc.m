close all
clear all
format long

%-------------------------------------------------------------------------
%Resistors
%-------------------------------------------------------------------------

%Rt is the value which we want to get out of this
Rt = input("Rt (in ohms) = ");
nR1 = input("Number of 1k resistors = ");
nR2 = input("Number of 10k resistors = ");
nR3 = input("Number of 100k resistors = ");
err = 1000000000;
tries = 10000;


while(tries>=0)
	tries -= 1;
	n = round((nR1+nR2+nR3-1)*rand(1))+1; 
	n1 = round(nR1*rand(1));  %the numbers inside the round function are the number of resistors of that type which are available (in this case 3 of 1k, 3 of 10k, and 3 of 100k)
	n2 = round(nR2*rand(1));
	n3 = round(nR3*rand(1));

	rn1 = [];
	rn2 = [];
	rn3 = [];
	for i=1:1:n
		rn1 = horzcat(rn1, 0);
		rn2 = horzcat(rn2, 0);
		rn3 = horzcat(rn3, 0);
	endfor

	if(n1>0)
		for i=1:1:n1
			a = round((n-1)*rand(1))+1;
			rn1(a) += 1;
		endfor
	endif
	if(n2>0)
		for i=1:1:n2
			a = round((n-1)*rand(1))+1;
			rn2(a) += 1;
		endfor
	endif
	if(n3>0)
		for i=1:1:n3
			a = round((n-1)*rand(1))+1;
			rn3(a) += 1;
		endfor
	endif

	R = 0;
	for i=1:1:n
		if(rn1(i)+rn2(i)+rn3(i)>0)
			R += 1/(rn1(i)/1000 + rn2(i)/10000 + rn3(i)/100000);
		endif
	endfor

	if(abs(Rt - R) < err)
		err = abs(Rt - R)
		Rb = R;
		b = rn1;
		c = rn2;
		d = rn3;
	endif
endwhile

disp(Rb)   %Rb is the best aproximation to the value of the resistance
disp(b)    %b c and d are the resistor choices for each of the branches (a column of 1 2 1 means we have 1 1k, 2 10k and 1 100k ohm resistors in parallel in that branch)
disp(c)
disp(d)

