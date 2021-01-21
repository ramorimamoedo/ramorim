%% We use approximate method based on random sampling and then analysis of variance of bins in factor sorted scatter plots
% April 12th, 2018
% Copyright @Gurkan Sin @DTU Chemical Engineering
clear
clc
close all
%%
%% Step 1. Input uncertainty definition.
% y=4*x1^2+x2 ;
% x1~N(0 ,1/3) & x2~N(0 , 1/3)
fmod = @(x) 4*x(:,1).^2+3*x(:,2); % model definition
mu=[1 1]; sd=[1/3 1/3];

rho=-0.999:0.1:0.999;
%% step2 perform sampling with proper correlation matrix
m=2;
N = 5000;
p = sobolset(m,'Skip',128);
p = scramble(p,'MatousekAffineOwen');
Xp = net(p,N);
X(:,1) = icdf('normal',Xp(:,1),mu(1),sd(1));
X(:,2) = icdf('normal',Xp(:,2),mu(2),sd(2));

%%Monte carlo simulations to calculate variance

for j=1:length(rho);
    % construct the covariance matrix
    C=eye(m);C(1,2)=rho(j);C(2,1)=C(1,2);
    Xc=sortcop(C,X); % we use gaussian copula to generate dependent samples
    % plot/visualize the input uncertainty domain.
    lp = {'x_1', 'x_2'};
    
    figure(1) % plot/view sampling results
    [h ax]=plotmatrix(Xc);
    ylabel(ax(1,1),lp(1));ylabel(ax(2,1),lp(2))
    xlabel(ax(2,1),lp(1));xlabel(ax(2,2),lp(2))
    title(['Correlation coefficient,\rho=',num2str(rho(j))])

    ym=fmod(Xc); D(j,1)=var(ym); f0(j,1)=mean(ym);
    MCerr(j,1)=std(ym)/sqrt(N);
    
end
% tabulate the results
T = table;
T.Mean=f0;
T.Variance = D;
T.MCerr = MCerr;
T

figure(2)
%subplot(211)
plot(rho,D,'ko')
title(['Correlation coefficient,\rho=',num2str(rho(j))])
legend('D-Variance')
grid on
ylabel('Variance (D)')
xlabel('correlation coefficient,\rho')
set(gca,'Fontsize',14,'Fontweight','bold')
% subplot(212)
% plot(rho,f0,'ko')
% legend('Mean')
% grid on
% ylabel('Mean of the output, \mu)')
% xlabel('correlation coefficient,\rho')
% set(gca,'Fontsize',14,'Fontweight','bold')
% ylim([2 10])

for k=1:2
    fg1 = strcat(['FigCorr_',num2str(k)]);
    %f1 = fullfile(h1,fg1) ;
    saveas(k,fg1,'tiff') ;
end%

