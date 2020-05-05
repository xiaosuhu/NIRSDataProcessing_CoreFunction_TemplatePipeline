function GainAdjustmentforCW6(filedir)
% Get the file directory using NIRS toolbox
fileset=nirs.io.loadDirectory(filedir,{'Subject'});
for i=1:length(fileset)
    filepath{i}=fileset(i).description;
end

% Gain Adjustment
for i=1:length(filepath)
    load(filepath{i},'-mat');
    if prod(systemInfo.gain)~=1
        for j=1:size(d,2)
            d(:,j)=d(:,j)/systemInfo.gain(ml(j,2));
        end
        for k=1:length(systemInfo.gain)
            systemInfo.gain(k)=1;
        end
        %         save(filepath{i}, 'aux','d','dStd','ml','s','SD','systemInfo','t','tdml');
        save(filepath{i}, 'aux','d','ml','s','SD','systemInfo','t');
        
        disp(strcat(filepath{i}, ' gain adjusted ... ...'))
    end
    
    % Set the gain back to 1 for all detector
    
    clearvars -except filepath i
end

end