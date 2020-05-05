classdef SNRCheck < nirs.modules.AbstractModule
    %SIGNALSNRCHECK Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        filenamedigit1=1;
        filenamedigit2=2;
        channelofinterest=1;
    end
    
    methods
       function obj = SNRCheck(prevJob)
            obj.name = 'Check Signal to Nosie Ratio';
            
            if nargin > 0
                obj.prevJob = prevJob;
            end
       end
        
        function SNR = runThis(obj,data)
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
                            % Varience of HbO signal
                            SNR(i,j,1)=mean(abs(data(i).data(:,lsthbo(j))))/std(abs(data(i).data(:,lsthbo(j))));
                            % Varience of HbR signal
                            SNR(i,j,2)=mean(abs(data(i).data(:,lsthbr(j))))/std(abs(data(i).data(:,lsthbr(j))));
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
            subplot(2,1,1)
            bar(mean(SNR(:,obj.channelofinterest,1),2));
            for i=1:size(sum(SNR(:,obj.channelofinterest,1),2),1)
                h=text(i,0,data(i).description(obj.filenamedigit1:obj.filenamedigit2));
                set(h,'Rotation',90)
            end
            
            subplot(2,1,2)
            bar(mean(SNR(:,obj.channelofinterest,2),2));
            for i=1:size(sum(SNR(:,obj.channelofinterest,2),2),1)
                h=text(i,0,data(i).description(obj.filenamedigit1:obj.filenamedigit2));
                set(h,'Rotation',90)
            end
        end
    end
end

