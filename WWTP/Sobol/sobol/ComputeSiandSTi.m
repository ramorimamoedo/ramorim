function[Si1 Si2 Si3 STi1 STi2 STi3 ]   = ComputeSiandSTi(ya, yb, yba, yab) 
%% In this mfile, the first-order sensitivity index, Si and total effect
%% index, STi are calculated from the monte carlo simulations performed
%% with the psuedo random sampling

% Source: Saltelli et al 2009, pp 165

% Gurkan Sin, PhD @ DTU, 17 July 2009


%% calculate Si for each parameter
[n2 m2] = size(ya);
for i=1:m2 % for each model output
%    ya = y3A ;
%    yb = y3B ;
    mu = mean([ya; yb]); % to improve the estimate of mean
    vary = var([ya; yb]) ;
    for j=1:3 % for each parameter
        %% sobol's method
        ybai = yba(:,j) ;
        yabi = yab(:,j) ;
        vx1(j,1)= mean(ya .* ybai) - mu^2 ;
        Si1(j,i)= vx1(j,1) / vary ; % first-order sensitivity index
        ex1(j,1)=  mean(ya .* (ya - yabi)) ;
        STi1(j,i)= ex1(j,1) / vary ; % total effects index
        
        %% saltelli et al 2010
        vx2(j,1)= mean(yb .* (yabi - ya)) ;
        Si2(j,i)= vx2(j,1) / vary ; % first-order sensitivity index
        ex2(j,1)= 1/(2*n2) * sum((ya - yabi).^2) ;
        STi2(j,i)= ex2(j,1) / vary ; % total effects index
        
        %% Jansen et al
        vx3(j,1)= vary - 1/(2*n2) * sum((yb - yabi).^2) ;
        Si3(j,i)= vx3(j,1) / vary ; % first-order sensitivity index
        ex3(j,1)= 1/(2*n2) * sum((ya - yabi).^2) ;
        STi3(j,i)= ex3(j,1) / vary ; % total effects index
        
    end
end



%% display results


% first order sensitivity: column: model outputs, parameters: rows
disp('first order sensitivity, Si: column: model outputs, parameters: rows')
disp('      Sobol Saltelli Jansen       True')
disp([Si1 Si2 Si3])
disp(sum([Si1 Si2 Si3]))

disp('')
disp('Total effects, STi: column: model outputs, parameters: rows')
disp('      Sobol Saltelli Jansen')
disp([STi1 STi2 STi3])
disp(sum([STi1 STi2 STi3]))


end