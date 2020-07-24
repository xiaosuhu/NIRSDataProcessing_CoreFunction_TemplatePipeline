function ChannelLabel(SrcCoord,DetCoord,channellist,CHLabel)
% This function plot a yellow line between certain emitter and detector
% label them with predefined label variable
% indicated by an matrix. 
% Created by Xiaosu Hu Apr 7 2019
if length(CHLabel)~=length(channellist)
    warning('Channel Labelling has a problem.');
end

shifter=10;
for i=1:size(channellist,1)
   line([SrcCoord(channellist(i,1),1) DetCoord(channellist(i,2),1)],...
       [SrcCoord(channellist(i,1),2)  DetCoord(channellist(i,2),2)],...
       [SrcCoord(channellist(i,1),3)  DetCoord(channellist(i,2),3)],'LineWidth',5,'Color',[1 .65 0])
   hold on
   textlabelposition=(SrcCoord(channellist(i,1),:)+DetCoord(channellist(i,2),:))/2;
   text(textlabelposition(1),textlabelposition(2),textlabelposition(3),CHLabel{i},'FontSize',18);
end

end

