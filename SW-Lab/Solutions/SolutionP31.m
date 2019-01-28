%% Prepare

clear all, close all, clc
global A

%% Task 2
% System parameters
a1 = .2;
a0 = 1;
b0 = 1;
% State space formulation
A = [0, -a0;1, -a1];
B = [b0; 0];
C = [0 1];
%Luenberger observer matrix
L = [.2; .1];
% Controler gain
K = 2*[-.1,1];

eig(A-B*K)

% Input signal
n = 500;
tmax = 30;
simin.time = linspace(0,tmax,n);
simin.signals.values= [zeros(n/5,1); ones(n/5,1); zeros(n/5,1); -1*ones(n/5,1); zeros(n/5,1)];
noise.time = linspace(0,tmax,n);
noise.signals.values= [0.5*randn(n,1)];
var.signals.dimensions=[n,1];
% Run Simulink-File
sim('SolutionP3.slx')

figure
subplot(311)
plot(simout.time, simout.Data(:,[1,2,6,7]))
legend('u', 'y_0', 'y_n', 'r')
subplot(312)
plot(simout.time, simout.Data(:,[2,5]))
legend('x_1','x_{1,hat}')
subplot(313)
plot(simout.time, simout.Data(:,[3,4]))
legend('x_2', 'x_{2,hat}')

