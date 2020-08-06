function OptodeLabel(Coord,OLabel)
% This function label optode with predefined label
% indicated by an matrix.
% Created by Xiaosu Hu Apr 7 2019
if length(OLabel)~=length(Coord)
    warning('Channel Labelling has a problem.');
end

figure
h=scatter3(Coord(:,1),Coord(:,2),Coord(:,3),200,[1 0 0]);
h.MarkerFaceColor=[1 0 0];
hold on

% shifter3D=[20 0 0];
for i=1:size(Coord,1)
    %    textlabelposition=Coord(i,:)-shifter3D;
    textlabelposition=Coord(i,:);
    text(textlabelposition(1),textlabelposition(2),textlabelposition(3),OLabel(i,:),'FontSize',40);
    hold on
end


end

