classdef Anti_Corr_Check < nirs.modules.AbstractModule
    %ANTI_CORR_CHECK Summary of this class goes here
    %  Check the anticorrelation between HbO and HbR signals
    
    properties
        filenamedigit1=1;
        filenamedigit2=2;
        channelofinterest=1;
    end
    
    methods
        function obj = Anti_Corr_Check(prevJob)
            obj.name = 'HbO-HbR Anti Correlation Check';
            
            if nargin > 0
                obj.prevJob = prevJob;
            end
        end
        
        function anticorr_ch = runThis( obj, data )
            for i=1:numel(data)
                types=unique(data(i).probe.link.type);
                if numel(types)==2
                    % HbO signal
                    tI=1;
                    lsthbo=find(ismember(data(i).probe.link.type,types{tI}));
                    
                    % HbR signal
                    tI=2;
                    lsthbr=find(ismember(data(i).probe.link.type,types{tI}));
                    
                    % Correlation Calc
                    if length(lsthbo)==length(lsthbr)
                        for j=1:length(lsthbo)
                            anticorr_ch(i,j)=corr(data(i).data(:,lsthbo(j)),data(i).data(:,lsthbr(j)));
                        end
                    else
                        disp('Data is missing...')
                    end
                    
                    
                else
                    disp('More signals are found than HbO & HbR, cannot proceed with correlation calc...')
                    return
                end
            end
            
            % Plotting part
            figure
            errorbar(mean(anticorr_ch(:,obj.channelofinterest),2),std(anticorr_ch(:,obj.channelofinterest),0,2),'-s','MarkerSize',10,'MarkerEdgeColor','red','MarkerFaceColor','red');
            line([0 size(anticorr_ch,1)],[-0.5 -0.5],'Color','r','LineStyle','--')
            line([0 size(anticorr_ch,1)],[-1 -1],'Color','r','LineStyle','--')
            line([0 size(anticorr_ch,1)],[0 0],'Color','r','LineStyle','--')
            line([0 size(anticorr_ch,1)],[0.5 0.5],'Color','r','LineStyle','--')
            line([0 size(anticorr_ch,1)],[1 1],'Color','r','LineStyle','--')
            
            for i=1:size(anticorr_ch,1)
                h=text(i,0,data(i).description(obj.filenamedigit1:obj.filenamedigit2));
                set(h,'Rotation',90)
            end
            
        end
    end
    
end
