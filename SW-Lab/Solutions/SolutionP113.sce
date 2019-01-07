clear
clc
clearglobal
mode(2)
delete(gcf())
global A

// Aufgabe 1
// s als Variable festlegen
s = syslin('c',poly(0,'s'),1)
//Uebertragungsfunktion eingeben
G=(s+3)/(s^2+1.1*s+10);
// In Transferfunktion ueberfuehren
Sys=tf2ss(G)
// Zeitachse
t = 0:0.025:10;
// Sprungantwort
ystep = csim('step', t, Sys)
plot2d(t, ystep)

//Aufgabe 2
// Rang der Steuerbarkeits- und Beobachtbarkeitsmatrizen
Cont = rank([Sys.B, Sys.A*Sys.B])
ContU = rank([Sys.C*Sys.B, Sys.C*Sys.A*Sys.B])
Obs = rank([Sys.C; Sys.C*Sys.A])

// Aufgabe 3
// Auf globale Variable umspeichern
A = Sys.A;
// Funktion zur Berechnung der Steigung
function xv=xdot(t, x)
    xv = A*x;
endfunction
// Bereich und Aufloesung
x1 = -1:0.2:1; x2 = -1:0.2:1;
// System-Trajektorie
[ytra, xtra] = csim(zeros(t), t, Sys, rand(2,1))

// Plot
scf(2)
fchamp(xdot, 0, x1, x2, arfact = 0.7);
plot2d(xtra(1,:), xtra(2,:), 2)
a = gca();
a.isoview = 'on'; 
a.x_location = "middle";
a.y_location = "middle";
