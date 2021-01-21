%% calculate convergence statistics. refer to the book Gelman et al 2004
%% page 296-297
%B:betewen sequence variance
%W: within sequence variance
%R: scaled reduction for convergence it should be close 1
%varp: posterior variance
% copyright: Assoc.prof. Gürkan Sin
% DTU Chemical Engineering/28 July 2011
W=[];
B=[];
npar=length(tmin);
idx=burnratio*length(chain)+1;
chainbb=chain(:,idx:end,:);

for j=1:npar
    dummy=[];
    for i=1:chainnumber
        dummy=chainbb(i,:,j);
        muj(i)=mean(dummy);
        s2j(i)=var(dummy);
    end
    nn=length(dummy);
    B(j)=nn*var(muj);
    W(j)=mean(s2j); %variance of each estimands  
end
varp=(nn-1)/nn*W+1/nn*B;
R=sqrt(varp./W);
disp('MCMC sampler convergence statistics: R-scale for each estimatands:')
disp('for convergence it should be close to 1')
disp('              ')
disp(R)

y1=chain(:,idx:end,1)';
y2=chain(:,idx:end,2)';
y1b=y1(:);
y2b=y2(:);
chainb = [y1b y2b];

mcerr=sqrt(var(chainb))/sqrt(length(chainb));

disp('mean and std of parameters and monte carlo error')
disp([mean(chainb)' std(chainb)' mcerr'])
disp('Covariance Matrix')
disp(cov(chainb))
disp('Correlation Matrix')
disp(corrcoef(chainb))
