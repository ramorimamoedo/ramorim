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
save(f1,'A','B','yA','yB','yAB','yBA')

%%step 3 Computer Sobold indices
ComputeSiandSTi

drn='results/step3';
mkdir(drn)
fl=strcat('SobolIndices.mat');
f1 = fullfile(h1,drn,fl); 
save(f1,'Si1','STi1','nsample')
