%% Sampling strategies: Random, Stratified random (LHS) and Quasi-random (Sobol sequences) 
%it is all above how you subsample from the k dimensional (continous) input space.


clear all
clc
close all
%% method 1: Randomg sampling
%n. of variables
figure(1)
k=3; N=100;
grid,hold on;
%axis([0 1 0 1]);
for i=1:N
   X(i,:) = rand(1, k);
   plot(X(i,1),X(i,2),'o')
   %getframe;
end
hold off
title(['Random Sampling for k input ',num2str(2),' with sampling number N= ',num2str(N)])

%% 

%%method 2: Latin Hypercube sampling 
%n. of variables
k=2;
%n. of sample points
N=100;

X = lhs(N, k);
figure(2)
grid,hold on
for i=1:N
plot(X(i,1),X(i,2),'o')
end
hold off
title(['Latin Hypercube Sampling for k input ',num2str(2),' with sampling number N= ',num2str(N)])

%% Method 3: quasi-random low discrepancy sampling (sobol sequence)
%first test on quasi-random sampling
%n. of variables
k=2;
%number of sample points
N=100;
figure(6)
hold on;
axis([0 1 0 1]);
for i=1:N
   Xt=LPTAU51(i-1, k);
   X=Xt(1:k)+ones(1,k)/(2*N);
   plot(X(1),X(2),'o')
   getframe;
end
hold off
title(['Quasi-random sampling for k input= ',num2str(k),' with sample number N=',num2str(N)])
%%


%n. of variables
k=2;
%number of sample points
N=32;
figure(3)
hold on;
axis([0 1 0 1]);
%thick grids
for i=0:N/4:N-1
    plot([i/N i/N],[0 1],'linewidth',3)
    plot([0 1],[i/N i/N],'linewidth',3)
end
for i=1:N
   Xt=LPTAU51(i-1, k);
   X=Xt(1:k)+ones(1,k)/(2*N);
   plot(X(1),X(2),'o')
   getframe;
end
hold off
title(['Quasi-random sampling for k input= ',num2str(k),' with sample number N=',num2str(N)])
%%

%second test on quasi-random sampling

%n. of variables
k=2;
%number of sample points
N=64;
figure(4)
title(['Quasi-random sampling for k input= ',num2str(k),' with sample number N= ',num2str(N)])
hold on;
axis([0 1 0 1]);
%light grids
for i=0:N/8:N-1
  plot([i/N i/N],[0 1])
end
for i=0:N/8:N-1
  plot([0 1],[i/N i/N])
end
%thick grids
for i=0:N/4:N-1
    plot([i/N i/N],[0 1],'linewidth',3)
    plot([0 1],[i/N i/N],'linewidth',3)
end
Sample=[];
for i=1:N
   Xt=LPTAU51(i-1, k);
   X=Xt(1:k)+ones(1,k)/(2*N);
   plot(X(1),X(2),'o')
   getframe;
   Sample=[Sample;X];
end
hold off

%%

%third test on quasi-random sampling

%n. of variables
k=20;
%number of sample points
N=64;
figure(5)
title(['Quasi-random sampling for k input=',num2str(k),'with sample number N=',num2str(N)])
hold on;
axis([0 1 0 1]);
%light grids
for i=0:N/8:N-1
  plot([i/N i/N],[0 1])
end
for i=0:N/8:N-1
  plot([0 1],[i/N i/N])
end
%thick grids
for i=0:N/4:N-1
    plot([i/N i/N],[0 1],'linewidth',3)
    plot([0 1],[i/N i/N],'linewidth',3)
end
for i=1:N
   Xt=LPTAU51(i-1, k);
   X=Xt(1:k)+ones(1,k)/(2*N);
   plot(X(16),X(20),'o')
   getframe;
end
hold off

for i=1:6
    saveas(i,num2str(i),'tiff')
end