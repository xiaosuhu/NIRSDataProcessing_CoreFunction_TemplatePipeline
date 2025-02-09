function Plot3D_Connectivity(intensity,pair,MNIcoord,color_bar,cmin,cmax)
% This function plots the connection as lines on a 3D brain template

if nargin<4
    cmin=min(intensity)-1;
    cmax=max(intensity)+1;
    color_bar=1;
end

load('MNI152_downsampled.mat');
% [vertices,faces]=removeisolatednode(vertices,faces);

x_translate=96.5;
y_translate=114.5+5;
z_translate=96.5-10;

MNIcoord=MNIcoord+repmat([x_translate y_translate z_translate],size(MNIcoord,1),1);
p=patch('faces',faces,'vertices',vertices, 'facecolor', [.8 .8 .8],  'edgecolor', 'none', 'facealpha', .2);
hold on

colcount=200;
scalemin=cmin;
scalemax=cmax;
colscale=jet(colcount);

for i=1:size(pair,1)
    intcol=(intensity(i)-scalemin)/(scalemax-scalemin);
    col=round(intcol*colcount);
    line([MNIcoord(pair(i,1),1) MNIcoord(pair(i,2),1)],...
        [MNIcoord(pair(i,1),2) MNIcoord(pair(i,2),2)],...
        [MNIcoord(pair(i,1),3) MNIcoord(pair(i,2),3)],'Color',colscale(col,:),'LineWidth',3);
    hold on
end

plot3(MNIcoord(:,1),MNIcoord(:,2),MNIcoord(:,3),'.','MarkerSize',50,...
    'MarkerEdgeColor','k');
hold on

% for i=1:length(MNIcoord)
%     text(MNIcoord(i,1),MNIcoord(i,2),MNIcoord(i,3)+10,num2str(i),'FontSize',24);
%     hold on
% end

if color_bar
    colormap(colscale(1:200,:));
    caxis([cmin cmax]);
    colorbar('Ticks',[cmin,cmax]);
end

daspect([.8 .8 .8])
view(3); axis tight
view([50 -40 100])

axis off;
set(gcf, 'InvertHardCopy', 'off');

end

