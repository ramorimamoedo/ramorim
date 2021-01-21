function [Xc CXc]=imancon(C,X)
% Rank correlated sampling using Gaussian copula
% 
% Input:
%   C    : correlation matrix of the variables (nvar,nvar)
%   X : uncorrelated samples 
% Output:
%   Xc     : LHS sampling with corretion control (nsample,nvar)(units
%   CX: Correlatoin matrix of rank-sorted samples Xcf. 
%   Gurkan Sin (2011), DTU
errmin=100;
[nsample nvar]=size(X);
S=rand(nsample,nvar);
for it=1:10
    %% definite
    % using modified cholesky for corr matrix that is not quite positive definite
    P = chol(C); % Upper triangular matrix
    %%below is an alternative cholesky decomposition
    %     [L,D,E1]=mchol(C);
    %     P=L*sqrt(D);

    %% The correlation matrix of S should be an identity matrix.
    E = corrcoef(S);
    Q = chol(E); % Upper triangelur matrix
    Q=Q'; % Transposed to lower triangular matrix
  %an alternative cholesky decomposition:
    Str = S*inv(Q)'*P ;
    
    % First calculate the rank of Str's elements
    [srtS ix1] =sort(Str);
    
    rStr = zeros(nsample,nvar);
    for i=1:nvar
        rStr(ix1(:,i),i)=1:nsample;
    end

    % Now we need to rearrange the elements of X such that it corresponds with
    % the rank order of the elements of Str, i.e. rStr:
    
    [srtX ix2] =sort(X);
    
    for i=1:nvar
        Xcorr(:,i)=srtX(rStr(:,i),i);
    end
    
    CX = corrcoef(Xcorr);
    err2 = sum(sum(abs(CX - C))) ;
    
    % update
    if(err2<errmin)
        Xc=Xcorr;
        CXc = CX;
        errmin = err2;
        kk=it;
    end
    
end
