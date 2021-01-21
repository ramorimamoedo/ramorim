function [x px R] =am(prior,pdf,T,d)
%%adaptive metropolis algorithm. see below the update on covariance matrix
q =@(C,d) mvnrnd(zeros(1,d),C);  % dvariate normal proposal distribution
sd=2.38/sqrt(d); % covariance scale
C=sd^2*eye(d); % scaled covariance matrix for proposal distribution
x=nan(T,d); px=nan(T,1); %preallocate memory
x(1,:)=prior(1,d); % initialize chain by sampling from prior
px(1)=pdf(x(1,:)); % compute density of initial state chain
R=[]; % initialize rejected samples
for t=2:T
    if mod(t,10)==0  % update covariance matrix every 10th iteration
        C=sd^2*(cov(x(1:t-1,:))+1e-4*eye(d)); % update the covariance matrix of the proposal distribution
    end
    xp=x(t-1,:)+q(C,d); % generate proposal
    pxp=pdf(xp); % calculate density of hte proposal
    pac=min(1,pxp/px(t-1)) ; % compute probability of acceptance
    if pac>rand    % pacc larger than U(0, 1)?
        x(t,:)=xp; px(t)=pxp; % true: accept the proposal
    else
        x(t,:)=x(t-1,:); px(t)=px(t-1);
        R=[R;xp];  % store rejected samples
    end
end
