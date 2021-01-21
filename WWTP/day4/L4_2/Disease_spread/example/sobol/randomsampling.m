% This m file creates, plots and saves pseudo-ramdom sampling matrices for
% use with Sobol's variance decomposition
% source: Satelli et al (2009) pp164-165

% 17th of July 2009
% Gurkan Sin @DTU Chemical Engineering

% header for file name/savings
%hd = 'LHSampling';
hd = 'PseudoRandomSampling';

%% Define a priori probability distribution of parameters.
% uniform distribution is considered.
par = {'x_1','x_2','x_3'};
xlu =[ 0.5	 1.5	4.5;
    1.5   4.5    13.5];
nvar = length(xlu);
% specify no of LHS samples
nsample = 10000;

%% generate two matrices of random samples nsampleXnvar
Ap = rand(nsample,nvar) ; % 'rand' generates pseudo-random numbers
Bp = rand(nsample,nvar) ;

%% from probability to value
% uniform distribution
Xl = ones(nsample,1) * xlu(1,:) ; % this is needed for the command unifinv
Xu =  ones(nsample,1) * xlu(2,:) ;% this is needed for the command unifinv
A = unifinv(Ap,Xl,Xu);
B = unifinv(Bp,Xl,Xu);

%% view results
figure(1)
[h,ax,bax,P] = plotmatrix(A) ;
set(ax,'FontSize',14,'FontWeight','bold')
for i=1:3
    ylabel(ax(i,1),par(i))
    xlabel(ax(3,i),par(i))
end
title('Pseudo Random Sampling: A')

figure(2)
[h,ax,bax,P] = plotmatrix(B) ;
set(ax,'FontSize',14,'FontWeight','bold')
for i=1:3
    ylabel(ax(i,1),par(i))
    xlabel(ax(3,i),par(i))
end
title('Pseudo Random Sampling: B')

