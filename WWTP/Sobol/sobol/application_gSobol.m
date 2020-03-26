% Tutorial: Perform GSA on g-function of Sobol

f = @(x)Evaluate_model(x);
N = 10000; % Number of MC samples

pars = {'price_{el}'; 'price_{gas}'; 'COP_{cool}'}; 
lbs =[ -0.07,	 -4023,	4.5];
ubs =[-0.035,   -1341,    13.5];    
InputSpace = {'ParNames',pars,'LowerBounds',lbs,'UpperBounds',ubs};

% Monte Carlo indices from the original model
%[mcSi,mcSTi] = easyGSA(f,N,InputSpace{:});

% Sobol indices using neural network 
[Si, STi] = easyGSA( f,N,InputSpace{:},'SamplingMethod', 'Sobol','UseSurrogate','ANN', 'useParallel', 'true')

% sobol indiceis using neural network, jansen estimator 
[jSi, jSTi] = easyGSA( f,N,InputSpace{:},'SamplingMethod', 'Sobol','UseSurrogate','ANN', 'useParallel', 'true', 'Estimator', 'Jansen')



T = table(Si, Si,Si,...
    'VariableNames', {'ANN'}, ...
    'RowNames', strseq('S',1:3));
fprintf("\n\nFirst Order Sensitivity Indices of Sobol' g-function\n\n")
disp(T)


% put all indices in a bar plot
H = [Si, jSi]; c = categorical(strseq('x',1:3));
bar(c,H); legend({'Saltelli', 'Jansen'});
ylabel('First Order Sobol indices'); xlabel('Input Parameters');
print('gSobol','-dpng','-r1200')
