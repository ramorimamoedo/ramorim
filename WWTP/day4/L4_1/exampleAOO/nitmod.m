function dxdt = nitmod(t,x,par);
%% this is ODE implementatin of 2-step nitrification model
%
% Gurkan Sin (GS)
% Department of Chemical Engineering, DTU
% July 29, 2015 

YAOB  = par(1);
mumaxAOB= par(2);
ks_AOB   = par(3);
ko_AOB   = par(4);
bAOB   = par(5);

YNOB  = par(6);
mumaxNOB= par(7);
ks_NOB   = par(8);
ko_NOB   = par(9);
bNOB   = par(10);

kla  = par(11);
o2sat= par(12);
fxi=0.8;
%% ODE model equations
%step 1: NH4 + O_2 -->NO2  by AOB
%step 2: NO2 + 0.5O_2 -->NO3 by NOB
% definition of state variables: x(1): NH4 ; x(2): NO2;  x(3): NO3; x(4):O2; x(5):XAOB; x(6):XNOB.

% define growth rate for AOB & NOB respectively
muAOB=mumaxAOB*(x(1)/(x(1)+ks_AOB))*(x(4)/(x(4)+ko_AOB))*x(5); 
muNOB=mumaxNOB*(x(2)/(x(2)+ks_NOB))*(x(4)/(x(4)+ko_NOB))*x(6);

% define mass balances for batch reactor with pulse addition of substrates
dxdt(1,1)= (-1/YAOB)* muAOB ; % NH4 balance
dxdt(2,1)= (1/YAOB)* muAOB - (1/YNOB)* muNOB ; % NO2 balance 
dxdt(3,1)= (1/YNOB)* muNOB ; % NO3 balance 
dxdt(4,1)= (1 - 3.43/YAOB) * muAOB - bAOB*x(5)+ (1 - 1.14/YNOB) * muNOB - bNOB*x(6)+ kla * (o2sat-x(4)); % oxygen balance 
dxdt(5,1)= muAOB - bAOB*x(5); % AOB biomass
dxdt(6,1)= muNOB - bNOB*x(6); % NOB biomass



