function RemoveNoisyChannel(Srclist, Detlist)

filedir=uigetdir();
file=nirs.io.loadDirectory(filedir,{'Subject'});

for i=1:length(file)
    clearvars -except file i channeltoberemoved sourcetoberemoved detectortoberemoved Srclist Detlist
    load(file(i).description,'-mat');
    
    [indtoremove,~]=find(ismember(SD.MeasList(:,1), Srclist)&ismember(SD.MeasList(:,2), Detlist));
    
    SD.MeasList(indtoremove,:)=[];
    SD.MeasListMask(indtoremove)=[];
    SD.MeasList_USBorder(indtoremove)=[];
    SD.MeasListAct(indtoremove)=[];
    
    ml=SD.MeasList;
    d(:,indtoremove)=[];
    
    try
        save(file(i).description,'aux','d','s','t','SD','ml','systemInfo');
    catch
        save(file(i).description,'d','s','t','SD','ml','systemInfo');
        disp('aux variable missing...')
    end
    
    disp(['save file' file(i).description '...']);
    
end

end
