
%% perform Morris simulations: using the Morris Samples

n_objectives = 3 %numeber of objectives out of osmose
[n m] = size(Xval) ; 
export = zeros(n,n_objectives); %creating results matrix
% run Morris simulations
for k=1:n
% update the uncertain parameters

price_el = Xval(k,1); 
price_gas = Xval(k,2); 
Initial_solids = Xval(k,3); 

%prepare lua ET files accordingly 
%%
WWTP = textread('C:\osmose-projects\personal\ET\ET_HTL\WWTP_clean.lua','%s','delimiter','\n'); %File to change parameters
utilities = textread('C:\osmose-projects\personal\ET\ET_HTL\Utilities.lua','%s','delimiter','\n');	
%htg = textread('C:\osmose_julia\ET\pulp\htg_exp_sel_noh2.lua','%s','delimiter','\n');	% tested with matlab


for i=1:length(WWTP)
    if  contains(WWTP(i), 'Initial_solids       = {default') 
        update = {'Initial_solids       = {default = ',num2str(Initial_solids),' , unit = ''g/kg'', description = ''''},'} ; 
        WWTP(i)= join(update);
        break
    end 
end 


for j=1:length(utilities)
    if  contains(utilities(j), 'Elec_cost = {default = ') ==1 
        update = {'Elec_cost = {default =',num2str(price_el), ', unit = ''EUR/MWh''},'} ; 
        utilities(j)= join(update);
    end
    if  contains(utilities(j), 'Gas_cost = {default = ') ==1 
        update = {'Gas_cost = {default =',num2str(price_gas), ', unit = ''EUR/MWh''},'} ; 
        utilities(j)= join(update);
        break
    end 
end 


% for j=1:length(htg)
%     if  contains(htg(j), 'price_gas   = {default') ==1 
%         update = {'price_gas   = {default  =', num2str(price_gas), ',unit = ''USD/kgh'', description = ''''},'} ; 
%         htg(j)= join(update);
%     end 
% end 


fileRes = fopen('C:\osmose-projects\personal\ET\ET_HTL\WWTP_clean.lua','w');
fprintf(fileRes,'%s\n',WWTP{:});
fclose(fileRes);

fileRes = fopen('C:\osmose-projects\personal\ET\ET_HTL\Utilities.lua','w');
fprintf(fileRes,'%s\n',utilities{:});
fclose(fileRes);

% fileUt = fopen('C:\osmose_julia\ET\pulp\generic_utilities.lua','w');
% fprintf(fileRes,'%s\n',utilities{:});
% fclose(fileRes);
% 
% 
% 
% 
% fileRes = fopen('C:\osmose_julia\ET\pulp\htg_exp_sel_noh2.lua','w');
% fprintf(fileRes,'%s\n',htg{:});
% fclose(fileRes);



 
[status,result] = system('cd "C:\osmose-projects\personal" && lua projects\HTL\HTL_frontend.lua');
[status,out] = system('cd "C:\osmose-projects\personal" && ampl_lic stop');
file = csvread('C:\osmose-projects\personal\results\WWTP_MATLAB\run_000_testing\results_matlab.csv')
export(k,:) = file
disp(num2str(k)); 


end

%% Read results 

%fid = readtable('C:\osmose_julia\ET\pulp\Morris\Morris_results.txt');

% now all the results should be written in a text file 
%next step: open text file and read all values , separate them by komma 
% assign y1 , y2, y3 


%% record the outputs
% y1 elec out y2 sng out y3 cost cooling 
y1 = export(:, 1); 
y2 = export(:, 2); 
y3 = export(:, 3); 






