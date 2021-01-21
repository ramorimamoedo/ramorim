%% this is the analytical solution to the linear example
%example f(x1,x2,x3)=x1+x2+x3; 
% % saltelli et al 2009 page 175
clear 
clc
syms f x1 x2 x3; 
x1v=[0.5 1.5];
x2v=[1.5 4.5];
x3v=[4.5 13.5]; 
mu=[1 3 9];
px1=1/(x1v(2)-x1v(1)); %probability of a uniform distribution.
px2=1/(x2v(2)-x2v(1)); %probability of a uniform distribution.
px3=1/(x3v(2)-x3v(1)); %probability of a uniform distribution.

f = x1 + x2 + x3;  % write the function
%compute the mean f0=int(f*p(x)dx): Triple integration is solved by iterated integration over x1,x2 and x3 domain. 
intx1=int(f*px1,x1,x1v(1),x1v(2)); %first iteration over x1
intx2=int(intx1*px2,x2,x2v(1),x2v(2)); %second iteration over x2
f0=int(intx2*px3,x3,x3v(1),x3v(2)); % last iterationover x3
% compute variance: var= int(f^2*p(x)*dx)-f0^2 by definition.
intv1=int(f^2*px1,x1,x1v(1),x1v(2)); %first iteration over x1
intv2=int(intv1*px2,x2,x2v(1),x2v(2)); % second iterationover x2
vary=int(intv2*px3,x3,x3v(1),x3v(2))-f0^2; % second iterationover x2
vary=double(vary);

%% HDMR terms f1,f2,f12,...: f(x)-f0=f1+f1+f12+...
ix2=int(f*px2,x2,x2v(1),x2v(2)) ; %first iteration over x2i.e. take the integral of f over x2
Eox1=int(ix2*px3,x3,x3v(1),x3v(2)) ; % integrate the function where x1 is fixed E(y|x1) (i.e. so x2 &x3 is being integrated))
Eox2=int(intx1*px3,x3,x3v(1),x3v(2)) ; % integrate the function where x2 is fixed E(y|x2) (i.e. so x1 and x3 is being integrated)
Eox3=int(intx1*px2,x2,x2v(1),x2v(2)) ; % integrate the function where x3 is fixed E(y|x2) (i.e. so x1 and x2 is being integrated)

% since the model f doesnt have any interaction, the following HDMR terms
% doesnt apply
% Eox1x2=int(f*px3,x3,x3v(1),x3v(2)); % basically expected value of y|x1,x2 where x1 and x2 fixed i.e. integrate over x3.
% Eox1x3=int(f*px2,x2,x2v(1),x2v(2)); % basically expected value of y|x1,x3 where x1 and x3 fixed i.e. integrate over x2.
% Eox2x3=int(f*px1,x1,x1v(1),x1v(2)); % basically expected value of y|x1,x3 where x1 and x3 fixed i.e. integrate over x2.

f1=Eox1-f0;
f2=Eox2-f0;
f3=Eox3-f0;
% f12=Eox1x2-f1-f2-f0;
% f13=Eox1x3-f1-f3-f0;
% f23=Eox2x3-f2-f3-f0;
%% calculate variance contribution: %Vi=int(f(xi)^2*p(xi)*dxi where fxi=E(y|xi)-f0 

V1 = int(f1^2*px1,x1,x1v(1),x1v(2)); 
V2 = int(f2^2*px2,x2,x2v(1),x2v(2)); 
V3 = int(f3^2*px3,x3,x3v(1),x3v(2)); 
% V12 = int(f12^2*px1,x1,x1v(1),x1v(2)); 
% V13 = int(f13^2*px1,x1,x1v(1),x1v(2)); 
% V23 = int(f23^2*px2,x2,x2v(1),x2v(2)); 

%%sensitivity indices, s1
Vi=[V1;V2;V3];Vi=double(Vi);
vary1=sum(Vi); Si=Vi./vary;
t=table(Vi,Si,'RowNames',{'x1','x2','x3'})

save Sitrue Si Vi vary f0
