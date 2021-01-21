% This m file creates, plots and saves quasi-random sampling matrices for
% use with Sobol's variance decomposition
%

% 7th of July 2016
% Gurkan Sin @DTU Chemical Engineering

% header for file name/savings
hd = 'QuasiRandomSampling';

%% Define a priori probability distribution of parameters.
% uniform distribution is considered.
par = {'x_1','x_2','x_3','x_4'};
xlu =[ 0.5	 1.5	4.5;
    1.5   4.5    13.5];
beta = [0.2 ; 15];
nvar = length(xlu)+size(beta,2);
% specify no of LHS samples
nsample = 1280;

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
Betal = ones(nsample,1) * beta(1,:);
Betau = ones(nsample,1) * beta(2,:);
A_unif = unifinv(Ap(:,(1:3)),Xl,Xu);
A_beta = betainv(Ap(:,4),Betal,Betau);
A = [A_unif A_beta];
B_unif = unifinv(Bp(:,(1:3)),Xl,Xu);
B_beta = betainv(Bp(:,4),Betal,Betau);
B = [B_unif B_beta];

%% view results
figure(1)
[h,ax,bax,P] = plotmatrix(A) ;
set(ax,'FontSize',14,'FontWeight','bold')
for i=1:4
    ylabel(ax(i,1),par(i))
    xlabel(ax(4,i),par(i))
end
title('Quasi Random Sampling: A')

figure(2)
[h,ax,bax,P] = plotmatrix(B) ;
set(ax,'FontSize',14,'FontWeight','bold')
for i=1:4
    ylabel(ax(i,1),par(i))
    xlabel(ax(4,i),par(i))
end
title('Quasi Random Sampling: B')

