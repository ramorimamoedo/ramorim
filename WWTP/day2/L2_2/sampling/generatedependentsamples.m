%% Strategies to generate dependent/correlated samples
% Copula family (e.g. Gaussian copula, t-copula, etc)
% Iman Conover rank based correlation method

clear 
clc
close all
%%  first generate independent samples using any random sampling strategies
%n. of variables
k=2;
%number of sample points
N=200;
for i=1:N
    Xt=LPTAU51(i-1, k);
    X(i,:)=Xt(1:k)+ones(1,k)/(2*N);
end
% define correlation
C=eye(k);
rho=[0 -0.8 0.8];
% first method using Gaussian copula
figure(1)
for j=1:3
    C(1,2)=rho(j);C(2,1)=C(1,2);
    Xgc=sortcop(C,X); % using Gaussian copula
    subplot(3,1,j)
    axis([0 1 0 1]);
    for i=1:N
        plot(Xgc(i,1),Xgc(i,2),'o')
        ylabel('x_2')
        xlabel('x_1')
        hold on
   %     getframe;
    end
     title(['Gaussian Copula method with \rho =',num2str(rho(j))])
end
%second test using IC method
figure(2)
for j=1:3
    C(1,2)=rho(j);C(2,1)=C(1,2);
    Xic=imancon(C,X); % using IC method
    subplot(3,1,j)
    axis([0 1 0 1]);
    for i=1:N
        plot(Xic(i,1),Xic(i,2),'o')
        ylabel('x_2')
        xlabel('x_1')
        hold on
       % getframe;
    end
     title(['Iman-Conover method with \rho =',num2str(rho(j))])  
end


%%


for i=1:2
    saveas(i,['dependent samples',num2str(i)],'tiff')
end