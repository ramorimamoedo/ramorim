%% Evaluating the results of Bayesian MCMC sampling
% copyright: Assoc.prof. Gürkan Sin
% DTU Chemical Engineering/28 July 2011

y1r=chain(:,:,1)';
y2r=chain(:,:,2)';
y1v=y1r(:);
y2v=y2r(:);
chainv = [y1v y2v];

figure(2)
subplot(2,1,1)
set(gca,'FontSize',14)
plot(1:length(y1v),y1v,'.k')
xlabel(gca,'Markov chain simulations')
ylabel(gca,'\mu_{max}')

title(['acceptance ratio: ',num2str(length(A)/(length(A)+length(Rj)))])

subplot(2,1,2)
set(gca,'FontSize',14)
plot(1:length(y2v),y2v,'.k')
xlabel(gca,'Markov chain simulations')
ylabel(gca,'K_{s}')
title(['acceptance ratio: ',num2str(length(A)/(length(A)+length(Rj)))])


%%plot joint posterior density function as well as 95% confidence ellipsoid
%%between two pair of parameters: see Seber and Wild, 1989 for confidence
%%ellipsoid plotting
% %% kernel density estimation for bivariate distributions using gkde2
% algorithm
figure(3)
set(gca,'FontSize',14)
p=gkde2([y1b y2b]);
cl =max(max(p.pdf))-min(min(p.pdf));
C90=contour(p.x,p.y,p.pdf,[0.10*cl 0.10*cl]);  % 90% level
hold on
plot(y1b,y2b,'.k','MarkerSize',5)
xlabel('\mu_{max}')
ylabel('K_{s}')

% plot histogram/density of parameters
figure(4)
subplot(2,2,1)
set(gca,'FontSize',14)
hist(y1b)
ylabel(gca,'frequency')
xlabel(gca,'\mu_{max}')
subplot(2,2,2)
set(gca,'FontSize',14)
hist(y2b)
ylabel(gca,'frequency')
xlabel(gca,'K_{s}')
subplot(2,2,3)
set(gca,'FontSize',14)
[f,xi] = ksdensity(y1b);
plot(xi,f)
ylabel('Probability/density function')
xlabel('\mu_{max}')
subplot(2,2,4)
set(gca,'FontSize',14)
[f,xi] = ksdensity(y2b);
Z = trapz(xi,f) ;% integral of the area under pdf
plot(xi,f)
ylabel('Probability/Density function')
xlabel('K_S')

%% posterior simulations
% randomly sample from joint posterior distribution of the parameters

postsample = 500;
posttheta = chainb(randi(length(chainb), [postsample 1]),:); % randomly draw from the chain nsample values
if ~isempty(s2chain)
posts2= s2chain(randi(length(chainb), [postsample 1]),:); % randomly draw from the s2 chain
end
ypost=[];
td=data.s;

for i=1:postsample
    ypost(:,i) = modelfun(td,posttheta(i,:));  % model parameter uncertainty
end

% adding the random errors which follows gaussian normal distirbution
% (mean=0 and sigma = estimated sample variance)
if isempty(s2chain)
    ypost1= ypost + randn(size(ypost)).* sqrt(s2);
   else
ypost1= ypost + randn(size(ypost))*diag(sqrt(s2chain(postsample,:)));
end
% calculate 95% confidence intervals of posterior simulations using ecdf
% funtion. one could also use prctile command!

x05=[];
x95=[];
for i=1:length(td)
    [fp,xp,flo,fup] = ecdf(ypost1(i,:));
    x95(i,1)=xp(find(fp<0.95,1,'last')); % Pr(x<X)= 0.95
    x05(i,1)=xp(find(fp<0.05,1,'last'));  % Pr(x<X)=0.05
end
yy = [x95 x05 mean(ypost1,2)];
%yy = [prctile(ypost,0.95)' prctile(ypost,0.05)' mean(ypost)'];

figure(5)
set(gca,'FontSize',14)
h=plot(td,ypost1,'k','color',[0.6 0.6 0.6]);
legend(h(1),'posterior simulations')
hold on
h1=plot(td,data.mu,'r.');
hold on
h2=plot(td,yy(:,1),'r',td,yy(:,2),'b',td,yy(:,3),'k');
legend([h1 h(1) h2'], 'data','posterior simulations','upper 95%','lower 5%','mean')
ylabel('mu')
xlabel('substrate')

saveas(1,'fig1','tif')
saveas(2,'fig2','tif')
saveas(3,'fig3','tif')
saveas(4,'fig4','tif')
saveas(5,'fig5','tif')

