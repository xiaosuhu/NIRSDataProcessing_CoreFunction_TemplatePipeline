function Plot3D_channel_registration_result(intensity, MNIcoord, MNIcoordstd,mx,mn,colorscheme,brain_vol)
% This function will plot the channel posistions on an 3D brain template
% Modified by Xiaosu Hu May 1 2019
if nargin<5
    load('MNI152_downsampled.mat');
    [vertices,faces]=removeisolatednode(vertices,faces);
    colorscheme=jet;
    mx = round(max(intensity))+.5;
    mn = round(min(intensity))-.5;
elseif nargin==5
    load('MNI152_downsampled.mat');
    [vertices,faces]=removeisolatednode(vertices,faces);
    colorscheme=jet;
elseif nargin==6
    load('MNI152_downsampled.mat');
    [vertices,faces]=removeisolatednode(vertices,faces);
else 
    vertices=brain_vol.vertices;
    faces=brain_vol.faces;
end

% create a figure with black backgroud
% figure1=figure('Color',[0 0 0]);
% Translate the origin of MNI coord to the template coord
% orig=[96.5 114.5 96.5];

% If the max/min intensity exceed the mx/mn value coming in, then reassign
% it
for i=1:length(intensity)
    if intensity(i)>mx
        intensity(i)=mx;
    elseif intensity(i)<mn
        intensity(i)=mn;
    end
end

x_translate=96.5;
y_translate=114.5+5;
z_translate=96.5;

MNIcoord=MNIcoord+repmat([x_translate y_translate z_translate],size(MNIcoord,1),1);

% Assign the intensity value to the different layers of the plot
intensity_0 = intensity;

% intensity_0(intensity_0<0)=0;

scale1=.9;
scale2=.8;
scale3=.7;
scale4=.6;

intensity_1 = intensity_0*scale1;
intensity_2 = intensity_0*scale2;
intensity_3 = intensity_0*scale3;
intensity_4 = intensity_0*scale4;

intensity_optode=ones(8,1)*1;

tmp = colorscheme; % using ?hot? color scheme

tmp_optode = autumn;

intensity_0 = round((intensity_0 - mn)/(mx - mn) * 63 + 1);
intensity_1 = round((intensity_1 - mn*scale1)/(mx*scale1 - mn*scale1) * 63 + 1);
intensity_2 = round((intensity_2 - mn*scale2)/(mx*scale2 - mn*scale2) * 63 + 1);
intensity_3 = round((intensity_3 - mn*scale3)/(mx*scale3 - mn*scale3) * 63 + 1);
intensity_4 = round((intensity_4 - mn*scale4)/(mx*scale4 - mn*scale4) * 63 + 1);

intensity_optode = round((intensity_optode - mn)/(mx - mn) * 63 + 1);

colors_0 = tmp(intensity_0,:);
colors_1 = tmp(intensity_1,:);
colors_2 = tmp(intensity_2,:);
colors_3 = tmp(intensity_3,:);
colors_4 = tmp(intensity_4,:);

colors_optode = tmp_optode(intensity_optode,:);

distanceThreshold_0 = MNIcoordstd*0.4;
distanceThreshold_1 = MNIcoordstd*0.6;
distanceThreshold_2 = MNIcoordstd*0.8;
distanceThreshold_3 = MNIcoordstd*0.9;
distanceThreshold_4 = MNIcoordstd;
%%%%%%%%%%%%% Minor adjustment to the points
surf0.faces=faces;
surf0.vertices=vertices;
mode='center';
MNIcoord=pullPtsToSurf(MNIcoord,surf0,mode);
%%%%%%%%%%%%%
p=patch('faces',faces,'vertices',vertices, 'facecolor', 'flat',  'edgecolor', 'none', 'facealpha', 1);

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
if isempty(intensity) == 0
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
else % for empty intensity, plot an empty brain 
    for ii=1:size(faces,1)  
            facecolor_estimate(ii,:)=[.8 .8 .8];
    end
end


set(p,'FaceVertexCData',facecolor_estimate,'facealpha', 1);


daspect([.7 .7 .7])
view(3); axis tight
view([50 -40 100])

axis off;

set(gcf, 'InvertHardCopy', 'off');


view([90 90]);
camlight('headlight','infinite');
lighting gouraud
material dull;
% 
% view([90 0]);
% camlight('headlight','infinite');
% 
% view([-90 0])
% camlight('headlight','infinite');


view([-90 0])
colormap(colorscheme)
caxis([mn mx]);
colorbar
end

