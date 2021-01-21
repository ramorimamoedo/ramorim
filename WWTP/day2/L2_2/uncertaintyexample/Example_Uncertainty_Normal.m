%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Example Estimate the model prediction uncertainty of a simple model 
%– the Monte Carlo method
% The following workflow is used:
% Step 1. Input uncertainty definition
% Step 2. Sampling from the input space
% Step 3. Perform Monte Carlo Simulations.
% Step 4. Review and analyse the results.
% Copyright @Gürkan Sin.2018 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear  % Clear the work space, i.e. remove variables from the workspace
close all  % Close all open figure windows
clc        % Clear the commands in the command window (start with a 'clean' Matlab command window)

%% Step 1. Input uncertainty definition.
% y=4*x1^2+3x2 ; 
% x1~N(0 ,0) & x2~N(1/3 ,1/3)
fmod = @(x) 4*x(:,1).^2+3*x(:,2); % model definition
mu=[0 0]; sd=[1/3 1/3]; % assume normal distribution
%% step 2 sampling. we use latin hypercube sampling
    X=[];Xp=[];
m=2; % number of inputs to the model
N=250; % number of samples
Xp=lhsdesign(N,m); % sampling in unit probability space

% convert probability space to real value space via inverse distribution
X(:,1) = icdf('normal',Xp(:,1),mu(1),sd(1));
X(:,2) = icdf('normal',Xp(:,2),mu(2),sd(2));

% plot/visualize the input uncertainty domain.
lp = {'x_1', 'x_2'};

figure(1) % plot/view sampling results
[h ax]=plotmatrix(X);
ylabel(ax(1,1),lp(1));ylabel(ax(2,1),lp(2))
xlabel(ax(2,1),lp(1));xlabel(ax(2,2),lp(2))
saveas(1,'FigureNormal1','tiff')

%% Step 3. Perform the Monte Carlo simulations. 
% In this step, N model simulations are performed using the sampling
% matrix from Step 2 (XNxm) and the model outputs are recorded in a
% matrix form to be processed in the next step.
ym=fmod(X); D=var(ym); f0=mean(ym);

%% Step 4. Review and analyse the results.
% In this step, the outputs are plotted and the results are reviewed.
% we also calculate the monte carlo integration error
MCerr=std(ym)/sqrt(N); 
lx={'x_1','x_2'};

figure(2)
for i=1:m
subplot(2,1,i)
[ix iy]=sort(X(:,i)); sy=ym(iy);
 plot(ix,sy,'k.')
xlabel(lp(i))
ylabel('y')
hold on
end

saveas(2,'FigureNormal2','tiff')

% tabulate the results
T = table;
T.mean =f0;
T.Variance = D';
T.MCerr = MCerr';
T
