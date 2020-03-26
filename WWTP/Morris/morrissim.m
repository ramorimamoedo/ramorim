%% perform Morris simulations: using the Morris Samples

[n m] = size(Xval) ; 

% run Morris simulations
for k=1:n
% update the uncertain parameters

price_el = Xval(k,1); 
price_gas = Xval(k,2); 
Initial_solids = Xval(k,3); 

%prepare lua ET files accordingly 
%%
WWTP = textread('/Users/rafael/Documents/osmose/personal/ET/ET_HTL/WWTP_clean.lua','%s','delimiter','\n'); %File to change parameters
%utilities = textread('C:\osmose_julia\ET\pulp\generic_utilities.lua','%s','delimiter','\n');	% tested with matlab
%htg = textread('C:\osmose_julia\ET\pulp\htg_exp_sel_noh2.lua','%s','delimiter','\n');	% tested with matlab


for i=1:length(WWTP)
    if  contains(WWTP(i), 'Initial_solids       = {default') 
        update = {'Initial_solids       = {default = ',num2str(Initial_solids),' , unit = ''g/kg'', description = ''''},'} ; 
        WWTP(i)= join(update);
        break
    end 
end 


% for j=1:length(utilities)
%     if  contains(utilities(j), 'COP_heatpump = {default = ') ==1 
%         update = {'COP_heatpump = {default = ',num2str(COP_heatpump), ',min=0, max=100000, unit = ''''},'} ; 
%         utilities(j)= join(update);
%     end 
% end 
% 
% 
% for j=1:length(htg)
%     if  contains(htg(j), 'price_gas   = {default') ==1 
%         update = {'price_gas   = {default  =', num2str(price_gas), ',unit = ''USD/kgh'', description = ''''},'} ; 
%         htg(j)= join(update);
%     end 
% end 


fileRes = fopen('/Users/rafael/Documents/osmose/personal/ET/ET_HTL/WWTP_clean.lua','w');
fprintf(fileRes,'%s\n',WWTP{:});
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



 
[status,result] = unix('cd "/Users/rafael/Documents/osmose" && /usr/local/bin/lua personal/projects/HTL/HTL_frontend.lua');
disp(num2str(k)); 


end

%% Read results 

fid = readtable('C:\osmose_julia\ET\pulp\Morris\Morris_results.txt');

% now all the results should be written in a text file 
%next step: open text file and read all values , separate them by komma 
% assign y1 , y2, y3 


%% record the outputs
% y1 elec out y2 sng out y3 cost cooling 
y1 = (fid(:, 1)); 
y2 = (fid(:, 2)); 
y3 = (fid(:, 3)); 






