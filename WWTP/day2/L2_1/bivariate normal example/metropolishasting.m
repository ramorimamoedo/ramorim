%% metropolis hasting algorithm
% a generalisation of metropolis algorithm. the rejection ratio is generic
% now.
% bayesian data analysis by Gelman et al
% page 289-290
% example bivariate normal density
%p(x,y)=1/(2*pi*sx*sy*sqrt(1-rho^2))*exp(-

clear, clc, close all

A=[]; % accepted samples
R=[];  % rejected samples
chain=[];
chainnumber=5; % specify chain number

mu = [0 0]; % unit normal hence mean is zero
I = eye(2); % Sigma is identity matrix

% p(theta|y)=N(theta|0,I) where I is 2x2 unit identity matrix
%%step 1 draw a starting point from a starting distribution. here the
%%target density is also bivariate normal (multivariate normal with two
%%variables

%x0= mvnrnd(mu,I,chainnumber) ;
x0= lhsnorm(mu,I,chainnumber) ;

x=x0;
%step 2: perform sampling
for i=1:5000
%2.a sample a proposal from jumping distribution (or a proposal
%distribution), proposal sample:xp for each chain

xp=mvnrnd(x,0.2^2.*I); % the jumping distribution is J(theta|theta_prev)=N(theta|xp,0.2^2*I)

%2.b calculate the ratio of densities
rm= mvnpdf(xp,mu,I) ./ mvnpdf(x,mu,I); % metropolis ratio
rmh= (mvnpdf(xp,mu,I) ./ mvnpdf(x,mu,I)) .* (mvnpdf(xp,mu,0.2^2.*I) ./ mvnpdf(x,mu,0.2^2.*I)); % metropolis-hasting ratio

ratiom(i,:)=rm';
ratiomh(i,:)=rmh';
%2.c reject/accept new sample
 if min(rmh,1) > random('unif',0,1) % probability min(r,1) 
x=xp ;
A=[A; x];  % update the accepted samples
 else
     x=x;
R=[R; x] ; % update the rejection samples

 end
chain(:,i,:)=x;  %update markov chain

end

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

% plot them as a cloud of data

figure(2)
plot(chain(1,:,1),chain(1,:,2),'.k','MarkerSize',1)
hold on
plot(chain(2,:,1),chain(2,:,2),'.k','MarkerSize',1)
hold on
plot(chain(3,:,1),chain(3,:,2),'.k','MarkerSize',1)
hold on
plot(chain(4,:,1),chain(4,:,2),'.k','MarkerSize',1)
hold on
plot(chain(5,:,1),chain(5,:,2),'.k','MarkerSize',1)
