function plot3Dbrain_Ver2021(intensity,onlypositive,p,coordfile)

coord=load(coordfile,'-mat'); % Load Coordinates - now need to specify names stroing the data
fieldname=fields(coord);
CHMNI=eval(['coord.',fieldname{1}]);

mx=max(intensity)+1;
mn=min(intensity)-1;

% remove the negative intensity associated ind
if onlypositive
    negind=find(intensity<=0);
else
    negind=[];
end

insigind=find(p>.05);

if ~isempty(negind)
    try
        rind=unique([negind; insigind]);
    catch
        rind=unique([negind insigind]);
    end
else
    rind=insigind;
end

intensity(rind)=[];
CHMNI(rind,:)=[];

CHMNIcoordstd=10*ones(length(CHMNI),1);

Plot3D_channel_registration_result_Ver2021(intensity, CHMNI, CHMNIcoordstd,mx,mn);

%% Plot 3D data into a video
%OptionZ.FrameRate=15;OptionZ.Duration=5.5;OptionZ.Periodic=true;
%CaptureFigVid([-20,10;-110,10;-190,80;-290,10;-380,10], 'FirstFiveStimDiff',OptionZ)

end