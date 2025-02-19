function dif_fileread( filename,order,ishalf,filetowrite,adjacent_thresh)
%DIF_FILEREAD Summary of this function goes here
%   Detailed explanation goes here
refpts_num=5;

if nargin <3
    ishalf = 0;
end

load(filename,'ascii');

digpts=eval([filename(1:end-4),'(:,1:3)*10']);

count=1;
for i=2:length(digpts)
    if digpts(i,1)-digpts(i-1,1)<adjacent_thresh&& digpts(i,2)-digpts(i-1,2)<adjacent_thresh&& digpts(i,3)-digpts(i-1,3)<adjacent_thresh
        index(count)=i;
        count=count+1;
    end
end

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

