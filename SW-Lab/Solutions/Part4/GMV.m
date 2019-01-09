% GMV Example of a generalised minimum variance 
%     controller
%

% Clear the previous set of parameters
clear; clc

% System parameters
a1 = -1.5;
a2 = 0.7; 
b0 = 0.9;	

% Zero previous input and output variables
yt_1 = 0; yt_2 = 0; ut_1 = 0; 

% Input to the system is a step 
rt = 1; start = 25;

% Request the controller weights
Pw = input('Enter the weighting Pw : ');
Qw = input('Enter the weighting Qw : ');
Rw = input('Enter the weighting Rw : ');

rt=[1*ones(25,1);-1*ones(25,1);1*ones(25,1);-1*ones(25,1)];

noise=0.025*randn(100,1);
var(noise)

for i= 1:100
%	Change the reference signal
% 	if i == start
% 	  rt = -1;
% 	end

%	System model
	yt = -a1*yt_1 - a2*yt_2 + b0*ut_1 + noise(i);

%	Controller
	if (i >=start)
	  ut = (Pw*(a1*yt + a2*yt_1) + Rw*rt(i))/(Pw*b0 + Qw);
	else
	  ut = rt(i);
	end

% 	Time shift the variables
	yt_2 = yt_1;
	yt_1 = yt;
	ut_1 = ut;

%	Store the output of the system
	store(i,1) = yt;
    store1(i,1) = ut;
end

% Clear the graphics screen
figure(1),hold on
subplot(211),plot(store),xlabel('Iterations'),grid,ylabel('System response');
subplot(212),plot(store1),axis tight,xlabel('Iterations'),grid,ylabel('Control effort');
figure(2),hist(store-rt,20)