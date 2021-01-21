%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Example2.2 Estimate the model prediction uncertainty of the
% nitrification model – the Monte Carlo method
% The following workflow is used:
% Step 1. Input uncertainty definition
% Step 2. Sampling from the input space
% Step 3. Parameter-significance ranking.
% Step 4. Computer collinearity index.
% Step 5. Review and analyse the results.
% Copyright. 2016 Gürkan Sin. Experimental Methods In Wastewater Treatment.
% Edited by M.C.M. van Loosdrecht, P.H. Nielsen. C.M. Lopez-Vazquez and D.
% Brdjanovic. ISBN: 9781780404745(Hardback), ISBN: 9781780404752 (eBook). Published by IWA Publishing, London, UK.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear  % Clear the work space, i.e. remove variables from the workspace
close all  % Close all open figure windows
clc        % Clear the commands in the command window (start with a 'clean' Matlab command window)
% In this example, we wish to propagate the parameter
% uncertainties resulting from parameter estimation (e.g.
% Example 5.3 and Example 5.4) to model output
% uncertainty using the Monte Carlo method.
% For the uncertainty analysis, the problem is defined
% as follows: (i) only the uncertainty in the estimated AOO
% parameters is considered, (ii) the experimental
% conditions of batch test 1 are taken in account (Table
% 5.3), and (iii) the model in Table 5.1 is used to describe
% the system and nominal parameter values in Table 5.2.

%% Step 1. Input uncertainty definition.
% As defined in the above problem definition, only the uncertainties in the estimated AOO parameters are
% taken into account:
%Thetainput = [YAOO mumaxAOO Ks,AOO Ko,AOO].
load bootAOO
load dataAOO

m=length(idx);n=length(res);

% plot/visualize the input uncertainty domain.
lp = {'Y_{AOO}', '\mu_{maxAOO}', 'K_s_{AOO}', 'K_o_{AOO}'};
figure % figure5.12
for i=1:4
    subplot(2,2,i)
    [f xi]=ksdensity(pmin(:,i));
    plot(xi,f)
    xlabel(lp(i),'FontSize',fs,'FontWeight','bold')
    ylabel('Density','FontSize',fs,'FontWeight','bold')
    set(gca,'LineWidth',2,'FontSize',12,'FontWeight','bold')
end

saveas(1,'Figure2_1','tiff')
%% Step 2. Sampling from the input space 
% Since the input parameters have a known covariance matrix, any sampling
% technique must take this into account. In this example, since the
% parameters are defined to follow a normal distribution, the input
% uncertainty space is represented by a multivariate normal distribution. A
% random sampling technique is used to sample from this space:%% do random
% sampling
N=100; %sampling number
mu=mean(pmin);
sigma=cov(pmin);
X = mvnrnd(mu,sigma,N); % multivariate random sampling with known covariance matrix.

figure % plot/view sampling results. see Figure 5.13
[h ax]=plotmatrix(X);
ylabel(ax(1,1),lp(1));ylabel(ax(2,1),lp(2));ylabel(ax(3,1),lp(3));ylabel(ax(4,1),lp(4))
xlabel(ax(4,1),lp(1));xlabel(ax(4,2),lp(2));xlabel(ax(4,3),lp(3));xlabel(ax(4,4),lp(4))
saveas(2,'Figure2_2','tiff')

%% Step 3. Perform the Monte Carlo simulations. 
% In this step, N model simulations are performed using the sampling
% matrix from Step 2 (XNxm) and the model outputs are recorded in a
% matrix form to be processed in the next step.
initcond;options=odeset('RelTol',1e-7,'AbsTol',1e-8);
for i=1:N
    disp(['the iteration number is : ',num2str(i)])
    par(idx) = X(i,:) ; % sample parameter space
    [t,y1] = ode45(@nitmod,td,x0,options,par);
    y(:,:,i)=y1;
end

%% Step 4. Review and analyse the results.
% In this step, the outputs are plotted and the results are reviewed. In
% Figure 5.14, Monte Carlo simulation results are plotted for four model
% outputs.
lx = {'Ammonium (mgN/l)', 'Nitrite (mgN/l)', 'Nitrate (mgN/l)', 'Oxygen (mgO_2/l)','AOO (mgCOD/l)'};
figure %  plot the raw data from MC simulations. see Fig5.14
t=t*24;
for i=1:4
    iy=[1,2,4,5];
    ax1{i}=subplot(2,2,i);
    temp(:,:)=y(:,iy(i),:);
    plot(t,temp)
    ylabel(lx(iy(i)))
    xlabel('time (h)')
    set(gca,'LineWidth',2,'FontSize',15,'FontWeight','bold') 
end
ylim(ax1{1},[0 22])
ylim(ax1{2},[0 22])
saveas(3,'Figure2_3','tiff')
figure %plot the statistics of the outputs. See Fig5.15
for i=1:4
    iy=[1,2,4,5];
    ax1{i}=subplot(2,2,i);
    tempo(:,:)=y(:,iy(i),:);
    y95=1.96*std(tempo');
    ym=mean(tempo');
    plot(t,ym,'k',t,ym+y95,'r',t,ym-y95,'r')
    ylabel(lx(iy(i)))
    xlabel('time (h)')
    set(gca,'LineWidth',2,'FontSize',15,'FontWeight','bold')
end
ylim(ax1{1},[0 22])
ylim(ax1{2},[0 22])
saveas(3,'Figure2_4','tiff')

save mcdata lp lx y X t
% As shown in Figure 5.15, the mean, standard deviation and percentiles
% (e.g. 95 %) can be calculated from the output matrix. The results
% indicate that for the sources of uncertainties being studied, the
% uncertainty in the model outputs can be considered negligible. These
% results are in agreement with the linear error propagation results shown
% in Figure 5.5. This means that while there is uncertainty in the
% parameter estimates themselves, when the estimated parameter subset is
% used together with its covariance matrix, the uncertainty in the model
% prediction is low. For any application of these model parameters they
% should be used together as a set, rather than individually.