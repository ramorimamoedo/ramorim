%% Performing sensitivity analysis using Morris method
%% global script executing the workflow in Morris method
%% Gurkan Sin DTU Chemical Engineeirng
%% June 24, 2015 DTU Lyngby
close all;
clear all;
clc

%%Step 1: perform Morris sampling
disp('Step 1: perform Morris sampling')
morrissampling

%save output
fl =strcat('MorrisSampling_r',num2str(r),'_p',num2str(p),'.mat');
save(fl, 'Xval', 'X','p','dt','r','xl','xu','k','lp')

drn='figures/step1';
mkdir(drn)
for i=1:2
    fg = strcat(['MorrisSampling',num2str(i),'_',datestr(date,'ddmmmyy')]);
    f1 = fullfile(pwd,drn,fg) ;
    saveas(i,f1,'tiff') ;
end

%%step 2: perform simulations with Morris Samples
disp('step 2: perform simulations with Morris Samples')
morrissim
%save output
fl =strcat('MorrisSims_r',num2str(r),'_p',num2str(p),'.mat');
save(fl)

%%Step 3: visualize the simulation results
disp('Step 3: visualize the simulation results')
plotmorrissims

%% save figures
drn='figures/step3';
mkdir(drn)
for i=1:2
    fg = strcat(['Morris Simulations',num2str(i),'_',datestr(date,'ddmmmyy')]);
    f1 = fullfile(pwd,drn,fg) ;
    saveas(i,f1,'tiff') ;
end
close all
%%step 4: compute Elementary Effects, EEi
disp('step 4: compute Elementary Effects, EEi')
computeEEi

drn='figures/step4';
mkdir(drn)
for i=1:6
    fg = strcat(['ElementaryEffects',num2str(i),'_',datestr(date,'ddmmmyy')]);
    f1 = fullfile(pwd,drn,fg) ;
    saveas(i,f1,'tiff') ;
end
%%step 5: interpret the results by viewing the sigma versus mean values of
%%EEi - this step is done manually by the user.


