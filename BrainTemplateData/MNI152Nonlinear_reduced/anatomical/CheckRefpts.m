load('refpts.txt','ascii');

load('MNI152_downsampled.mat');
surf.vertices=vertices;
surf.faces=faces;

figure
set(gcf,'color',[1 1 1])
% subplot(1,2,1)
h1=patch('faces',surf.faces,'vertices',surf.vertices,'Facecolor',[.9 .9 .9],'EdgeColor','none','Facealpha',1);
hold on
h2=scatter3(refpts(:,1),refpts(:,2),refpts(:,3),500,'redo','Linewidth',2,'MarkerFaceColor',[1 0 0]);



set(gca, 'visible', 'off')
light
view(-90,0)
camlight
lighting phong;
set(gca,'DataAspectRatio',[1 1 1],'PlotBoxAspectRatio',[1 1 1]);