%% perform monte-carlo simulations for variance decomposition indeces, Si
%% and STi

[n m] = size(A) ;
clear Ap Bp

%% run Monte Carlo simulations for sampling matrix 
for i=1:n
    % update the uncertain parameters
    par = A(i,:);

    %% Solution of the model, Ex1 of Saltelli et al 2009, y = X1 + X2 + X3
        X1 = par(1); % uniform distribution - parameter gamma (infection coeff)
        X2 = par(2);
        X3 = par(3);
        X4 = par(4); % beta distribution - parameter k (contact coeff)

    yA(i,:) = (1000*X4*X1-X2-X3);

end

%% run Monte Carlo simulations for sampling matrix B
% specify time (in hr) % initialize:

for i=1:n
    % update the uncertain parameters
    par=B(i,:);

    %% Solution of the model, Ex1 of Saltelli et al 2009, y = X1 + X2 + X3
    X1 = par(1);
    X2 = par(2);
    X3 = par(3);
    X4 = par(4);

    yB(i,:) = (1000*X4*X1-X2-X3);

end

%% run Monte Carlo simulations for sampling matrix C
% initialize C matrix
for j=1:m
    % update the C matrix
    BA = B ;
    BA(:,j) = A(:,j) ;
     for i=1:n
        % update the uncertain parameters
        par=BA(i,:);
        %% Solution of the model, Ex1 of Saltelli et al 2009, y = X1 + X2 + X3
        X1 = par(1); % uniform distribution - parameter gamma (infection coeff)
        X2 = par(2);
        X3 = par(3);
        X4 = par(4); % beta distribution - parameter k (contact coeff)
        yBA(i,j) = (1000*X4*X1-X2-X3);

    end
   

end

for j=1:m
    % update the C matrix % saltelli and jansen method 
    AB = A ;
    AB(:,j) = B(:,j) ;
     for i=1:n
        % update the uncertain parameters
        par=AB(i,:);
        %% Solution of the model, Ex1 of Saltelli et al 2009, y = X1 + X2 + X3
        X1 = par(1);
        X2 = par(2);
        X3 = par(3);
        X4 = par(4);
        yAB(i,j) = (1000*X4*X1-X2-X3);

    end
   
end
