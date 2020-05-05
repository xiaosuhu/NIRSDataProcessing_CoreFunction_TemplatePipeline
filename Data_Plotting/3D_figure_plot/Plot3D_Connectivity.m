function Plot3D_Connectivity(intensity,pair,MNIcoord)
% This function plots the connection as lines on a 3D brain template

load('MNI152_downsampled.mat');
[vertices,faces]=removeisolatednode(vertices,faces);

x_translate=100;
y_translate=140;
z_translate=80;

% MNIcoord=MNIcoord+repmat([x_translate y_translate z_translate],size(MNIcoord,1),1);
p=patch('faces',faces,'vertices',vertices, 'facecolor', [.8 .8 .8],  'edgecolor', 'none', 'facealpha', .2);
hold on

colcount=200;
scalemin=-1.01;
scalemax=1;
colscale=jet(colcount);

for i=1:length(pair)
    intcol=(intensity(i)-scalemin)/(scalemax-scalemin);
    col=round(intcol*colcount);
    line([MNIcoord(pair(i,1),1) MNIcoord(pair(i,2),1)],...
        [MNIcoord(pair(i,1),2) MNIcoord(pair(i,2),2)],...
        [MNIcoord(pair(i,1),3) MNIcoord(pair(i,2),3)],'Color',colscale(col,:),'LineWidth',2);
    hold on
end
colormap(colscale);
caxis([-1 1]);
colorbar('Ticks',[-1,0,1]);

daspect([.7 .7 .7])
view(3); axis tight
view([50 -40 100])

axis off;

set(gcf, 'InvertHardCopy', 'off');


view([0 90]);
% camlight('headlight','infinite');
% lighting gouraud
% material dull;

end

