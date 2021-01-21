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
% y=4*x1^2+x2 ; 
% x1~U(-0.5 , 0.5) & x2~U(-0.5 , 0.5)
fmod = @(x) 4*x(:,1).^2+3*x(:,2); % model definition
mu=[0 0]; sd=[1/3 1/3];

%% step 2 sampling. we use latin hypercube sampling
ct=0;
for N=25:100:1000 % total number of monte carlo sampling
ct=ct+1; % counter
    X=[];Xp=[];
m=2; % total number of inputs to the model
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
saveas(1,'Figure1','tiff')

%% Step 3. Perform the Monte Carlo simulations. 
% In this step, N model simulations are performed using the sampling
% matrix from Step 2 (XNxm) and the model outputs are recorded in a
% matrix form to be processed in the next step.
ym=fmod(X); D(ct)=var(ym); f0(ct)=mean(ym);

%% Step 4. Review and analyse the results.
% In this step, the outputs are plotted and the results are reviewed.
% we also calculate the monte carlo integration error
MCerr(ct)=std(ym)/sqrt(N); PercV(ct)=MCerr(ct)/std(ym)*100;
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

saveas(2,'Figure2','tiff')
xN(ct)=N;
end
% tabulate the results
T = table;
T.Mean=f0';
T.Variance = D';
T.MCerr = MCerr';
T
%plot the results as a function of MC error
figure(3)
subplot(311)
plot(xN,MCerr,'k.')
xlabel('N')
ylabel('MC error')
saveas(3,'Figure3','tiff')
subplot(312)
plot(xN,f0,'k.')
xlabel('N')
ylabel('Mean')
subplot(313)
plot(xN,D,'k.')
xlabel('N')
ylabel('D -variance')


saveas(3,'Figure3','tiff')
