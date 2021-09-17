matFiles = dir('*.m');
func_file = uigetfile('*.m');
index = 1;

for i = 1:1:length(matFiles)
   [fList,pList] = matlab.codetools.requiredFilesAndProducts(matFiles(i).name);
   for j = 1:1:length(fList)
       [~,file_name,ext] = fileparts(fList{j});
       file_name = strcat(file_name,ext);
       if strcmp(file_name,func_file)
           filesThatUse(index) = convertCharsToStrings(matFiles(i).name);
           index = index + 1;
       end
   end
   
   
end
fprintf('\n');
fprintf(func_file);fprintf(' is used in '); fprintf(int2str(length(filesThatUse)));
fprintf(' files:\n\n');
for i = 1:1:length(filesThatUse)
    fprintf(filesThatUse(i));
    fprintf('\n');
end
