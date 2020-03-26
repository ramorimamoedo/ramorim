% This is the script for smart & efficient Monte Carlo sampling for calculation of Sobol indices
% source: Satelli et al (2009) pp164-165

% June 25, 2016
% Gurkan Sin @DTU Chemical Engineering

clear
close all
h1=pwd;
%%step 1 perform sampling
%randomsampling
quasirandomsampling
%saveoutput
drn='results/step1';
mkdir(drn)
for i=1:2
    fg1 = strcat(['Sampling',num2str(i),'_',datestr(date,'ddmmmyy')]);
    f1 = fullfile(h1,drn,fg1) ;
    saveas(i,f1,'tiff') ;
end
flnm = strcat('Sampling_',[num2str(nsample),'_',datestr(date,'ddmmmyy'),'.mat']); 
f1 = fullfile(h1,drn,flnm); 
save(f1,'A','B')

%%step2 perform simulations
mcsims

drn='results/step2';
mkdir(drn)
fl=strcat('mcsims.mat');
f1 = fullfile(h1,drn,fl); 
%save(f1,'A','B','yA', 'y2A', 'y3A', 'yB', 'y2B', 'y3B', 'yAB', 'y2AB', 'y3AB',  'yBA', 'y2BA',  'y3BA' )

%%step 3 Computer Sobold indices
% compute Si and Sti for electricity output
%1: Sobol 2:Saltelli, 3:Jansen
disp('Compute Sobold indices for electricity output')
[Si1elec, Si2elec, Si3elec, STi1elec, STi2elec, STi3elec]   = ComputeSiandSTi(yA, yB, yBA, yAB) ;
%disp('Compute Sobold indices for gas output')
%[Si1gas, Si2gas, Si3gas, STi1gas, STi2gas, STi3gas]   = ComputeSiandSTi(y2A, y2B, y2BA, y2AB) ;
%disp('Compute Sobold indices for cost output')
%[Si1cost, Si2cost, Si3cost, STi1cost, STi2cost, STi3cost]   = ComputeSiandSTi(y3A, y3B, y3BA, y3AB);
drn='results/step3';
mkdir(drn)
fl=strcat('SobolIndices.mat');
f1 = fullfile(h1,drn,fl); 
%save(f1,'Si1elec', 'Si2elec', 'Si3elec', 'STi1elec', 'STi2elec', 'STi3elec', 'Si1gas', 'Si2gas', 'Si3gas', 'STi1gas', 'STi2gas', 'STi3gas','Si1cost', 'Si2cost', 'Si3cost', 'STi1cost', 'STi2cost', 'STi3cost','nsample')
