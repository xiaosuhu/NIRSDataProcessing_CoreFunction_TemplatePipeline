function Plot3D_channel_withLabel(MNIcoord)
% PLOT3D_CHANNEL_SETUP Summary of this function goes here
% This function plot the 3D channel location without brain activation
% By Xiaosu Hu 20220429

x_translate=96.5;
y_translate=114.5+5;
z_translate=96.5-10;

MNIcoord=MNIcoord+repmat([x_translate y_translate z_translate],size(MNIcoord,1),1);

load('MNI152_downsampled.mat');
[vertices,faces]=removeisolatednode(vertices,faces);

% figure; 

p=patch('faces',faces,'vertices',vertices, 'facecolor', [.9 .9 .9],  'edgecolor', 'none');
hold on;
shifter=10;
h2=scatter3(MNIcoord(1:end,1),MNIcoord(1:end,2),MNIcoord(1:end,3),100,'redd','Linewidth',2,'MarkerFaceColor',[1 0 0]);

for i=1:size(MNIcoord,1)
    CHLabel{i}=strcat('CH',num2str(i));
    text(MNIcoord(i,1),MNIcoord(i,2)+shifter*.5,MNIcoord(i,3)+shifter,CHLabel{i},'FontSize',12);
end

set(gca, 'visible', 'off')
light
view(-90,0)
camlight
lighting phong;
set(gca,'DataAspectRatio',[1 1 1],'PlotBoxAspectRatio',[1 1 1]);

end

