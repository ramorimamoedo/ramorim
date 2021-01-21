%% call file to perform random walk algorithm 
% sampling from bivariate normal distribution
clear 
close all
d=2; % number of inputs/dimension of distribution
mu = zeros(1,d); % unit normal hence mean is zero
Cd = eye(d); % covarinace matrix is identity matrix
pdf =@(x) mvnpdf(x,mu,Cd);  % likelihood function
N=1; % chain length
prior=@(N,d) unifrnd(-10,10,N,d); % prior distribution
T=5000; % MCMC samples
[x px R]=rwm(prior,pdf,T,d);
AR=(T-length(R))/T*100;
disp(['acceptance ratio = ',num2str(AR)])

figure
plot(x(:,1),x(:,2),'ro')
hold on
plot(R(:,1),R(:,2),'bo')
hold off
legend('accepted','rejected samples')

figure
plot(x)
legend('x_1','x_2')

figure
plot(x(1:100,:))
legend('x_1','x_2')

%% burn in ration 20%
idx=round(0.2*T);
x=x(idx:end,:);
figure
plot(x(:,1),x(:,2),'ro')
legend('accepted samples')
ylabel('x_1')
xlabel('x_2')

for i=1:3
    saveas(i,num2str(i),'tif')
end