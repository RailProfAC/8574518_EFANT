% IGMV Example of a incremental generalised minimum variance 
%     controller
%

% Clear the previous set of parameters
clear; clc

% System parameters
a1 = -1.5;
a2 = 0.7; 
b0 = 0.9;	

% Model controller parameters = System parameteres
%a1c = a1; a2c = a2; b0c = b0;

% Default model controller paramters
a1c = -1.4;
a2c = 0.75; 
b0c = 1;

% Number of samples
N=100;

% Zero previous input and output variables
yt_1 = 0; yt_2 = 0; ut_1 = 0; 

% Input to the system is a step 
rt = 1; start = 25;

% Request the controller weights
Q=0.5%.1;

rt=[1*ones(25,1);-1*ones(25,1);1*ones(25,1);-1*ones(25,1)];

noise=0.025*randn(100,1);
var(noise)

for i= 1:N
    
%	System model
	yt = -a1*yt_1 - a2*yt_2 + b0*ut_1 + noise(i);

%	Controller
	if (i >=start)
	  dut = (b0*((a1c-1)*yt + (a2c-a1c)*yt_1 - a2c*yt_2) + rt(i))/(b0c^2 + Q^2);
	else
	  dut = 0;
      ut=rt(i);
	end

% 	Time shift the variables
	yt_2 = yt_1;
	yt_1 = yt;
	ut_1 = ut_1 + dut;

%	Store the output of the system
	savey(i,1) = yt;
    saveu(i,1) = ut+dut;
end

% Clear the graphics screen
figure(1),hold on
subplot(211),plot(1:N,rt,1:N,savey),legend('ref.','sys. rep.')
,xlabel('Iterations'),ylabel('System response'),grid;
subplot(212),plot(saveu),axis tight,xlabel('Iterations'),grid,ylabel('Control effort');hold off
figure(2),hist(savey-rt,20)