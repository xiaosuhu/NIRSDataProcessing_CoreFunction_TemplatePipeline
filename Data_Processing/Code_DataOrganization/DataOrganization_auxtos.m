function DataOrganization_auxtos(file, stimdur)
% FNIRS_AUX_TO_S covert the aux variable in the .nirs file into s
% so that the nirstoolbox can reconize the stimmarks
% Created Jan 30, 2019, Xiaosu Hu
% Fixed bugs by Xiaosu Hu Feb 7 2019

for i=1:length(file)
    clearvars -except i file stimdur
    load(file{i},'-mat');
    Fs=1/mean(diff(t));
    s = aux(:,1:4);
    s(s>1) = 1;
    s(s<1) = 0;
    
    % Check which column of s is empty and remove them
    emptyindex=[];
    for j=1:size(s,2)
        if isempty(find(s(:,j),1))
            emptyindex=[emptyindex j];
        end
    end
    s(:,emptyindex)=[];
    
    % Check which stim is larger than specified stimdur, and remove them
    for j=1:size(s,2)
        count=1;
        for k=2:size(s,1)
            if s(k,j)==1&&s(k-1,j)==1
                count=count+1;
            elseif s(k,j)==0&&s(k-1,j)==1
                 if count>=Fs*stimdur
                    s(k-count-1:k,j)=0;
                 end
            elseif s(k,j)==1&&s(k-1,j)==0
                count=1;
            end
        end
    end

    % Clean the stim mark
    % With a predefiend duration, the program will combine the unneccessary
    % stim marks
    % ============================
    if stimdur>0
        startind=diff(s);
        startind(startind<0)=0;
        for j=1:size(startind,2)
            tmpind=find(startind(:,j)~=0);
            for k=1:length(tmpind)
                s(tmpind(k):tmpind(k)+Fs*stimdur,j)=1;
            end
        end
    end
    % ============================
    try
        save(file{i},'aux','d','dStd','ml','s','SD','systemInfo','t','tdml');
    catch
        save(file{i},'aux','d','ml','s','SD','systemInfo','t');
    end
    disp(strcat(file{i},' completed.....'));
end

end

