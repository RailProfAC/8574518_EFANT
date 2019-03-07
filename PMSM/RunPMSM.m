%% Prepare
clear all, close all, clc


%% Run PMSM
% System parameters
R1 = 10;
L1q = 1e-3;
L1d = 1e-4;
psi = 10;
p = 1;
J = 10;
kp = 100;
kpw = 100;

% Input signal
n = 500;
tmax = 300;
simin.time = linspace(0,tmax,n);
simin.signals.values= [300*ones(n,1), zeros(n,1), [zeros(n/2,1); 1*ones(n/2,1)]];
var.signals.dimensions=[n,3];

sim('PMSM.slx')
figure
plot(simout.time, simout.Data)
legend('\omega', 'M', 'i', 'u')

