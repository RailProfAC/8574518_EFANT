% KF state estimation using the Kalman filter
clear all; close all, clc;

% System parameters
a1 = -1.5; a2 = 0.7; b0 = 0.9;	

% Input to the system is a step 
start = 25;

% set up initial vectors
n = 2;  % Numbers of parameters in A
N = 200;   % Set the number of samples
sigma = 3;  % Noise variance

% Define the noise
noise=randn(N,1); noise=sigma*(noise-mean(noise));
u=[-1*ones(start,1);ones(N-start,1)];
u = sin(.1*(1:N));
y=zeros(3,1);
%	Create system ouput
for t= 3:N,
    y(t,1) = -a1*y(t-1) - a2*y(t-2) + b0*u(t-1);
end
y0 = y;
y = y + noise;

A = [0 -a2-0.1
    1 -a1];
B = [0 b0]';
C = [0 1]';

% Set up the matrices and vectors for Kalman filter
x = zeros(n,1);
P = eye(n)*10000;

% Noise information
rv = 1;  Rw = 0.01*eye(n); xSave=[];

for t= 3:N
%	Kalman filter
%	Prediction
	x = A*x + B*u(t-1); % x^(t+1|t)= P x(t|t) + Q u(t)
    % Rw process noise covariance matrix
 	P = A*P*A' + Rw; % phi(t+1|t) = P phi(t|t) P' + Rw
%	Correction
    % rv ouput noise variance
	K = P*C/(rv + C'*P*C); % K(t+1) = [phi(t+1|t) H' ] / [rv + H phi(t+1|t) H']
	x = x + K*(y(t) - C'*x); % x^(t+1|t+1) = x^(t+1|t) + K(t+1) [y(t+1) - H x^(t+1|t)]
	P = (eye(n) - K*C')*P; % phi(t+1|t+1) = [I - K(t) H] phi(t+1|t)
    xSave=[xSave, x];
end

W = 400;
H = 500;
L = 2;

h = figure(1);
set(h, 'PaperUnits', 'point')
set(h, 'PaperSize', [W,H]);
set(h, 'PaperPosition', [0 0 W H]);
plot([1:N],y, 'LineWidth', L)
hold on
plot([3:N], xSave(2, :),'LineWidth', L)
plot([1:N],y0, 'LineWidth', L)
plot([1:N],u, 'LineWidth', L)
xlabel('Iterations')
ylabel('System response')
ylim([-10 10])
legend('y_{meas}', 'y_{est}', 'y_{true}','u');
FS = findall(h, '-property', 'Fontsize');
set(FS, 'FontSize', 14);
%print(h, 'kalman.pdf');
