classdef Cardiac_Spectrum_Check< nirs.modules.AbstractModule
    %CARDIAC_SPECTRUM_CHECK Summary of this class goes here
    %   Specify a channel that is not covered by hair and check if there is
    %   cardiac pulses to decide the signal quality
    
    properties
        % Default channel of interest that is skin only
        checkoption=1; % if ==1 check channelofinterest, if =2 check averaged signal from a channel set
        channelofinterest=1;
        filenamedigit1=1;
        filenamedigit2=2;
    end
    
    methods
        function obj = Anti_Corr_Check(prevJob)
            obj.name = 'HbO-HbR Anti Correlation Check';
            
            if nargin > 0
                obj.prevJob = prevJob;
            end
        end
        
        function output= runThis(obj,data)
            for i=1:numel(data)
                if mod(i-1,16)==0
                    figure
                    count=1;
                end
                switch obj.checkoption
                    case 1
                        [cfs,frq] = cwt(data(i).data(:,obj.channelofinterest),data(i).Fs);
                    case 2
                        [cfs,frq] = cwt(mean(data(i).data(:,obj.channelofinterest),2),data(i).Fs);
                end
                subplot(4,4,count);
                surface(data(i).time,frq,abs(cfs));
                caxis([0 2])
                axis tight
                shading flat
                colorbar
                title(data(i).description(obj.filenamedigit1:obj.filenamedigit2));
                count=count+1;
            end
            output=1;
        end
    end
end

