%% We use approximate method based on random sampling and then analysis of variance of bins in factor sorted scatter plots 
% April 12th, 2016 
% Gurkan Sin @DTU Chemical Engineering
clear
clc
close all
%% 5.1. ADDITIVE LINEAR MODEL
% In the first example a purely additive model is investigated
% Y = X1 + X2 + X3
% The input variables are uniformly distributed with the following upper and lower bounds

fmod = @(X) X(:,1)+X(:,2)+X(:,3);
lb=[0.5 1.5 4.5];ub=[1.5 4.5 13.5];
mu=[1 3 9];
%% step2: perform LHSampling
nsample = 10000; nvar=length(mu);
Xp =  lhsdesign(nsample,nvar);

% From probability to values via inverse CDF
LB=ones(nsample,1)*lb;
UB=ones(nsample,1)*ub;
X = unifinv(Xp,LB,UB);  % this part should be edited by the user depending on the prior prob distribution.

figure
plotmatrix(X)
title('Uncorrelated/independent samples')
% specify no of LHS samples

lx={'x_1','x_2','x_3'};
%%Monte carlo simulations to calculate variance
ym=fmod(X); D=var(ym); f0=mean(ym);

% loop for Xi:  Only variance in Xi is considered.
nbins=15; % define number of slices
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
    xlabel(['sorted according to',lx{i}])
    ylabel('Values of function y=f(x)')
    grid on
    Sia(i,1)=var(muy)/D; %average of scatter plots
    set(gca,'FontSize',14,'FontWeight','bold')
end


for k=2:4
    i=k-1;
    fg1 = strcat(['ApproximateMethod for_',lx{i}]);
    %f1 = fullfile(h1,fg1) ;
    saveas(k,fg1,'tiff') ;
end

load Sitrue
Sitrue=Si(1:3);
T=table(Sia,Sitrue,'RowNames',{'x1','x2','x3'})
