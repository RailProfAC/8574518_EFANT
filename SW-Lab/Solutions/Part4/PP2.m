% PP2 compares polynomial pole-placement and state-space
%     pole-placement controllers
%

% Clear the previous set of parameters
close all; clear all; clc;

% System parameters
% a1 = -1.5; a2 = 0.7; b0 = 0.9;
a1 = -3.5; a2 = 1.5; b0 = 0.9;

% Zero previous input and output variables
yt_1 = 0; yt_2 = 0;
ut_1 = 0;

% Input to the system is a step
rt = 1; %start = 25; start2 =50;
start = 1; start2 =50;

% set up initial vectors
n = 3;
x = zeros(n,1); theta = x;

% Poles of the closed loop system
%p1 = 1/sqrt(2)+j/sqrt(2); p2 = 1/sqrt(2)-j/sqrt(2);
p1 = .5; p2 = .5;

gamma1 = -(p1 + p2); gamma2 = p1*p2;

N=1500;
%noise=0*(rand(N,1)-.5);%
noise=.2*(rand(N,1)-.5);
%noise=1*(rand(N,1)-.5);
var(noise)
InputConstraints=2;

for i= 1:N

    %	Change the reference signal
    if i == start
        rt = -1;
    end
    if i == start2
        rt =1;
    end

    %	System model
    yt = -a1*yt_1 - a2*yt_2 + b0*ut_1 + noise(i);

    %	Controller
    if (i >=start)
        %	  Polynomial pole-placement controller
        g0 = -(gamma1 - a1)/b0;
        g1 = -(gamma2 - a2)/b0;
        m = (1 + gamma1 + gamma2)/b0;
        ut = g0*yt + g1*yt_1 + m*rt;

        %Whatitis='State-space pole-placement'
        % 	  x1 = -a2*yt_1;
        % 	  x2 = b0*ut_1 - a2*yt_2 - a1*yt_1;
        % 	  f1 = (gamma2-a2)/(a2*b0);
        % 	  f2 = -(gamma1 - a1)/b0;
        % 	  m = (1 + gamma1 + gamma2)/b0;
        % 	  ut = f1*x1 + f2*x2 + m*rt;


        if ut>InputConstraints, ut=InputConstraints; end
        if ut<-InputConstraints, ut=-InputConstraints; end
    else
        ut = rt;
    end

    % 	Time shift the variables
    yt_2 = yt_1;
    yt_1 = yt;
    ut_1 = ut;

    %	Store the output of the system
    store1(i,1) = yt;
    store2(i,1) = ut;

end

yt_1 = 0; yt_2 = 0;
ut_1 = 0;

for i= 1:N

    %	Change the reference signal
    if i == start
        rt = -1;
    end
    if i == start2
        rt =1;
    end

    %	System model
    yt = -a1*yt_1 - a2*yt_2 + b0*ut_1 + noise(i);

    %	Controller
    if (i >=start)
        %	  Polynomial pole-placement controller
        %  	  g0 = -(gamma1 - a1)/b0;
        %          g1 = -(gamma2 - a2)/b0;
        % 	  m = (1 + gamma1 + gamma2)/b0;
        % 	  ut = g0*yt + g1*yt_1 + m*rt;

        %Whatitis='State-space pole-placement'
        x1 = -a2*yt_1;
        x2 = b0*ut_1 - a2*yt_2 - a1*yt_1;
        f1 = (gamma2-a2)/(a2*b0);
        f2 = -(gamma1 - a1)/b0;
        m = (1 + gamma1 + gamma2)/b0;
        ut = f1*x1 + f2*x2 + m*rt;

        if ut>InputConstraints, ut=InputConstraints;  end
      if ut<-InputConstraints, ut=-InputConstraints; end
      
    else
        ut = rt;
    end

    % 	Time shift the variables
    yt_2 = yt_1;
    yt_1 = yt;
    ut_1 = ut;

    %	Store the output of the system
    store3(i,1) = yt;
    store4(i,1) = ut;

end

% Clear the graphics screen
%clg;
N1=1;
plot(N1:N,store1(N1:end),N1:N,store2(N1:end),N1:N,store3(N1:end),N1:N,store4(N1:end)),xlabel('Iterations'),ylabel('System response');%title(Whatitis)
axis tight, legend('ypp','upp','yss','uss')

figure(2), subplot(211),plot(abs(store1-store3)),title('difference between outputs poly-ss')
subplot(212),plot(abs(store2-store4)),title('difference between inputs poly-ss')