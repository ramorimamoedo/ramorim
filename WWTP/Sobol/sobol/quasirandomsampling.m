% This m file creates, plots and saves quasi-random sampling matrices for
% use with Sobol's variance decomposition
%

% 7th of July 2016
% Gurkan Sin @DTU Chemical Engineering

% header for file name/savings
hd = 'QuasiRandomSampling';

%% Define a priori probability distribution of parameters.
% uniform distribution is considered.
par = {'price_{el}', 'price_{gas}', 'COP_{cool}'}; 
xlu =[ -0.07	 -4023	4.5;
    -0.035   -1341    13.5];


nvar = length(xlu);
% specify no of LHS samples
nsample = 10000;



%% generate two matrices of quasi random samples using haltonset or sobolset
s = sobolset(nvar*2,'Skip',1e3,'Leap',1e2); % see help of haltonset for Skip and Leap command which are needed to introduce randomization
s = scramble(s,'MatousekAffineOwen'); % scramble is another level of randomization
% A=net(s,nsample*2); % GENERATE A 2N SIZE MATRIX
% Ap=A(1:nsample,:);Bp=A(nsample+1:end,:); %SPLIT IN TWO
A=net(s,nsample); % GENERATE A 2N SIZE MATRIX
Ap=A(:,1:nvar);Bp=A(:,nvar+1:nvar*2); %SPLIT IN TWO
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
title('Quasi Random Sampling: A')

figure(2)
[h,ax,bax,P] = plotmatrix(B) ;
set(ax,'FontSize',14,'FontWeight','bold')
for i=1:3
    ylabel(ax(i,1),par(i))
    xlabel(ax(3,i),par(i))
end
title('Quasi Random Sampling: B')

