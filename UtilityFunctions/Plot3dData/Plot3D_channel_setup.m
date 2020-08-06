function Plot3D_channel_setup(MNIcoord,ChannelList,displaycolorswitch)
% PLOT3D_CHANNEL_SETUP Summary of this function goes here
% This function plot the 3D channel setup without brain activation

load('MNI152_downsampled.mat');
[vertices,faces]=removeisolatednode(vertices,faces);

p=patch('faces',faces,'vertices',vertices, 'facecolor', [.9 .9 .9],  'edgecolor', 'none', 'facealpha', .8);
hold on
h2=scatter3(MNIcoord(1:displaycolorswitch,1),MNIcoord(1:displaycolorswitch,2),MNIcoord(1:displaycolorswitch,3),500,'reds','Linewidth',2,'MarkerFaceColor',[1 0 0]);
hold on
h3=scatter3(MNIcoord(displaycolorswitch+1:length(MNIcoord),1),MNIcoord(displaycolorswitch+1:length(MNIcoord),2),MNIcoord(displaycolorswitch+1:length(MNIcoord),3),500,'blueo','Linewidth',2,'MarkerFaceColor',[0 0 1]);
hold on

SrcCoord=MNIcoord(1:displaycolorswitch,:);
DetCoord=MNIcoord(displaycolorswitch+1:end,:);

for i=1:size(ChannelList,1)
    CHLabel{i}=strcat('CH',num2str(i));
end
ChannelLabel(SrcCoord,DetCoord,ChannelList,CHLabel)

set(gca, 'visible', 'off')
light
view(-90,0)
camlight
lighting phong;
set(gca,'DataAspectRatio',[1 1 1],'PlotBoxAspectRatio',[1 1 1]);

end

