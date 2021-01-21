%% we reproduce hte example from Thomas Most article
% April 12th, 2016 
% Gurkan Sin @DTU Chemical Engineering
clear
clc
close all

%%
% In the first example a purely additive model is investigated
% f(y,z) = a1y + a2z. 
% The input variables are normally distributed, have zero mean and the covariance
mu=[0 0]; % mu does not effect the variance calculations
s=[1 2];  % assume sigmay=1 and sigmayz=3. 
rho=-0.9999:0.05:0.9999;
N=length(rho);
for i=1:N
D(i)=s(1)^2+s(2)^2+2*rho(i)*s(1)*s(2);
Dy(i)=(s(1)+rho(i)*s(2))^2;
Dz(i)=(rho(i)*s(1)+s(2))^2;
DTy(i)=D(i)-Dz(i);
DTz(i)=D(i)-Dy(i);
end
Sy=Dy./D;STy=DTy./D;
Sz=Dz./D;STz=DTz./D;
figure
subplot(1,3,1)
plot(rho,Sy,'ro',rho,STy,'bo')
%[hAx,hLine1,hLine2]=plotyy([rho rho],[Sy STy],rho,Dy)
legend('Sy','STy')
grid on
ylabel('Sensitivity indices')
xlabel('correlation coefficient,\rho')
set(gca,'Fontsize',14,'Fontweight','bold')
subplot(1,3,2)
plot(rho,Sz,'rp',rho,STz,'bp')
title(['Linear additive model with mu: ', num2str(mu),' and sigma: ',num2str(s),' and rho in x-axis '])
legend('Sz','STz')
grid on
ylabel('Sensitivity indices')
xlabel('correlation coefficient,\rho')
set(gca,'Fontsize',14,'Fontweight','bold')
subplot(1,3,3)
plot(rho,Sz+Sy,'k+')
legend('Sz+Sy')
grid on
ylabel('Sensitivity indices')
xlabel('correlation coefficient,\rho')
set(gca,'Fontsize',14,'Fontweight','bold')

figure
%subplot(1,3,1)
plot(rho,D,'ro',rho,Dy,'bh',rho,Dz,'kp')
legend('Dy','Dy','Dz')
grid on
ylabel('variance')
xlabel('correlation coefficient,\rho')
set(gca,'Fontsize',14,'Fontweight','bold')

saveas(1,num2str(1),'tiff')
saveas(2,num2str(2),'tiff')

save SiTrue STy STz Sy Sz Dy Dz D