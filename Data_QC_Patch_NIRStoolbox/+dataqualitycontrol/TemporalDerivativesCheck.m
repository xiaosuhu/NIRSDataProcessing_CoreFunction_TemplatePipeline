classdef TemporalDerivativesCheck < nirs.modules.AbstractModule
    %SIGNALTEMPORALDERIVATIVESCHECK Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        filenamedigit1=1;
        filenamedigit2=2;
        derivateorder=1;
        channelofinterest=1;
    end
    
    methods
        function obj = TemporalDerivativesCheck(prevJob)
            obj.name = 'Temporal Derivatives Check';
            
            if nargin > 0
                obj.prevJob = prevJob;
            end
        end
        
        function TmpDriviate = runThis(obj,data)
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
                        for j=1:numel(obj.derivateorder)
                            for k=1:length(lsthbo)
                                % Temporal Derivatives Check HbO
                                TmpDriviate(i,j,k,1)=mean(abs(diff(data(i).data(:,lsthbo(k)),obj.derivateorder(j))))/mean(abs(data(i).data(:,lsthbo(k))));
                                % Temporal Derivatives Check HbR
                                TmpDriviate(i,j,k,2)=mean(abs(diff(data(i).data(:,lsthbr(k)),obj.derivateorder(j))))/mean(abs(data(i).data(:,lsthbr(k))));
                            end
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
            for j=1:numel(obj.derivateorder)
                figure
                subplot(2,1,1)
                bar(mean(squeeze(TmpDriviate(:,j,obj.channelofinterest,1)),2));
                for i=1:size(sum(squeeze(TmpDriviate(:,j,obj.channelofinterest,1)),2),1)
                    h=text(i,0,data(i).description(obj.filenamedigit1:obj.filenamedigit2));
                    set(h,'Rotation',90)
                end
                
                subplot(2,1,2)
                bar(mean(squeeze(TmpDriviate(:,j,obj.channelofinterest,2)),2));
                for i=1:size(sum(squeeze(TmpDriviate(:,j,obj.channelofinterest,2)),2),1)
                    h=text(i,0,data(i).description(obj.filenamedigit1:obj.filenamedigit2));
                    set(h,'Rotation',90)
                end
            end
        end
    end
end

