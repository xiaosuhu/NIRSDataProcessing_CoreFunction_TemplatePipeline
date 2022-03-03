function plot3Dbrain(intensity,onlypositive,p)

load('MNIcoordBilateral46_Adjusted_HLR01.mat'); % Load Coordinates - Updated coordinates on Aug 2020
    % MNIcoordUnilateral23_AUG2020: Left hemisphere, removed channels 7 & 8 
    % Localization fixed August 2020, all coordinates shifted down slightly
mx=4;
mn=-4;

% remove the negative intensity associated ind
if onlypositive
    negind=find(intensity<=0);
else
    negind=[];
end

insigind=find(p>=0.05);


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

MNIcoordstd=10*ones(length(CHMNI));

Plot3D_channel_registration_result(intensity, CHMNI, MNIcoordstd,mx,mn);

camlight('headlight','infinite');
lighting gouraud
material dull;
end