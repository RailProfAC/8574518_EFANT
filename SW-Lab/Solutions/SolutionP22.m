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

% Input signal
n = 500;
tmax = 30;
simin.time = linspace(0,tmax,n);
simin.signals.values= idinput(n,'prbs');
noise.time = linspace(0,tmax,n);
noise.signals.values= [0.5*randn(n,1)];
var.signals.dimensions=[n,1];
% Run Simulink-File
sim('SolutionP2.mdl')

figure
subplot(311)
plot(simout.time, simout.Data(:,[1,2,6]))
legend('u', 'y_0', 'y_n')
subplot(312)
plot(simout.time, simout.Data(:,[2,5]))
legend('x_1','x_{1,hat}')
subplot(313)
plot(simout.time, simout.Data(:,[3,4]))
legend('x_2', 'x_{2,hat}')

