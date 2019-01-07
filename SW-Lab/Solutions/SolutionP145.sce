clear
delete(gcf())

// load the blocks library and the simulation engine
loadXcosLibs(); loadScicos();
// load diagram
importXcosDiagram("P1.zcos")

N = 1000; // time steps
tmax = 50; // final simulation time
time = linspace(0,tmax,N)'; // time axis
// Define input data for fromworkspace block
myInput.time = time; 
myInput.values = ones(time)+ 0*sin(time)+0*rand(time);
// System parameters
a1 = .2;
a0 = 1;
b0 = 1;
// Execute scicos diagram
scicos_simulate(scs_m)
// Plot data
plot2d(myOutput.time, myOutput.values)
legend('u', 'x1(t)', 'x2(t)')
