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
simin.signals.values= idinput(n,'sine', [0 10]);
noise.time = linspace(0,tmax,n);
noise.signals.values= [0.05*randn(n,1)];
var.signals.dimensions=[n,1];

sim('SolutionP2.mdl')
figure
plot(simout.time, simout.Data)
legend('u', 'x_1', 'x_2', 'x_{1,hat}', 'x_{2,hat}')

