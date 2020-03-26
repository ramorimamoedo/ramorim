%% define initial conditions for the two step nitrification model
% Gurkan Sin (GS)
% Department of Chemical Engineering, DTU
% July 29, 2015 

%% Define model parameters (reference Sin et al 2008)
YAOO  = 0.15; % range: 0.11 - 0.21 mgCOD/mgN 
mumaxAOO= 1.5 ; % range: 0.5 - 2.1 d-1
ks_AOO   = 0.5; %range: 0.14 - 1 mgNH4-N/L
ko_AOO   = 0.7;%range: 0.1 - 1.45 mgO/L
bAOO   = 0.1; %range: 0.07 - 0.3 d-1

YNOO  = 0.05; % 0.03 - 0.09 mgCOD/mgN
mumaxNOO= 0.5 ; %0.4 - 1.05 d-1
ks_NOO   = 1.5; %0.1 - 3 mgNO2-N/L
ko_NOO   = 1.45; %0.3 - 1.5 mgO/L
bNOO   = 0.12;%0.08 - 0.2 d-1

kla   = 360;  % d-1
o2sat = 8;  % mg O2/L at 25 C

par = [YAOO,mumaxAOO,ks_AOO,ko_AOO,bAOO,YNOO,mumaxNOO,ks_NOO,ko_NOO,bNOO,kla,o2sat];
parlo=[0.11 0.5 0.14 0.1 0.07 0.03 0.4 0.1 0.3 0.08];
parhi=[0.21 2.1 1.0 1.45 0.30 0.09 1.05 3.0 1.5 0.20];
%% define initial conditions for the experiments
x(1)= 20 ; %mgN/L for NH4 
x(2)= 0 ; % mgN/L for NO2
x(3)=0 ; % mgN/L for NO3
x(4)= 8 ; % mgO2/L for oxygen 
x(5)= 75 ; % mgCOD/L for AOO 
x(6)= 0 ; % mg COD/L for NOO

x0 = x; % set the initial conditions for the experiments