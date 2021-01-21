%This code was developed by T. A. MARA (2013) fromm the University of Reunion
%Island. It is a sampling-based method to compute sensitivity indices when
%input factors are correlated. The correlations are induced via Iman &
%Conover's technique (CSSC 1982). The example below is the one derived by
%Kucherenko et al. (CPC 2012) for the Ishigami Function in which only X_1
%and X_3 are correlated. Here, the full 1st-order (Si^full,Si^ind) and
%total (STi^full,STi^ind) variance-based sensitiviy indices are estimated.
%% commented by GSI
% please cite the following paper for this algorithm:
% T.A. Mara 174 et al. / Environmental Modelling & Software 72 (2015) 173e183
%%
close all
clear; clc
fmod = @(X) X(:,1)+X(:,2);

mu=[0 0]; % mu does not effect the variance calculations
s=[1 2];  % assume sigmay=1 and sigmayz=3.

Nvar=2;
Nsample=2^10;
CC=eye(Nvar,Nvar);
Mat=eye(Nvar-1,Nvar-1);
Mat_Perm=zeros(Nvar,Nvar);
Mat_Perm(end,1)=1;
Mat_Perm(1:end-1,2:end)=Mat;

%LPTAU sequences
Delay=128;%To reduce correlated samples when uncorrelated ones are desired.
for k=1:Nsample
    sb=LPTAU51(Delay+k,2*Nvar);%I need 2xNvar independent samples
    Fact_Ref2(k,:)=(sb-0.5)*2; % from 0 - 1 to uniform distribution (-1 to 1)
    Fact_Ref(k,:)=norminv(sb,[mu mu] ,[s s]); % from probability to normal distribution (mu & s)
end

% %Uniformly distributed values (-1 1) mapped to normally distributed values
% %(mu=0 & std=1) (independent)
 x=sqrt(2)*erfinv(Fact_Ref2(:,1:Nvar));%
 x1=sqrt(2)*erfinv(Fact_Ref2(:,Nvar+1:2*Nvar));%
 
%%do MC sampling with permutations on Correlation Structure to calculate
%%the effects
cnt=0;

for rho=-0.9999:0.05:0.9999;
    cnt=cnt+1;
    C=eye(Nvar,Nvar);
    C(1,2)=rho;
    C(2,1)=rho;
    RHO(cnt,1)=rho;
    rho
    
    %The circular permutations start with this loop
    Perm=1:Nvar;
    for p=1:Nvar
        %p
        U=chol(C);%Upper Cholesky Matrix
        xc1=x*U;% Cholesky transformation to induce correlations amongst the samples
        %The first sample
        for pp=1:Nvar
            [Ind]=Ranking(xc1(:,pp));
            [obs1,Ind1]=sort(Fact_Ref(:,Perm(pp)));
            Fact(:,Perm(pp))=obs1(Ind);%This allows the Uniform samples Fact to be correlated accordingly xith the Rank Correlation Matrix C
        end
        
        y(:,1)=fmod(Fact);%Model runs with the first sample
        
        %The second sample
        xc2=x1*U;
        for pp=1:Nvar
            [Ind]=Ranking(xc2(:,pp));
            [obs1,Ind1]=sort(Fact_Ref(:,Perm(pp)));
            Fact(:,Perm(pp))=obs1(Ind);
        end
        y(:,2)=fmod(Fact);%%Model runs with the second sample
        
        %Here, I only change the values of the first factor in the set as
        %compared to the second sample
        x2=x1;
        x2(:,1)=x(:,1);%For the full effects (first-order and total)
        xc3=x2*U;%I induce correlation
        for pp=1:Nvar
            [Ind]=Ranking(xc3(:,pp));
            [obs1,Ind1]=sort(Fact_Ref(:,Perm(pp)));
            Fact(:,Perm(pp))=obs1(Ind);
        end
        y(:,3)=fmod(Fact);%Model runs with the third sample in which only Xp values (the 1st factor) has changed
        
        %Here, I only change the values of the last factor in the set as
        %compared to the first sample
        x3=x;
        x3(:,end)=x1(:,end);%For the uncorrelated effects (first-order and total)
        xc4=x3*U;%Correlations
        for pp=1:Nvar
            [Ind]=Ranking(xc4(:,pp));
            [obs1,Ind1]=sort(Fact_Ref(:,Perm(pp)));
            Fact(:,Perm(pp))=obs1(Ind);
        end
        y(:,4)=fmod(Fact);%Model runs
        
        
        Ind=1:Nsample;
        Variance=var(y(:,1)); %
        Dbins(cnt,1)=Variance;
        STi_calc1 = mean((y(Ind,4)-y(Ind,1)).^2)/(2*Variance);%
        Si_calc1 =  mean(y(Ind,1).*(y(Ind,3)-y(Ind,2)))/(Variance);%1-mean((y(Ind,3)-y(Ind,1)).^2)/(2*Variance);%
        STi_calc2 = mean((y(Ind,3)-y(Ind,2)).^2)/(2*Variance);%
        Si_calc2 =  mean(y(Ind,2).*(y(Ind,4)-y(Ind,1)))/(Variance);%1-mean((y(Ind,4)-y(Ind,2)).^2)/(2*Variance);%
        
        SAE1(Perm(1)) = Si_calc1;%Full first-order effect
        TAE1(Perm(end)) = STi_calc1;%Uncorrelated total effect
        SAE2(Perm(end)) = Si_calc2;%Uncorrelated first-order effect
        TAE2(Perm(1)) = STi_calc2;%Full total effect
        
        C=(Mat_Perm)*(C*(Mat_Perm'));%Circular Permutation
        Perm=[Perm(2:end),Perm(1)];%Circular Permutation
    end
    Si_est_full(cnt,:)=(SAE1);%I compute the mean bootstrap estimate
    STi_est_ind(cnt,:)=(TAE1);%I compute the mean bootstrap estimate
    Si_est_ind(cnt,:)=(SAE2);%I compute the mean bootstrap estimate
    STi_est_full(cnt,:)=(TAE2);%I compute the mean bootstrap estimate
end

%% commented by GSI
load SiTrue

rho=-0.9999:0.05:0.9999;
figure
subplot(2,1,1)
plot(rho,Si_est_full(:,1),'bo',rho,STi_est_ind(:,1),'ro')
legend('S:i','ST_i')
title('y')
grid
subplot(2,1,2)
plot(rho,Si_est_full(:,2),'bo',rho,STi_est_ind(:,2),'ro')
legend('S_i','ST_i')
title('z')
grid
Si=Si_est_full;
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
title(['Monte Carlo Estimators& IC vs analytical values'])
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
%% end GSI

saveas(1,'montecarlo+IC1','tiff')
saveas(2,'montecarlo+IC2','tiff')