function ChannelLabel(Coord,channellist,CHLabel)
% This function plot a yellow line between certain emitter and detector
% label them with predefined label variable
% indicated by an matrix. 
% Created by Xiaosu Hu Apr 7 2019
if length(CHLabel)~=length(channellist)
    warning('Channel Labelling has a problem.');
end

shifter=10;
% shifter3D=[20 0 0];
for i=1:size(channellist,1)
   line([Coord(channellist(i,1),1)-shifter Coord(channellist(i,2),1)-shifter],...
       [Coord(channellist(i,1),2)  Coord(channellist(i,2),2)],...
       [Coord(channellist(i,1),3)  Coord(channellist(i,2),3)],'LineWidth',5,'Color',[1 .65 0])
   hold on
   textlabelposition=(Coord(channellist(i,1),:)+Coord(channellist(i,2),:))/2;
   text(textlabelposition(1)-shifter,textlabelposition(2),textlabelposition(3),CHLabel(i,:),'FontSize',18);
end

end

