clear
delete(gcf())

// load the blocks library and the simulation engine
loadXcosLibs(); loadScicos();

importXcosDiagram("P2.zcos")
//load P2.zcos
N = 100;
tmax = 10;
time = linspace(0,tmax,N)';
myInput.time = time;
myInput.values = ones(time)+ 0*sin(time)+0.2*rand(time);

A = [-5, 1 0; 0, -2, 1; 20, -10, 1];
B = [0; 0; 1];
C = [-1, 1, 0];

scicos_simulate(scs_m)//, list());


plot2d(myOutput.time, myOutput.values)
