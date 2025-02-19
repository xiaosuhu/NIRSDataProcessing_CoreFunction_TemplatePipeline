function [BA_result_sort, Brain_Region_result_sort]=BAfinding_ALLCH_withplot(digpts_mni,radius,orig)
% Radius is a set of radius and there should be radius for each channel
%% Created by Xiaosu Hu 
% Upadated March 31 2019, by Xiaosu Hu
load TDdatabase.mat;
load MNI152_downsampled.mat
surf.vertices=vertices;
surf.faces=faces;

ch=size(digpts_mni,1);

for i=1:ch
    
    xlist = []; % ???????
    ylist = [];
    zlist = [];
    cnt = 0;
    while cnt < 10000 %# of dots
        x = (rand()-.5)*2*radius(i)+digpts_mni(i,1);%
        y = (rand()-.5)*2*radius(i)+digpts_mni(i,2);
        z = (rand()-.5)*2*radius(i)+digpts_mni(i,3);
        if (x-digpts_mni(i,1))^2 + (y-digpts_mni(i,2))^2 + (z-digpts_mni(i,3))^2 <= radius(i)^2 % Radius
            cnt = cnt + 1;
            xlist(cnt) = x;
            ylist(cnt) = y;
            zlist(cnt) = z;
        end
    end
    
    mni_montecarlo{i}=[xlist' ylist' zlist'];
    [BA_infocombined,BA{i}]=StructureFinding(mni_montecarlo{i}, DB, orig);
    
    mni_montecarlo{i}=mni_montecarlo{i}+repmat(orig,size(mni_montecarlo{i},1),1);
end

% plot the dot with brain template
figure
h1=patch('faces',surf.faces,'vertices',surf.vertices,'Facecolor',[.9 .9 .9],'EdgeColor','none','Facealpha',.7);
hold on
for i=1:length(mni_montecarlo)
    scatter3(mni_montecarlo{i}(:,1),mni_montecarlo{i}(:,2),mni_montecarlo{i}(:,3),5,'blueo','Linewidth',5);
    hold on
end

set(gca, 'visible', 'off')
light
view(-90,0)
camlight
lighting phong;
set(gca,'DataAspectRatio',[1 1 1],'PlotBoxAspectRatio',[1 1 1]);

%% dot count for Broadman Area

for i=1:ch
    for j=1:length(BA{i})
        try
            BA_update(j,i)=str2num(BA{i}{j,5}(15:end));
            
        catch
            BA_update(j,i)=0;
        end
    end
end

for i=1:ch
    tmp=BA_update(:,i);
    tmp(tmp==0)=[];
    BA_results{i}=tabulate(tmp(:,1));
    try
        BA_results{i}((BA_results{i}(:,2))==0,:)=[];
    catch
        BA_results{i}=[0,10000,100];
    end
end

% A result sort process
for i=1:ch
    [BA_result_sort{i}(:,3),I]=sort(BA_results{i}(:,3),'descend');
    BA_result_sort{i}(:,2)=BA_results{i}(I,2);
    BA_result_sort{i}(:,1)=BA_results{i}(I,1);
end

%% dot count for brain regions, but remove the undefined brain regions
for i=1:ch
    tmp_brain_region=[];
    tmp_dot_count=[];
    tmp_dot_total=0;
    tmp_brain_region=unique(BA{i}(:,3),'stable');
    for j=1:length(tmp_brain_region)
        if strcmp(tmp_brain_region{j},'undefined')
           tmp_brain_region(j)=[]; 
           break
        end
    end
    tmp_dot_count=cellfun(@(x) sum(ismember(BA{i}(:,3),x)),tmp_brain_region,'un',0);
    tmp_dot_total=sum([tmp_dot_count{:}]);
    for k=1:size(tmp_dot_count)
        try
            tmp_dot_count{k}=tmp_dot_count{k}/tmp_dot_total;
        catch
            tmp_dot_count{k}=0;
            warning('Counting went wrong...');
        end
    end
    Brain_Region_result_sort{i}(:,1)=tmp_brain_region;
    Brain_Region_result_sort{i}(:,2)=tmp_dot_count;
end
%% Ploting process II pie chart, temporally disabled
% figure('color',[1 1 1]);
%
% green = [.2 .8 .4];
% red = [1 .8 .6];
% blue = [.4 .8 1];
% yellow = [1 .4 .8];
% for i=1:ch
%     subplot(3,ceil(ch/3),i)
%
%     switch size(BA_results{i},1)
%
%         case 1
%             p=pie(BA_results{i}(:,3)/100,{strcat('BA ',num2str(BA_results{i}(1,1)))});
%             title(strcat('CH',num2str(i)),'FontSize',18);
%             set(p(1),'FaceColor',green)
%             set(p(2),'FontSize',18)
%
%         case 2
%             p=pie(BA_results{i}(:,3)'/100,{strcat('BA ',num2str(BA_results{i}(1,1))),strcat('BA ',num2str(BA_results{i}(2,1)))});
%             title(strcat('CH',num2str(i)),'FontSize',18);
%             set(p(1),'FaceColor',green)
%             set(p(2),'FontSize',18)
%             set(p(3),'FaceColor',red)
%             set(p(4),'FontSize',18)
%         case 3
%             p=pie(BA_results{i}(:,3)'/100,{ strcat('BA ',num2str(BA_results{i}(1,1))),strcat('BA ',num2str(BA_results{i}(2,1))),strcat('BA ',num2str(BA_results{i}(3,1)))});
%             title(strcat('CH',num2str(i)),'FontSize',18);
%             set(p(1),'FaceColor',green)
%             set(p(2),'FontSize',18)
%             set(p(3),'FaceColor',red)
%             set(p(4),'FontSize',18)
%             set(p(5),'FaceColor',blue)
%             set(p(6),'FontSize',18)
%
%         case 4
%             p=pie(BA_results{i}(:,3)'/100,{strcat('BA ',num2str(BA_results{i}(1,1))),strcat('BA ',num2str(BA_results{i}(2,1))),strcat('BA ',num2str(BA_results{i}(3,1))),strcat('BA ',num2str(BA_results{i}(4,1)))});
%             title(strcat('CH',num2str(i)),'FontSize',18);
%              set(p(1),'FaceColor',green)
%             set(p(2),'FontSize',18)
%             set(p(3),'FaceColor',red)
%             set(p(4),'FontSize',18)
%             set(p(5),'FaceColor',blue)
%             set(p(6),'FontSize',18)
%             set(p(7),'FaceColor',yellow)
%             set(p(8),'FontSize',18)
%         case 5
%             p=pie(BA_results{i}(:,3)'/100,{strcat('BA ',num2str(BA_results{i}(1,1))),strcat('BA ',num2str(BA_results{i}(2,1))),strcat('BA ',num2str(BA_results{i}(3,1))),strcat('BA ',num2str(BA_results{i}(4,1))),strcat('BA ',num2str(BA_results{i}(5,1)))});
%             title(strcat('CH',num2str(i)),'FontSize',18);
%              set(p(1),'FaceColor',green)
%             set(p(2),'FontSize',18)
%             set(p(3),'FaceColor',red)
%             set(p(4),'FontSize',18)
%             set(p(5),'FaceColor',blue)
%             set(p(6),'FontSize',18)
%             set(p(7),'FaceColor',yellow)
%             set(p(8),'FontSize',18)
%              set(p(9),'FaceColor','cyan')
%             set(p(10),'FontSize',18)
%         case 6
%             p=pie(BA_results{i}(:,3)'/100,{strcat('BA ',num2str(BA_results{i}(1,1))),strcat('BA ',num2str(BA_results{i}(2,1))),strcat('BA ',num2str(BA_results{i}(3,1))),strcat('BA ',num2str(BA_results{i}(4,1))),strcat('BA ',num2str(BA_results{i}(5,1))),strcat('BA ',num2str(BA_results{i}(6,1)))});
%             title(strcat('CH',num2str(i)),'FontSize',18);
%             set(p(1),'FaceColor',green)
%             set(p(2),'FontSize',18)
%             set(p(3),'FaceColor',red)
%             set(p(4),'FontSize',18)
%             set(p(5),'FaceColor',blue)
%             set(p(6),'FontSize',18)
%             set(p(7),'FaceColor',yellow)
%             set(p(8),'FontSize',18)
%              set(p(9),'FaceColor','cyan')
%             set(p(10),'FontSize',18)
%             set(p(11),'FaceColor','magenta')
%             set(p(12),'FontSize',18)
%
%     end
end

