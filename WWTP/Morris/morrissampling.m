
%% Morris screening method
% Refs: Morris, 1991 and Campolongo and Saltelli, 1997
% This script performs morris sampling of parameter space needed for the
% morris screening method.
%
% Gurkan Sin, PhD
% Updated DTU Chemical Engineering July 11 2015


%% Parameters range

pmor=[78,26,0.25]; % get the reference parameter values /we assume we dont have any data for PE. otherwise we dont use Monte Carlo
%pmor=[78,26]; % get the reference parameter values /we assume we dont have any data for PE. otherwise we dont use Monte Carlo
lp = {'price_{el}', 'price_{gas}', 'Initial_{solids}'};
%lp = {'price_{el}', 'price_{gas}'};


inputunc=[1 0.6 0.60]; % expert input uncertainty indicates degree of uncertainty [0: Low , 1: High]
k=length(pmor); % number of parameters
xl= pmor .* (ones(1,k)-inputunc);
xu= pmor .* (ones(1,k)+inputunc);

%% Morris sampling parameters
k = length(pmor) ; % no of parameters or factors
p = 8 ; % number of levels {4,6,8} (in how many oparts do we discretize the inout space? 
dt = p/(2*(p-1)) ; % perturbation factor .
r = 100; % number of repetion for calculating the EEi, e.g. 4 - 15 30

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
pos = get(gca, 'Position');
set(gca, 'Position', [pos(1) pos(2)+0.05 pos(3) pos(4)-0.05]);
for i=1:2
ylabel(ax(i,1),lp(i))
xlabel(ax(2,i),lp(i))
end
title(['Morris Sampling with r=', num2str(r),', p=',num2str(p),' levels,',' and \Delta =',num2str(dt,'%5.2f'),': unit range'])

figure(2)
[h,ax,bax,P] = plotmatrix(Xval) ;
set(ax,'FontSize',14,'FontWeight','bold')
pos = get(gca, 'Position');
set(gca, 'Position', [pos(1) pos(2)+0.05 pos(3) pos(4)-0.05]);
for i=1:2
ylabel(ax(i,1),lp(i))
xlabel(ax(2,i),lp(i))
end
title(['Morris Sampling with r=', num2str(r),', p=',num2str(p),' levels,',' and \Delta =',num2str(dt,'%5.2f'),': real values'])

