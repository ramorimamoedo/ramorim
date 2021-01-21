function [chain A Rj ratiom] = mcmc(ssfun,data,theta,tcov,s2,chainn,samplingn)
%% MCMC: markov chain monte carlo sampling algorithm for Bayesian PE
% this samplig uses random walk metropolis algorithm (Gelman et al., 2004) which uses:
% (1) likelihood function: multivariate normal distribution
% (2) prior function: normal distribution
% (3) jumping/proposal function: gaussian distribution centered at current
% iteration
% (4) error model:  For measurement errors, gaussian error model is used and
%  the variance of the error is assumed/taken constant. i.e. no update. 
% see mh algorithm for update of measurement error variance.

% theta: mean parameter values (can be estimated from MLE)
% tcov: covariance matrix of parameters (can be estimated from MLE)
% s2: unbiased estimator of sample variance (can be estimated after MLE)
% chainnumber; % specify markov chain number
% samplingnumber; % specify sampling number for each chain

% A=[]; % accepted samples
% Rj=[];  % rejected samples
% chain=[]; % storeing sampling data in each markov chain
% ratiom =[]; metropolis ratio in each sampling try

% copyright: Assoc.prof. Gürkan Sin
% DTU Chemical Engineering/28 July 2011

A=[]; % accepted samples
Rj=[];  % rejected samples
chain=[];
chainnumber=chainn; % specify markov chain number
samplingnumber=samplingn;

%%step 1 initialisation: draw a starting point for model parameters,
%% specify sigma2 and covariance
x0 = mvnrnd(theta,tcov,chainnumber) ; % sampled from prior joint multivariate normal distribution using covariance C
sigma2=s2;
C=tcov;
R=chol(C); % cholesky decomposition
npar=length(theta);
covscale=2.4/sqrt(npar);

%%step 2: perform mcmc sampling with adaptive covariance
for j=1:chainnumber
    x=x0(j,:);
    for i=1:samplingnumber
        %2.a sample a proposal from jumping distribution (or a proposal
        %distribution), proposal sample:xp for each chain
        u = randn(1,npar);  % draw a random number for each chain
        dx=u*R*covscale; % incremental walk
        xnew=x+dx;  %random walk metropolis hasting algorithm
        %xp=mvnrnd(x,covscale*C); %this is alternative sampling way
        
        %2.b calculate the ratio of densities
        ssnew=ssfun(xnew,data);
        sscur=ssfun(x,data);
        rm= exp(-0.5*((ssnew-sscur)./sigma2) ); % metropolis ratio
        ratiom(i,:)=rm';
        
        %2.c reject/accept new sample
        if min(rm,1) > random('unif',0,1) % probability min(r,1)
            x=xnew ;
            A=[A; x];  % update the accepted samples
        else
            x=x;
            Rj=[Rj; x] ; % update the rejection samples
        end
        chain(j,i,:)=x;  %update the markov chain
    end
    %end of montecarlo simulation
end
%end of the markovchain monte carlo simulation
