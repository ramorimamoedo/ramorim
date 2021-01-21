%% We use approximate method based on random sampling and then analysis of variance of bins in factor sorted scatter plots
% April 12th, 2016
% Gurkan Sin @DTU Chemical Engineering
clear
clc
close all
%%
% In the first example a purely additive model is investigated
% f(y,z) = a1y + a2z.
% The input variables are normally distributed, have zero mean and the covariance
% assume a1=a2=1;
fmod = @(X) X(:,1)+X(:,2);

mu=[0 0]; % mu does not effect the variance calculations
s=[1 2];  % assume sigmay=1 and sigmayz=3.
rho=-0.9999:0.05:0.9999;
%% step2&3: perform sampling with proper correlation matrix
nvar=length(mu);
nsample = 5000;
p = sobolset(nvar,'Skip',128);
p = scramble(p,'MatousekAffineOwen');
Xp = net(p,nsample);
for i=1:nsample
Xn(i,:)=norminv(Xp(i,:),mu,s); % to normal distribution
end

%%Monte carlo simulations to calculate variance
nbins=50; % define number of slices
subset=nsample/nbins;
yl=zeros(nsample,nvar);

for j=1:length(rho);
   % construct the covariance matrix
     C=eye(nvar);C(1,2)=rho(j);C(2,1)=C(1,2);
     X=sortcop(C,Xn); % we use gaussian copula to generate dependent samples
    
    ym=fmod(X); D(j,1)=var(ym);
    for i=1:nvar;
        [ix iy]=sort(X(:,i)); sy=ym(iy);
        %%smoothing/average value in each slice
        for k=1:nbins;
            ts=(k-1)*subset+1; tend=k*subset;
            yt=sy(ts:tend,1);xt=ix(ts:tend,1);
            muy(k,1)=mean(yt); mux(k,1)=mean(xt);
        end
        Di(j,i)=var(muy);
        Si(j,i)=Di(j,i)/D(j);
    end
end
Dbins=D;
 %comparative plots
load Sitrue

figure
subplot(1,3,1)
plot(rho,Sy,'ro',rho,Si(:,1),'bo')
%[hAx,hLine1,hLine2]=plotyy([rho rho],[Sy STy],rho,Dy)
legend('Sy','Sy-bins')
grid on
ylabel('Sensitivity indices')
xlabel('correlation coefficient,\rho')
set(gca,'Fontsize',14,'Fontweight','bold')
subplot(1,3,2)
plot(rho,Sz,'rp',rho,Si(:,2),'bp')
title(['Comparison of random sampling with bins vs analytical values'])
legend('Sz','Sz-bins')
grid on
ylabel('Sensitivity indices')
xlabel('correlation coefficient,\rho')
set(gca,'Fontsize',14,'Fontweight','bold')
subplot(1,3,3)
plot(rho,D,'k+',rho,Dbins,'r+')
legend('Dtrue','Dbins')
grid on
ylabel('Total variance of model output (D)')
xlabel('correlation coefficient,\rho')
set(gca,'Fontsize',14,'Fontweight','bold')
 
for k=1
    fg1 = strcat(['RandomWBins_copula_',num2str(k)]);
    %f1 = fullfile(h1,fg1) ;
    saveas(k,fg1,'tiff') ;
end%  

