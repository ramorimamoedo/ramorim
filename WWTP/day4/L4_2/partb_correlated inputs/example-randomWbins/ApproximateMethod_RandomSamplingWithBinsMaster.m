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

%% step2: perform quasin random sampling
nvar=length(mu);
nsample = 2500;
% p = sobolset(nvar,'Skip',128);
% p = scramble(p,'MatousekAffineOwen');
% Xp = net(p,nsample);
Delay=128;%To reduce correlated samples when uncorrelated ones are desired.
Xn=zeros(nsample,nvar);
for k=1:nsample
    x=LPTAU51(Delay+k,nvar);%sample in probability (0 1)
    Xn(k,:)=norminv(x,mu,s); % to normal distribution
    Xp(k,:)=x; % record
end

%% induce rank based correlation (imancon algorithm). just to visualize
C=eye(nvar);C(1,2)=-0.8;C(2,1)=C(1,2);
X=sortcop(C,Xn); % rank sorted/correlated samples
lx={'y','z'};
figure
subplot(2,1,1)
[h ax]=plotmatrix(Xn)
ylabel(ax(1,1),lx(1)); ylabel(ax(2,1),lx(2))
title(['independent samples with \rho= ',num2str(0)])
subplot(2,1,2)
[h ax]=plotmatrix(X)
ylabel(ax(1,1),lx(1)); ylabel(ax(2,1),lx(2))
xlabel(ax(2,1),lx(1)); xlabel(ax(2,2),lx(2))
title(['rank correlated samples with \rho= ',num2str(-0.8)])

%%Monte carlo simulations to calculate variance
ym=fmod(X); D=var(ym); f0=mean(ym);
nbins=25; % define number of slices
subset=nsample/nbins;
yl=zeros(nsample,nvar);



for i=1:nvar;
    [ix iy]=sort(X(:,i)); sy=ym(iy);
    figure;plot(ix,sy,'k.')
    hold on
    %%smoothing/average value in each slice
    for k=1:nbins;
        ts=(k-1)*subset+1; tend=k*subset;
        yt=sy(ts:tend,1);xt=ix(ts:tend,1);
        muy(k,1)=mean(yt); mux(k,1)=mean(xt);
    end
    plot(mux,muy,'r.','MarkerSize',16)
    title(lx{i})
    xlabel(['sorted according to ',lx{i}])
    ylabel('Values of function')
    grid on
    Si(i,1)=var(muy)/D; %average of scatter plots
    set(gca,'FontSize',14,'FontWeight','bold')
end

for k=1:3
    fg1 = strcat(['ApproximateMethod for_',num2str(k)]);
    %f1 = fullfile(h1,fg1) ;
    saveas(k,fg1,'tiff') ;
end


