% GPC Generalised predictive controller for na = 2, nb = 0
%     and a control horizon of 3
%
% P.J. King 8/6/94


% Clear the previous set of parameters
clear;

% Set the length of the simulation
stop = 150;

% System parameters
a1 = -1.5;
a2 = 0.7; 
b0 = 0.9;
b1=.35;
n1=.1;

% Zero previous input and output variables
y=zeros(2,1);
u=zeros(2,1);

% Set up the reference vector
r=[ones(1,25),-ones(1,25),4.*ones(1,25+5), ones(1,25),-ones(1,25),4.*ones(1,25+5)];

% Determine the GPC parameters
a1bar = (1 - a1);
a2bar = (a1-a2);
a3bar = a2;

f1=[a1bar, a2bar, a3bar];
f10 = a1bar; 		f11 = a2bar;		f12 = a3bar;
f20 = f11+a1bar*f10;	f21 = f12+a2bar*f10;	f22 = a3bar*f10;
f30 = f21+a1bar*f20;	f31 = f22+a2bar*f20;	f32 = a3bar*f20;
f40=  f31+a1bar*f30;    f41=  f32+a2bar*f30;    f42=  a3bar*f30;

lambda = 0.1;

noise=.15*randn(stop,1);

g1=b1; g2=f10*b1; g3=f20*b1; 
g4=f30*b1;

for i= 3:stop

%	System model
	y(i,1) = -a1*y(i-1) - a2*y(i-2) + b0*u(i-1)+ + b1*u(i-2) + n1*y(i-1)*u(i-1) + noise(i);

%	Controller
	if (i >=5)
%	  GPC algorithm
	  rd1 = r(i+1) - (f10*y(i) + f11*y(i-1) + f12*y(i-2)) + g1*(u(i-1)-u(i-2));
	  rd2 = r(i+2) - (f20*y(i) + f21*y(i-1) + f22*y(i-2)) + g2*(u(i-1)-u(i-2));
	  rd3 = r(i+3) - (f30*y(i) + f31*y(i-1) + f32*y(i-2)) + g3*(u(i-1)-u(i-2));
  	  rd4 = r(i+4) - (f40*y(i) + f41*y(i-1) + f42*y(i-2)) + g4*(u(i-1)-u(i-2));

%     rd14 = r(i+1:i+4) - f1*y(i:i-2) + g1*(u(i-1)-u(i-2));  
% 	  rd2 = r(i+2) - (f20*y(i) + f21*y(i-1) + f22*y(i-2)) + g2*(u(i-1)-u(i-2));
% 	  rd3 = r(i+3) - (f30*y(i) + f31*y(i-1) + f32*y(i-2)) + g3*(u(i-1)-u(i-2));
%     rd4 = r(i+4) - (f40*y(i) + f41*y(i-1) + f42*y(i-2)) + g4*(u(i-1)-u(i-2));
      
      
	  %u(i) = u(i-1) + (b0*(rd1 + rd2*f10 + rd3*f20 + rd4*f30))/(b0*b0*(1 + f10^2 + f20^2 + f30^2) + lambda);
      u(i) = u(i-1) + (b0*(rd1 + rd2*f10 + rd3*f20 + rd4*f30))/((b0^2 + (b0*f10)^2 + (g2+f20*b0)^2 + (g3+f30*b0)^2) + lambda);
	else
	  u(i) = r(i);
    end

end

% Clear the graphics screen
figure(2),plot(1:stop,r(1:stop),1:stop,u,1:stop,y);
legend('Reference', 'Input', 'Output')
xlabel('Iterations'),ylabel('System response');