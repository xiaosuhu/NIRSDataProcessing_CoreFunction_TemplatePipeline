classdef MotionArtifactCheck< nirs.modules.AbstractModule
    %MOTIONARTIFACTCHECK Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        filenamedigit1=1;
        filenamedigit2=2;
        absvariance=30;
        channelofinterest=1;
    end
    
    methods
        function obj = MotionArtifactCheck(prevJob)
            obj.name = 'Motion Artifacts Check';
            
            if nargin > 0
                obj.prevJob = prevJob;
            end
        end
        function motionpercent = runThis(obj,data)
            for i=1:numel(data)
                motionmatrix{i}=zeros(size(data(i).data));
                for j=1:size(data(i).data,2)
                    tmpd=abs(diff(data(i).data(:,j)));
                    tmpstd=std(data(i).data(:,j));
                    for k=1:length(tmpd)
                        if tmpd(k)>tmpstd*3||tmpd(k)>obj.absvariance
                            motionmatrix{i}(k,j)=1;
                        end
                    end
                end
            end
            
            
            for i=1:numel(motionmatrix)
                counthbo=1;
                counthbr=1;
                for j=1:2:size(motionmatrix{i},2)-1
                    motionpercent(i,counthbo,1)=size(find(motionmatrix{i}(:,j)==1),1)/size(motionmatrix{i},1); % HbO
                    counthbo=counthbo+1;
                end
                
                for j=2:2:size(motionmatrix{i},2)
                    motionpercent(i,counthbr,2)=size(find(motionmatrix{i}(:,j)==1),1)/size(motionmatrix{i},1);% HbR
                    counthbr=counthbr+1;
                end
            end
            
            for i=1:numel(motionmatrix)
                if mod(i-1,16)==0
                    figure
                    count=1;
                end
                subplot(4,4,count);
                imagesc(motionmatrix{i});
                axis tight
                shading flat
                title(data(i).description(obj.filenamedigit1:obj.filenamedigit2));
                count=count+1;
            end
            
            for i=1:numel(motionmatrix)
                motionmatrixsum(i)=sum(sum(motionmatrix{i}));
                motionmatrixtotal(i)=size(motionmatrix{i},1)*size(motionmatrix{i},2);
            end
            
            figure
            bar(motionmatrixsum./motionmatrixtotal);
            for i=1:numel(motionmatrixsum)
                h=text(i,0,data(i).description(obj.filenamedigit1:obj.filenamedigit2));
                set(h,'Rotation',90)
            end
            
        end
    end
end

