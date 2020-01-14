%% Prepare

clear all, close all, clc
global A

%% Task 1
% System equations
b = [1 3];
a = [1 0 1];
% Transfer function model to check
%systf = tf([1 3],[1 -.1 1])
% Convert to state space
[A,B,C,D] = tf2ss(b,a);

sys = ss(A,B,C,D)
figure
step(sys, 20)

%% Task 2
% Rank of controllability and observability matrices
Cont = rank([sys.B, sys.A*sys.B])
ContU = rank([sys.C*sys.B, sys.C*sys.A*sys.B])
Obs = rank([sys.C; sys.C*sys.A])

%% Task 3
% Make system matrix global
A = sys.A;
% Function to calculate derivatives
xdot = @(x) A*x;

% Range and resolution
res = 21;
x1 = linspace(-1, 1, res);
x2 = linspace(-1, 1, res);
[X1, X2] = meshgrid(x1,x2);
x = [reshape(X1, [1, res*res]);reshape(X2, [1, res*res])];
y = xdot(x); %A*x
% System Trajectory
t = linspace(0,10);
[ytra, t, xtra] = lsim(sys, zeros(size(t)), t, rand(2,1));
% Plot
figure
quiver(X1, X2, reshape(y(1,:), [res,res]), reshape(y(2,:), [res, res]));
hold on
plot(xtra(:,1), xtra(:,2))
%axis equal

%% Task 4
% System parameters
a0 = 1;
a1 = 5;
b0 = 1;

% Input signal
n = 500;
tmax = 30;
simin.time = linspace(0,tmax,n);
simin.signals.values= [ones(1,n)'];
var.signals.dimensions=[n,1];

sim('SolutionP145.mdl')
figure
plot(simout.time, simout.Data)
legend('u', 'x_1', 'x_2')

