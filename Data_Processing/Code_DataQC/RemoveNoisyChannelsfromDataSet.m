filedir=uigetdir();
file=nirs.io.loadDirectory(filedir,{'Subject'});

% Source Detector
channeltoberemoved=[6 7;14 23];
% Individual source or detector index
sourcetoberemoved=[6 14];
detectortoberemoved=[9 10 11 12 25 26 27 28];

for i=1:length(file)
    clearvars -except file i channeltoberemoved sourcetoberemoved detectortoberemoved
    load(file(i).description,'-mat');
    
%     SD.SrcPos(sourcetoberemoved,:)=[];
%     SD.DetPos(detectortoberemoved,:)=[];
%     SD.nSrcs=SD.nSrcs-length(sourcetoberemoved);
%     SD.nDets=SD.nDets-length(detectortoberemoved);
%     
    [indtoremove,~]=find(SD.MeasList(:,2)==detectortoberemoved);
    
    for j=1:size(channeltoberemoved,1)
        indtoremove=[indtoremove;find(SD.MeasList(:,1)==channeltoberemoved(j,1)&SD.MeasList(:,2)==channeltoberemoved(j,2))];
    end
    
    SD.MeasList(indtoremove,:)=[];
    SD.MeasListMask(indtoremove)=[];
    SD.MeasList_USBorder(indtoremove)=[];
    SD.MeasListAct(indtoremove)=[];
    
    ml=SD.MeasList;
    d(:,indtoremove)=[];
    
    save(file(i).description,'aux','d','s','t','SD','ml','systemInfo','dStd');
    disp(['save file' file(i).description '...']);
end
