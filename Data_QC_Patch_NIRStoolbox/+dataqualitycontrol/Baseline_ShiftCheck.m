classdef Baseline_ShiftCheck < nirs.modules.AbstractModule
    %BASELINE_SHIFTCHECK Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        filenamedigit1=1;
        filenamedigit2=2;
    end
    
    methods
          function obj = Baseline_ShiftCheck(prevJob)
            obj.name = 'Baseline Shift Check';
            
            if nargin > 0
                obj.prevJob = prevJob;
            end
        end
        
        function output=runThis(obj,data)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            for i=1:numel(data)
                if mod(i-1,16)==0
                    figure
                    count=1;
                end
                subplot(4,4,count);
                plot(data(i).time,mean(data(i).data(:,1:2:end-1),2));
                axis tight
                shading flat
                title(data(i).description(obj.filenamedigit1:obj.filenamedigit2));
                count=count+1;
            end
            
            output=1;
        end
    end
end

