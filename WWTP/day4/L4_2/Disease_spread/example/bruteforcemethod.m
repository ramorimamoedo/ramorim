% This m file creates, plots and saves brute force sampling matrices for
% use with brute force method to calculate Sobol's variance decomposition
% source: Satelli et al (2009) pp164-165

% 17th of July 2016
% Gurkan Sin @DTU Chemical Engineering

% header for file name/savings
clear
close all

hd = 'BruteForceSampling';

%% Define a priori probability distribution of parameters.
% uniform distribution is considered from   [0 1]
par = {'x_1','x_2'};
% specify no of LHS samples
n1 = 50; % number of points at which x1 is fixed
n2 = 500; % number of random samples to evaluate x2
x1=linspace(0,1,n1+1);
figure
for i=1:n1+1
    x1o=x1(i)*ones(1,n2);
    x2=rand(1,n2);
    plot(x1o,x2,'o')
    hold on
    ylabel(par(2))
    xlabel(par(1))
end

%% view results
title(['Brute Force Sampling with n_1 (for x_1)=',num2str(n1),'&','n_2(for x_2)=',num2str(n2),'. Total N=',num2str(n1*n2)])

set(gca,'FontSize',18,'FontWeight','bold')

saveas(1,hd,'tiff')
