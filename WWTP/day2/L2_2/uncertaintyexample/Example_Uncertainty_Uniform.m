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
% y=4*x1^2+3*x2 ; 
% x1~U(-1 , 1) & x2~U(-1 , 1)
fmod = @(x) 4*x(:,1).^2+3*x(:,2); % model definition
x1u=[-1 1]; x2u=[-1 1];
%% step 2 sampling. we use latin hypercube sampling
    X=[];Xp=[];
m=2; % number of inputs to the model
N=250; % number of samples
Xp=lhsdesign(N,m); % sampling in unit probability space

% convert probability space to real value space via inverse distribution
X(:,1) = icdf('uniform',Xp(:,1),x1u(1),x1u(2));
X(:,2) = icdf('uniform',Xp(:,2),x2u(1),x2u(2));

% plot/visualize the input uncertainty domain.
lp = {'x_1', 'x_2'};

figure(1) % plot/view sampling results
[h ax]=plotmatrix(X);
ylabel(ax(1,1),lp(1));ylabel(ax(2,1),lp(2))
xlabel(ax(2,1),lp(1));xlabel(ax(2,2),lp(2))
saveas(1,'FigUniform1','tiff')

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

saveas(2,'FigUniform2','tiff')

% tabulate the results
T = table;
T.mean =f0;
T.Variance = D';
T.MCerr = MCerr';
T
