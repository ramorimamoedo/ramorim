%% perform monte-carlo simulations for variance decomposition indeces, Si
%% and STi

[n m] = size(A) ;
clear Ap Bp
yA=[]; 
y2A=[]; 
y3A=[]; 
yB=[]; 
y2B=[]; 
y3B=[]; 
yAB=[]; 
y2AB=[]; 
y3AB=[]; 
yBA=[]; 
y2BA=[]; 
y3BA=[]; 



%% run Monte Carlo simulations for sampling matrix 
for i=1:n
    % update the uncertain parameters
    par = A(i,:);

    % Solution of the model, Ex1 of Saltelli et al 2009, y = X1 + X2 + X3
   price_el = par(1);
   price_gas = par(2);
   COP_heatpump = par(3);

   y = Evaluate_model(price_el, price_gas, COP_heatpump);   

% Read results 

    fid = fopen('C:\osmose_julia\ET\pulp\Sobol\sobol\Sobol_results.txt', 'r'); 

     tline = fgetl(fid);
     data = sscanf(tline,'%f, %f, %f');
     fclose('all');
     yA(i,1) = data(1); 
     y2A(i,1) = data(2); 
     y3A(i,1)  = data(3); 
     
fid= fopen('C:\osmose_julia\ET\pulp\Sobol\sobol\Sobol_results.txt', 'w'); 
fclose('all');
end 

%% record the outputs
% y1 elec out y2 sng out y3 cost cooling 


fid= fopen('C:\osmose_julia\ET\pulp\Sobol\sobol\Sobol_results.txt', 'w'); 
fclose('all');
%% run Monte Carlo simulations for sampling matrix B
% specify time (in hr) % initialize:

for i=1:n
    % update the uncertain parameters
    par=B(i,:);


    %% Solution of the model, Ex1 of Saltelli et al 2009, y = X1 + X2 + X3
   price_el = par(1);
   price_gas = par(2);
   COP_heatpump = par(3);

   
    y = Evaluate_model(price_el, price_gas, COP_heatpump);   
     fid = fopen('C:\osmose_julia\ET\pulp\Sobol\sobol\Sobol_results.txt', 'r'); 
 tline = fgetl(fid);
     data = sscanf(tline,'%f, %f, %f');
     fclose('all');
%% record the outputs
% y1 elec out y2 sng out y3 cost cooling  
yB(i,1) = data(1); 
y2B(i,1) = data(2); 
y3B(i,1) = data(3); 
fid= fopen('C:\osmose_julia\ET\pulp\Sobol\sobol\Sobol_results.txt', 'w'); 
fclose('all');
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
        price_el = par(1);
        price_gas = par(2);
        COP_heatpump = par(3);
       y = Evaluate_model(price_el, price_gas, COP_heatpump);   
      fid = fopen('C:\osmose_julia\ET\pulp\Sobol\sobol\Sobol_results.txt', 'r'); 
     tline = fgetl(fid);
     data = sscanf(tline,'%f, %f, %f');
    fclose('all');
    
  
          
    %% record the outputs
    % y1 elec out y2 sng out y3 cost cooling 
    
    yBA(i,j) = data(1); 
    y2BA(i,j) = data(2); 
    y3BA(i,j) = data(3); 

    fid= fopen('C:\osmose_julia\ET\pulp\Sobol\sobol\Sobol_results.txt', 'w'); 
   fclose('all');
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
         price_el = par(1);
         price_gas = par(2);
         COP_heatpump = par(3);
         y = Evaluate_model(price_el, price_gas, COP_heatpump);   
 fid = fopen('C:\osmose_julia\ET\pulp\Sobol\sobol\Sobol_results.txt', 'r'); 
     tline = fgetl(fid);
     data = sscanf(tline,'%f, %f, %f');
     fclose('all');
    
   
     

%% record the outputs
% y1 elec out y2 sng out y3 cost cooling 
    yAB=[]; 
    yAB(i,j) = data(1); 
    y2AB(i,j) = data(2); 
    y3AB(i,j) = data(3); 
  fopen('C:\osmose_julia\ET\pulp\Sobol\sobol\Sobol_results.txt', 'w'); 
  fclose('all');
     end
end
