function CH_Region_table=CHtabulate(RegionEstimate,nV,mode)

% Mode = BA or Region

% Create channel labels
for i=1:length(RegionEstimate)
    CHname{i,1}=strcat('CH ',num2str(i));
end

switch mode
    case 'BA'
       for i=1:length(RegionEstimate)
           Region{i,1}=[];
           for j=1:size(RegionEstimate{i},1)
              if sum(RegionEstimate{i}(1:j,3))>nV
                 Region{i,1}=[Region{i,1} '|BA ' num2str(RegionEstimate{i}(j,1))]; 
                 break
              else
                 Region{i,1}=[Region{i,1} '|BA ' num2str(RegionEstimate{i}(j,1))];
              end
           end
       end
    case 'Region'
        for i=1:length(RegionEstimate)
           Region{i,1}=[];
           for j=1:size(RegionEstimate{i},1)
              if sum([RegionEstimate{i}{1:j,2}])>nV
                 Region{i,1}=[Region{i,1} '|' RegionEstimate{i}{j,1}]; 
                 break
              else
                 Region{i,1}=[Region{i,1} '|' RegionEstimate{i}{j,1}];
              end
           end
       end
end

CH_Region_table=table(CHname,Region,'VariableNames',{'Channel','Brain_Region'});
end