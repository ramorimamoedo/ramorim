%% Using bayesian inference for estimating model parameters
% example case: Estimating parameters of Monod growth model

% copyright: Assoc.prof. Gürkan Sin
% DTU Chemical Engineering/28 July 2011

clear, clc, close all

%% formulate the model, the data
%the model:monod equation for microbial growth
modelfun = @(s,theta) theta(1)*s./(theta(2)+s);
mumax= 0.15 ;% maximum growth rate, h-1
ks   = 10   ;% substrate affinity, mgL-1
theta0=[mumax,ks];

%%data
data.s = [28    55    83    110   138   225   375]';   % x (mg / L COD)
data.mu = [0.053 0.060 0.112 0.105 0.099 0.122 0.125]'; % y (1 / h)

% step 0: provide prior information about the unknowns (parameters) and
% also error function (variance). here we can do an MLE estimation
ssfun    = @(theta,data) sum((data.mu-modelfun(data.s,theta)).^2);

[tmin,ssmin]=fminsearch(ssfun,theta0*2,[],data);
n = length(data.mu);
p = length(theta0);
s2 = ssmin/(n-p); % estimate the sample variance
J = [data.s./(tmin(2)+data.s), ...
    -tmin(1).*data.s./(tmin(2)+data.s).^2];
tcov = s2*inv(J'*J) ; %estimate of the covariance matrix for the priors
tsigma=sqrt(diag(tcov))';
theta=tmin;

figure(1)
set(gca,'FontSize',14)
plot(data.s,data.mu,'r.',data.s,modelfun(data.s,theta),'k')
ylabel('mu')
xlabel('substrate')
legend('measured','fitted')

%% bayesian PE

chainnumber=10; % specify markov chain number
samplingnumber=1000; % specify sampling number for each chain

% call the mcmc sampler
[chain A Rj ratiom] = mcmc(ssfun,data,theta,tcov,s2,chainnumber,samplingnumber);

% processing of the mcmc samples
disp(['acceptance ratio: ',num2str(length(A)/(length(A)+length(Rj)))])

burnratio=0.2;  %define burn in ratio!
convergencestat

disp('              ')
disp('now plotting the results')
s2chain=[];
plotmcmcres
