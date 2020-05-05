classdef StationaryCheck < nirs.modules.AbstractModule
    %STATIONARYCHECK Summary of this class goes here
    %   Uses KPSS test in Matlab to test trend stationary
    
    properties
        filenamedigit1=1;
        filenamedigit2=2;
        lag=1;
        trend=true;
    end
    
    methods
        function obj = StationaryCheck(prevJob)
            obj.name = 'StationaryCheck';
            
            if nargin > 0
                obj.prevJob = prevJob;
            end
        end
        
        function kpss = runThis(obj,data)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
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
                                kpss(i,j,:,1)=kpsstest(data(i).data(:,lsthbo(j)),'Lags',obj.lag,'Trend',obj.trend,'alpha',0.01);
                                % Varience of HbR signal
                                kpss(i,j,:,2)=kpsstest(data(i).data(:,lsthbr(j)),'Lags',obj.lag,'Trend',obj.trend,'alpha',0.01); 
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
            for k=1:length(obj.lag)
                figure
                subplot(2,1,1)
                bar(sum(squeeze(kpss(:,:,k,1)),2));
                for i=1:size(sum(squeeze(kpss(:,:,k,1)),2),1)
                    h=text(i,0,data(i).description(obj.filenamedigit1:obj.filenamedigit2));
                    set(h,'Rotation',90)
                end
                
                subplot(2,1,2)
                bar(sum(squeeze(kpss(:,:,k,2)),2));
                for i=1:size(sum(squeeze(kpss(:,:,k,2)),2),1)
                    h=text(i,0,data(i).description(obj.filenamedigit1:obj.filenamedigit2));
                    set(h,'Rotation',90)
                end
            end
            
        end
    end
end

