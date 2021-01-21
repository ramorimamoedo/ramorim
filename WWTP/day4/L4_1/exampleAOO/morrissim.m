%% perform Morris simulations: using the Morris Samples

[n m] = size(Xval) ; 

% specify time (in hr) % initialize:
time = [0:0.002:0.12];
initcond

% run Morris simulations
for i=1:n
% update the uncertain parameters
par(1:4)=Xval(i,:);

%% Solution of the model
options=odeset('RelTol',1e-7,'AbsTol',1e-8);
[t,y] = ode45(@nitmod,time,x0,options,par);

%% record the outputs
y1(:,i) = y(:,1);
y2(:,i) = y(:,2);
y3(:,i) = y(:,3);
y4(:,i) = y(:,4);
y5(:,i) = y(:,5);

end


