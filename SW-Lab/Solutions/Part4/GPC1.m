% GPC Generalised predictive controller for na = 2, nb = 1
%     and a control horizon of 4

% Clear the previous set of parameters
clear;

% Set the length of the simulation
stop = 50;

% System parameters
a1 = -1.5;
a2 = 0.7; 
b0 = 1;       
b1 = 0.5;

% Zero previous input and output variables
yt_1 = 0; yt_2 = 0;
ut_1 = 0; ut_2 = 0; 

% Input to the system is a step 
rt = 1; start = 25;

% Set up the reference vector
for i = 1:(stop + 10)
	if i == start
		rt = -1;
	end
	r(i) = rt;
end

% Determine the GPC parameters
a1bar = (1 - a1);
a2bar = (a1-a2);
a3bar = a2;
f10 = a1bar;            f11 = a2bar;            f12 = a3bar;
f20 = f11+a1bar*f10;    f21 = f12+a2bar*f10;    f22 = a3bar*f10;
f30 = f21+a1bar*f20;    f31 = f22+a2bar*f20;    f32 = a3bar*f20;
f40 = f31+a1bar*f30;    f41 = f32+a2bar*f30;    f42 = a3bar*f30;

lambda = input('lambda :');

for i= 1:stop

%       System model
	yt = -a1*yt_1 - a2*yt_2 + b0*ut_1 + b1*ut_2;

%       Controller
	if (i >=start-3)
%         GPC algorithm
	  rd1 = r(i+1) - (f10*yt + f11*yt_1 + f12*yt_2 + b1*(ut_1-ut_2));
	  rd2 = r(i+2) - (f20*yt + f21*yt_1 + f22*yt_2 + b1*(ut_1-ut_2));
	  rd3 = r(i+3) - (f30*yt + f31*yt_1 + f32*yt_2 + b1*(ut_1-ut_2));
	  rd4 = r(i+4) - (f40*yt + f41*yt_1 + f42*yt_2 + b1*(ut_1-ut_2));

	  ut = ut_1 + (b0*rd1 + rd2*(b0*f10+b1) + rd3*(b0*f20+f10*b1) + rd4*(f20*b1+f30*b0))/(b0^2 + (b1+f10*b0)^2 +(f10*b1+f20*b0)^2 + (f20*b1+f30*b0)^2+lambda);
	else
	  ut = r(i);
	end

%       Time shift the variables
	yt_2 = yt_1;
	yt_1 = yt;
	ut_2 = ut_1;
	ut_1 = ut;

%       Store the output of the system
	store(i,1) = yt;
	store(i,2) = ut;

end

% Clear the graphics screen
clf;
plot([store r(1:stop)']);
grid;
xlabel('Iterations'),ylabel('System response');
