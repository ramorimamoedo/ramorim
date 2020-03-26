%[status,result] = system('cd "C:\osmose_julia" && lua projects\pulp\water_frontend.lua');
%{

%%Reading
cd 
files = textread('C:\osmose_julia\ET\test2.txt','%s','delimiter','\n');	% tested with matlabf
%D= []; 


for i=1:length(files)
    if  contains(files(i), 'Hans') ==1 
        files(i) = {'Christa'}; 
       
  
    end
end


filePh = fopen('test2.txt','w');
fprintf(filePh,'%s\n',files{:});
fclose(filePh);

%}
fid = readtable('C:\osmose_julia\ET\pulp\Morris\Morris_results.txt');
%data = textscan(fid, '%*s %*s %f %*[^\n]','HeaderLines',1);


