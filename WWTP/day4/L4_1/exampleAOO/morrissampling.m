
%% Morris screening method
% Refs: Morris, 1991 and Campolongo and Saltelli, 1997
% This script performs morris sampling of parameter space needed for the
% morris screening method.
%
% Gurkan Sin, PhD
% Updated DTU Chemical Engineering July 11 2015


%% Parameters range
initcond
pmor=par(1:4); % get the reference parameter values /we assume we dont have any data for PE. otherwise we dont use Monte Carlo
lp = {'Y_{AOO}', '\mu_{maxAOO}', 'K_s_{AOO}', 'K_o_{AOO}'};

inputunc=[0.05 0.10 0.25 0.25]; % expert input uncertainty indicates degree of uncertainty [0: Low , 1: High]
k=length(pmor); % number of parameters
xl= pmor .* (ones(1,k)-inputunc);
xu= pmor .* (ones(1,k)+inputunc);

%% Morris sampling parameters
k = length(pmor) ; % no of parameters or factors
p = 4 ; % number of levels {4,6,8}
dt = p/(2*(p-1)) ; % perturbation factor .
r = 50; % number of repetion for calculating the EEi, e.g. 4 - 15

%% Morris sampling will produce discrete uniform probabilities for each
%% factor.
X = morris(p,dt,k,r);
Xmean = mean(X) ;

%% from uniform distribution [0 1] to real values
Xval = ones(r*(k+1),1)*xl + (ones(r*(k+1),1)*(xu-xl)).*X ;

%% Plot Morris sampling results for the visualization
figure(1)
[h,ax,bax,P] = plotmatrix(X) ;
set(ax,'FontSize',14,'FontWeight','bold')
for i=1:4
ylabel(ax(i,1),lp(i))
xlabel(ax(4,i),lp(i))
end
title(['Morris Sampling with r=', num2str(r),', p=',num2str(p),' levels,',' and \Delta =',num2str(dt,'%5.2f'),': unit range'])

figure(2)
[h,ax,bax,P] = plotmatrix(Xval) ;
set(ax,'FontSize',14,'FontWeight','bold')
for i=1:4
ylabel(ax(i,1),lp(i))
xlabel(ax(4,i),lp(i))
end
title(['Morris Sampling with r=', num2str(r),', p=',num2str(p),' levels,',' and \Delta =',num2str(dt,'%5.2f'),': real values'])

