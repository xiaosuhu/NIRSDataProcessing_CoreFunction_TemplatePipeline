function DataOrganization_MoveInOut(file,filedir,iostatus,startnum)
% This function move the data file in or our from a sequential folder.
% Created Jan 30, 2019, Xiaosu Hu

switch iostatus
    case 'in'
        % Moving all the files into the sequential subject folders
        for i=1:length(file)
            mkdir(strcat('Subject',num2str(i-1+startnum)));
            movefile(file{i},strcat('Subject',num2str(i-1+startnum)));
        end
        
    case 'out'
        % Moving all the files out of the sequential subject folders
        % Go to the data folder that needs to have files moved out of and hen run the code.
        %
        filedirinfo=dir(filedir);
        
        % To control the start of file index
        if strncmp(filedirinfo(3).name,'.DS',3)
            startind=4;
        else
            startind=3;
        end
        
        for i=startind:length(filedirinfo)
            cd(filedirinfo(i).name);
            try
                movefile *.* ..
            catch
                warning('Somthing is wrong.')
            end
            cd ..
            rmdir(filedirinfo(i).name)
        end
end

end

