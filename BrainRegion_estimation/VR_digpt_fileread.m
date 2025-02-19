function VR_digpt_fileread(order,refpts,sourcepts,detectorpts,filetowrite,ishalf)
%DIF_FILEREAD Summary of this function goes here
%   Detailed explanation goes here
refpts_num=5;

if nargin <6
    ishalf = 0;
end

digpts=[];
% References
for i=1:size(refpts,2)
    digpts=[digpts; refpts(size(refpts,2)-i+1).Position];
end

% Sources
for i=1:size(sourcepts,2)
    digpts=[digpts; sourcepts(size(sourcepts,2)-i+1).Position];
end

%Detectors
for i=1:size(detectorpts,2)
    digpts=[digpts; detectorpts(size(detectorpts,2)-i+1).Position];
end

%Scaling
digpts=digpts*10;

if ishalf==1
    digpts=[digpts; -1*digpts(refpts_num+1:end,1) digpts(refpts_num+1:end,2:3)];
end

fid=fopen(filetowrite,'w');

for i=1:size(order,1)
    fprintf(fid,'%s:  ',order(i,:));
    fprintf(fid,'%g  ',digpts(i,1));
    fprintf(fid,'%g  ',digpts(i,2));
    fprintf(fid,'%g  \n',digpts(i,3));
    
end
fclose(fid);

end

