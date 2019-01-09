% PP1 Example of a pole-placement controller
%

% Clear the previous set of parameters
clear;

% System parameters
a1 = -1.5;
a2 = 0.7; 
b0 = 0.9;	

% Zero previous input and output variables
yt_1 = 0; yt_2 = 0;
ut_1 = 0; 

% Input to the system is a step 
rt = 1; start = 25; start2 =50;

% Poles of the closed loop system
j = sqrt(-1);
p1 = 0.75+j*0; p2 = 0.25+j*0;
gamma1 = -(p1 + p2); gamma2 = p1*p2;

for i= 1:75

%	Change the reference signal
	if i == start
	  rt = -1;
    end
    if i == start2
          rt =1;
      end   
  
%	System model
	yt = -a1*yt_1 - a2*yt_2 + b0*ut_1 + 0.025*rand;

%	Controller
	if (i >=start)
  	  g0 = -(gamma1 - a1)/b0; g1 = -(gamma2 - a2)/b0; 
	  m = (1 + gamma1 + gamma2)/b0;
	  ut = g0*yt + g1*yt_1 + m*rt;
	else
	  ut = rt;
	end

% 	Time shift the variables
	yt_2 = yt_1;
	yt_1 = yt;
	ut_1 = ut;

%	Store the output of the system
store(i,1) = ut;
store(i,2) = yt;

end

% Clear the graphics screen
clf;
plot(store),xlabel('Iterations'),ylabel('System response');
