function BA_result_sort=BAfinding_SingleCH(digpts_MNI,radius)
%% This function uses Monte Carlo simulation to find the relevant brain 
% region covered by certain coordinate.
% Created by Xiaosu Hu, Oct 24, 2018
load TDdatabase.mat;

digpts_mni=digpts_MNI;

xlist = []; 
ylist = [];
zlist = [];
cnt = 0;

while cnt < 1000 %# of dots
    x = (rand()-.5)*2*sqrt(radius)+digpts_mni(1);%
    y = (rand()-.5)*2*sqrt(radius)+digpts_mni(2);
    z = (rand()-.5)*2*sqrt(radius)+digpts_mni(3);
    if (x-digpts_mni(1))^2 + (y-digpts_mni(2))^2 + (z-digpts_mni(3))^2 <= radius % Radius
        cnt = cnt + 1;
        xlist(cnt) = x;
        ylist(cnt) = y;
        zlist(cnt) = z;
    end

mni_xyz=[xlist' ylist' zlist'];

[BA_combined,BA]=StructureFinding(mni_xyz, DB);
disp(strcat('Dot',num2str(cnt),'...'));
end

% BA area conversion
for j=1:length(BA)
    try
        BA_update(j,1)=str2num(BA{j,5}(15:end));
        
    catch
        BA_update(j,1)=0;
    end
end

% Area count
tmp=BA_update;
tmp(tmp==0)=[];
BA_results=tabulate(tmp(:,1));
try
    BA_results((BA_results(:,2))==0,:)=[];
catch
    BA_results=[0,10000,100];
end


%% A result sort process
% The result will be in the format of BA area/order/# of points
[BA_result_sort(:,3),I]=sort(BA_results(:,3),'descend');
BA_result_sort(:,2)=BA_results(I,2);
BA_result_sort(:,1)=BA_results(I,1);

end

