function Plot3D_channel_registration_result_withLabel(intensity, MNIcoord, MNIcoordstd, MNIcoordstd_probe,numberofsource, brain_vol)
% This function will plot the channel posistions on an 3D brain template
if nargin<6
    load('MNI152_downsampled.mat');
    [vertices,faces]=removeisolatednode(vertices,faces);
else
    vertices=brain_vol.vertices;
    faces=brain_vol.faces;
    [vertices,faces]=removeisolatednode(vertices,faces);
end

% create a figure with black backgroud
% figure1=figure('Color',[0 0 0]);
% Translate the origin of MNI coord to the template coord
x_translate=96.5;
y_translate=114.5+5;
z_translate=96.5-10;


MNIcoord=MNIcoord+repmat([x_translate y_translate z_translate],size(MNIcoord,1),1);

% Assign the intensity value to the different layers of the plot
intensity_0 = intensity;
intensity_0(intensity_0<0)=0;

intensity_1 = intensity_0*0.7;
intensity_2 = intensity_0*0.5;
intensity_3 = intensity_0*0.3;
intensity_4 = intensity_0*0.1;

intensity_optode=ones(8,1)*1;

tmp = hot; % using ?hot? color scheme
mx = round(max(intensity_0))+.5;
mn = 0;

tmp_optode = hot;

intensity_0 = round((intensity_0 - mn)/(mx - mn) * 63 + 1);
intensity_1 = round((intensity_1 - mn)/(mx - mn) * 63 + 1);
intensity_2 = round((intensity_2 - mn)/(mx - mn) * 63 + 1);
intensity_3 = round((intensity_3 - mn)/(mx - mn) * 63 + 1);
intensity_4 = round((intensity_4 - mn)/(mx - mn) * 63 + 1);

intensity_optode = round((intensity_optode - mn)/(mx - mn) * 63 + 1);

colors_0 = tmp(intensity_0,:);
colors_1 = tmp(intensity_1,:);
colors_2 = tmp(intensity_2,:);
colors_3 = tmp(intensity_3,:);
colors_4 = tmp(intensity_4,:);

colors_optode = tmp_optode(intensity_optode,:);

distanceThreshold_0 = MNIcoordstd*0.1;
distanceThreshold_1 = MNIcoordstd*0.25;
distanceThreshold_2 = MNIcoordstd*0.5;
distanceThreshold_3 = MNIcoordstd*0.75;
distanceThreshold_4 = MNIcoordstd;
%%%%%%%%%%%%% Minor adjustment to the points
surf0.faces=faces;
surf0.vertices=vertices;
mode='center';
MNIcoord=pullPtsToSurf(MNIcoord,surf0,mode);
%%%%%%%%%%%%%
p=patch('faces',faces,'vertices',vertices, 'facecolor', 'flat',  'edgecolor', 'none', 'facealpha', .5);

pos_0 = [];
pos_1 = [];
pos_2 = [];
pos_3 = [];
pos_4 = [];

posf_0 = [];
posf_1 = [];
posf_2 = [];
posf_3 = [];
posf_4 = [];

pos_optode = [];
posf_combine=[];

posf_combine_0=[];
posf_combine_1=[];
posf_combine_2=[];
posf_combine_3=[];
posf_combine_4=[];


for ii=1:size(MNIcoord, 1)
    
    %  Square Rendering
    %  tmp = find(abs(vertices(:,1) - xyz(ii, 1)) <= distanceThreshold & abs(vertices(:,2) - xyz(ii, 2)) <= distanceThreshold & abs(vertices(:,3) - xyz(ii, 3)) <= distanceThreshold  );
    
    % Circle Rendering
    tmp0= find((vertices(:,1) - MNIcoord(ii, 1)).^2+(vertices(:,2) - MNIcoord(ii, 2)).^2+(vertices(:,3) - MNIcoord(ii, 3)).^2 <= distanceThreshold_0(ii)^2 );
    tmp1= find((vertices(:,1) - MNIcoord(ii, 1)).^2+(vertices(:,2) - MNIcoord(ii, 2)).^2+(vertices(:,3) - MNIcoord(ii, 3)).^2 <= distanceThreshold_1(ii)^2 );
    tmp2= find((vertices(:,1) - MNIcoord(ii, 1)).^2+(vertices(:,2) - MNIcoord(ii, 2)).^2+(vertices(:,3) - MNIcoord(ii, 3)).^2 <= distanceThreshold_2(ii)^2 );
    tmp3= find((vertices(:,1) - MNIcoord(ii, 1)).^2+(vertices(:,2) - MNIcoord(ii, 2)).^2+(vertices(:,3) - MNIcoord(ii, 3)).^2 <= distanceThreshold_3(ii)^2 );
    tmp4= find((vertices(:,1) - MNIcoord(ii, 1)).^2+(vertices(:,2) - MNIcoord(ii, 2)).^2+(vertices(:,3) - MNIcoord(ii, 3)).^2 <= distanceThreshold_4(ii)^2 );
    
    
    pos_0 = tmp0;
    pos_1 = setdiff(tmp1,tmp0);
    pos_2 = setdiff(tmp2,tmp1);
    pos_3 = setdiff(tmp3,tmp2);
    pos_4 = setdiff(tmp4,tmp3);
    
    posf_0 = find(sum(ismember(faces, pos_0),2)>0);
    posf_1 = find(sum(ismember(faces, pos_1),2)>0);
    posf_2 = find(sum(ismember(faces, pos_2),2)>0);
    posf_3 = find(sum(ismember(faces, pos_3),2)>0);
    posf_4 = find(sum(ismember(faces, pos_4),2)>0);
    %     facecolor(posf_1,:) = repmat(colors_1(ii,:), length(posf_1), 1);
    
    %     facecolor_sum=facecolor_sum+facecolor;
    posf_0=[posf_0 ones(size(posf_0,1),1)*ii zeros(size(posf_0,1),1)];
    posf_1=[posf_1 ones(size(posf_1,1),1)*ii ones(size(posf_1,1),1)];
    posf_2=[posf_2 ones(size(posf_2,1),1)*ii ones(size(posf_2,1),1)*2];
    posf_3=[posf_3 ones(size(posf_3,1),1)*ii ones(size(posf_3,1),1)*3];
    posf_4=[posf_4 ones(size(posf_4,1),1)*ii ones(size(posf_4,1),1)*4];
    
    
    
    posf_combine_0=[posf_combine_0;posf_0];
    posf_combine_1=[posf_combine_1;posf_1];
    posf_combine_2=[posf_combine_2;posf_2];
    posf_combine_3=[posf_combine_3;posf_3];
    posf_combine_4=[posf_combine_4;posf_4];
    
    
    posf_combine=[posf_combine_0; posf_combine_1; posf_combine_2; posf_combine_3; posf_combine_4];
    
end

facecolor_estimate=zeros(size(faces));
color_area=[0 0 0];

for ii=1:size(faces,1)
    areaindex=find(ii==posf_combine(:,1));
    areacount=size(areaindex,1);
    
    if isempty(areaindex)
        facecolor_estimate(ii,:)=[.8 .8 .8];
    else
        for jj=1:areacount
            eval(['color_area=color_area+colors_',num2str(posf_combine(areaindex(jj),3)),'(posf_combine(areaindex(jj),2),:);'])
        end
        facecolor_estimate(ii,:)=color_area/areacount;
        color_area=[0 0 0];
    end
    fprintf('One voxel complete!\n')
end





set(p,'FaceVertexCData',facecolor_estimate);
hold on
%% Plot the probes
[xx,yy,zz] = sphere;
r=3;
c1=[1 0 0];
c2=[0 0 1];



tmpcoord = squeeze(MNIcoordstd_probe);
for j=1:length(tmpcoord)
    if j<numberofsource+1
        sSurface=surf(xx*r+tmpcoord(j,1)+x_translate,yy*r+tmpcoord(j,2)+y_translate,zz*r+tmpcoord(j,3)+z_translate,'edgecolor','none');
        set(sSurface,'FaceColor',c1,'FaceAlpha',0.5);
    else
        dSurface =surf(xx*r+tmpcoord(j,1)+x_translate,yy*r+tmpcoord(j,2)+y_translate,zz*r+tmpcoord(j,3)+z_translate,'edgecolor','none');
        set(dSurface,'FaceColor',c2,'FaceAlpha',0.5);
    end
    hold on
end

%%


daspect([.7 .7 .7])
view(3); axis tight
view([50 -40 100])

axis off;

set(gcf, 'InvertHardCopy', 'off');


view([90 90]);
camlight('headlight','infinite');
lighting gouraud
material dull;

view([-90 0])

end

%
%
%
%     %Color bar
%     figure1=figure('Color',[0 0 0]);
%     % intense=[0 0 0 0.87 0 0 0.62 0   0 4.97 0 2.93 0 6.36 0.91 5.29];
%     % intense = [0 5.81 6.23 0 2.25 1.01 0 0.81  0 0 4.57 0 4.88 0 0 0];
%
%     intense = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
%
%     caxis([0 10]);
%     colormap hot;
%     colorbar('FontSize',48) ;
%
%     axis off
%
%
