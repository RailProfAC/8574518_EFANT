%% Vorbereitung
clear all, close all, clc
%% Aufgabe 1
a = [1 1.1 10];
b = [1 3];

sys = tf(b,a)

sys_ss = ss(sys)

step(sys_ss)
%% Aufgabe 2
