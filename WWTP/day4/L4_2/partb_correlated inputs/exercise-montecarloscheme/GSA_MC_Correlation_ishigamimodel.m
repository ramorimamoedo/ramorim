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

close all
clear; clc
fmod = @(X) sin(X(:,1))+7.*sin(X(:,2)).^2+0.1.*(X(:,3).^4).*sin(X(:,1));
% define range for inputs
lb=[-pi -pi -pi];ub=[pi pi pi];

Nvar=3;
Nsample=2^11;
CC=eye(Nvar,Nvar);
Mat=eye(Nvar-1,Nvar-1);
Mat_Perm=zeros(Nvar,Nvar);
Mat_Perm(end,1)=1;
Mat_Perm(1:end-1,2:end)=Mat;

%perform sampling (quasi-random using sobol sequence)
Delay=128;%To reduce correlated samples when uncorrelated ones are desired.
for k=1:Nsample
    sb=LPTAU51(Delay+k,2*Nvar);%I need 2xNvar independent samples
    Fact_Ref2(k,:)=(sb-0.5)*2; % from 0 - 1 to uniform distribution (-1 to 1)
    Fact_Ref(k,:)=unifinv(sb,[lb lb] ,[ub ub]); % from 0 - 1 to uniform distribution (lb to ub)
end

% %Uniformly distributed values (-1 1) mapped to normally distributed values
% %(mu=0 & std=1) (independent)
 x=sqrt(2)*erfinv(Fact_Ref2(:,1:Nvar));%
 x1=sqrt(2)*erfinv(Fact_Ref2(:,Nvar+1:2*Nvar));%

%This is the example for the Ishigami function of Kucherenko et al. CPC
%2012
cnt=0;

for rho=-0.9999:0.05:0.9999;
    cnt=cnt+1;
    C=eye(Nvar,Nvar);
    C(1,3)=rho;C(3,1)=C(1,3);
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
        
        %% calculate the indices 
        Ind=1:Nsample;
        Variance=var(y(:,1)); Dbins(cnt,1)=Variance;
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
    Si_est_full(cnt,:)=(SAE1);%record
    STi_est_ind(cnt,:)=(TAE1);%record 
    Si_est_ind(cnt,:)=(SAE2);%record
    STi_est_full(cnt,:)=(TAE2);%record
end

%% commented by GSI
figure
subplot(2,1,1)
plot(RHO,Si_est_ind,'o')
legend('x_1','x_2','x_3')
ylabel('Si_{independent}')
ylim([0 0.7])
grid
subplot(2,1,2)
plot(RHO,STi_est_ind,'*')
legend('x_1','x_2','x_3')
ylabel('STi_{independent}')
ylim([0 0.7])
grid

figure
subplot(2,1,1)
plot(RHO,Si_est_full,'o')
ylim([0 0.7])
legend('x1','x2','x3')
grid on
xlabel('correlation coefficient,\rho')
ylabel(['Si: Main effects'])
set(gca,'Fontsize',14,'Fontweight','bold')
subplot(2,1,2)
plot(RHO,STi_est_full,'*')
ylabel(['STi: Total effects'])
ylim([0 0.7])
legend('x1','x2','x3')
grid on
xlabel('correlation coefficient,\rho')
set(gca,'Fontsize',14,'Fontweight','bold')

saveas(1,'Independenteffects','tiff')
saveas(2,'Totaleffects','tiff')

%% end GSI