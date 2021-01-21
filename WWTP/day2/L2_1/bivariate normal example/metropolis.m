%% metropolis algorithm
% bayesian data analysis by Gelman et al
% page 289-290
% example: approximating bivariate normal density


clear, clc, close all

A=[]; % accepted samples
Rj=[];  % rejected samples
chain=[];
chainnumber=5; % specify chain number
samplingnumber=1000; % specify sampling number

mu = [0 0]; % unit normal hence mean is zero
C = eye(2); % covarinace matrix is identity matrix
R = chol(C); % *cholesky decomposition of the covariance matrix
npar=length(mu);
covscale=2.4 / sqrt(npar); % this is very important tuning parameter of the jumping distribution function!

%%step 1 draw a starting point from a starting distribution for each chain. (prior
%%distribution assumed bivariate normal )

x0= mvnrnd(mu,C,chainnumber) ;
%x0= lhsnorm(mu,I,chainnumber) ; this would do the job also

%step 2: perform sampling
for j=1:chainnumber
    x=x0(j,:);
    for i=1:samplingnumber
        %2.1 sample a proposal from jumping distribution (or a proposal
        %distribution), proposal sample:xp for each chain
        
        u = randn(1,npar);  % draw a random number for each chain
        dx=u*R*covscale; % incremental walk
        xp=x+dx; % new trial position
        %xp=mvnrnd(x,covscale^2.*C); % the jumping distribution is q(theta|theta_prev)=N(theta|xp,0.2^2*I)
        
        %2.2 calculate the metropolis ratio:
        r= mvnpdf(xp,mu,C) ./ mvnpdf(x,mu,C);
        ratio(i,:)=r';
        
        %2.3 reject/accept new sample
        if min(r,1) > random('unif',0,1) % probability min(r,1)
            x=xp ;
            A=[A; x];  % update the accepted samples
        else
            x=x;
            Rj=[Rj; x] ; % update the rejection samples
            
        end
        
        chain(j,i,:)=x;
    end
end

disp(['acceptance ratio = ',num2str(length(A)/(length(A)+length(Rj)))])
% plot the chains separately
figure(1)
plot(chain(1,:,1),chain(1,:,2),'.-k')
hold on
plot(chain(2,:,1),chain(2,:,2),'.-b')
hold on
plot(chain(3,:,1),chain(3,:,2),'.-r')
hold on
plot(chain(4,:,1),chain(4,:,2),'.-g')
hold on
plot(chain(5,:,1),chain(5,:,2),'.-c')

% plot them as a clound of data
set(gca,'FontSize',14)
figure(2)
plot(chain(1,:,1),chain(1,:,2),'.k','MarkerSize',5)
hold on
plot(chain(2,:,1),chain(2,:,2),'.k','MarkerSize',5)
hold on
plot(chain(3,:,1),chain(3,:,2),'.k','MarkerSize',5)
hold on
plot(chain(4,:,1),chain(4,:,2),'.k','MarkerSize',5)
hold on
plot(chain(5,:,1),chain(5,:,2),'.k','MarkerSize',5)

set(gca,'FontSize',14)
saveas(1,'fig1','tif')
saveas(2,'fig2','tif')
