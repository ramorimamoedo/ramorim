%% We use approximate method based on random sampling and then analysis of variance of bins in factor sorted scatter plots
% April 12th, 2016
% Gurkan Sin @DTU Chemical Engineering
clear
clc
close all
%%
fmod = @(X) sin(X(:,1))+7.*sin(X(:,2)).^2+0.1.*(X(:,3).^4).*sin(X(:,1));
% define range for inputs
lb=[-pi -pi -pi];ub=[pi pi pi];

nvar=3;
nsample=2^11;
%perform sampling (quasi-random using sobol sequence)
Delay=128;%To reduce correlated samples when uncorrelated ones are desired.
for k=1:nsample
    sb=LPTAU51(Delay+k,nvar);%I need 2xNvar independent samples
    Xn(k,:)=unifinv(sb,lb ,ub); % from 0 - 1 to uniform distribution (lb to ub)
end

%%Monte carlo simulations to calculate variance
nbins=25; % define number of slices
subset=nsample/nbins;
yl=zeros(nsample,nvar);
 rho=-0.9999:0.05:0.9999;
for j=1:length(rho);
   % construct the covariance matrix
     C=eye(nvar,nvar);
    C(1,3)=rho(j);C(3,1)=C(1,3);
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
figure

plot(rho,Si,'o')
legend('x_1','x_2','x_3')
ylabel('Si_{full}')
ylim([0 0.7])
grid
lx={'x_1','x_2','x_3'}
 xlabel(['Correlation coefficient \rho'])
ym=fmod(X); D=var(ym); 
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
    title(['correlation coefficient btw x_1 & x_3 \rho_{13} =',num2str(rho(j))])
    xlabel(['sorted according to ',lx{i}])
    ylabel('Values of function')
    grid on
    Si(i,1)=var(muy)/D; %average of scatter plots
    set(gca,'FontSize',14,'FontWeight','bold')
end
 
for k=1:4
    fg1 = strcat(['RandomWBins_copula_',num2str(k)]);
    %f1 = fullfile(h1,fg1) ;
    saveas(k,fg1,'tiff') ;
end%  

