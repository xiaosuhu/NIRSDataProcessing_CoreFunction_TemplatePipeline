classdef SignalTemporalDerivativesCheck < nirs.modules.AbstractModule
    %SIGNALTEMPORALDERIVATIVESCHECK Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        filenamedigit1=1;
        filenamedigit2=2;
        lag=1;
    end
    
    methods
        function obj = SignalTemporalDerivativesCheck(prevJob)
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
                        for j=1:numel(obj.lag)
                            for k=1:length(lsthbo)
                                % Temporal Derivatives Check HbO
                                TmpDriviate(i,j,k,1)=mean(abs(diff(data(i).data(:,lsthbo(j)),obj.lag(j))));
                                % Temporal Derivatives Check HbR
                                TmpDriviate(i,j,k,2)=mean(abs(diff(data(i).data(:,lsthbr(j)),obj.lag(j))));
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
            for j=1:numel(obj.lag)
                figure
                subplot(2,1,1)
                bar(sum(squeeze(TmpDriviate(:,j,:,1)),2));
                for i=1:size(sum(squeeze(TmpDriviate(:,j,:,1)),2),1)
                    h=text(i,max(sum(squeeze(TmpDriviate(:,j,:,1)),2)),data(i).description(obj.filenamedigit1:obj.filenamedigit2));
                    set(h,'Rotation',60)
                end
                
                subplot(2,1,2)
                bar(sum(squeeze(TmpDriviate(:,j,:,2)),2));
                for i=1:size(sum(squeeze(TmpDriviate(:,j,:,2)),2),1)
                    h=text(i,max(sum(squeeze(TmpDriviate(:,j,:,2)),2)),data(i).description(obj.filenamedigit1:obj.filenamedigit2));
                    set(h,'Rotation',60)
                end
            end
        end
    end
end

