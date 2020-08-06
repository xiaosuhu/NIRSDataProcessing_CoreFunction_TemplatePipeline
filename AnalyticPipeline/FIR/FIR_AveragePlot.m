function DataMatrix = FIR_AveragePlot(SubjStats,pts_num,ch_num,individual_plot,Fs)
% This function further processes the first level FIR results
% 1) Plot the curves per condition
% 2) Average the curves and plot them
% Created Jan 30, 2019, Xiaosu Hu
for i =1:length(SubjStats)
    Table=SubjStats(i).table;
    index1=strcmp(SubjStats(i).table.type,'hbo')&strncmp(SubjStats(i).table.cond,'stim_channel1',length('stim_channel1'));
    index2=strcmp(SubjStats(i).table.type,'hbo')&strncmp(SubjStats(i).table.cond,'stim_channel2',length('stim_channel2'));
    index3=strcmp(SubjStats(i).table.type,'hbo')&strncmp(SubjStats(i).table.cond,'stim_channel3',length('stim_channel3'));
    index4=strcmp(SubjStats(i).table.type,'hbo')&strncmp(SubjStats(i).table.cond,'stim_channel4',length('stim_channel4'));
    
    HbO_cond1{i}=Table(index1,:);
    HbO_cond2{i}=Table(index2,:);
    HbO_cond3{i}=Table(index3,:);
    HbO_cond4{i}=Table(index4,:);
    
    if ~sum(index1)
        error('No conditions found!');
    elseif ~sum(index2)
        warning('Conditions 2-4 not found!');
        condnum=1;
    elseif ~sum(index3)
        warning('Conditions 3-4 not found!');
        condnum=2;
    elseif ~sum(index4)
        warning('Condition 4 not found!');
        condnum=3;
    else
        condnum=4;
    end
end

% Individual data plot process

t=1/Fs:1/Fs:pts_num/Fs;

if individual_plot
    for Subject=1:length(SubjStats)
%         figure('position',[1 1 1200 900])
        figure
        set(gcf,'name',SubjStats(Subject).description(end-17:end));
        
        for i=1:ch_num
            subplot(ceil(ch_num/7),7,i);
            plot(t,HbO_cond1{Subject}.beta(i:ch_num:ch_num*(pts_num-1)+i));
            hold on
            try
                plot(t,HbO_cond2{Subject}.beta(i:ch_num:ch_num*(pts_num-1)+i));
                hold on
                
            catch
            end
            
            try
                plot(t,HbO_cond3{Subject}.beta(i:ch_num:ch_num*(pts_num-1)+i));
                hold on
            catch
            end
            
            try
                plot(t,HbO_cond4{Subject}.beta(i:ch_num:ch_num*(pts_num-1)+i));
                hold on
                
            catch
            end
            switch condnum
                case 2
                    plot(t,(HbO_cond1{Subject}.beta(i:ch_num:ch_num*(pts_num-1)+i)+...
                        HbO_cond2{Subject}.beta(i:ch_num:ch_num*(pts_num-1)+i))/2,'black');
                    hold on
                    
                case 3
                    plot(t,(HbO_cond1{Subject}.beta(i:ch_num:ch_num*(pts_num-1)+i)+...
                        HbO_cond2{Subject}.beta(i:ch_num:ch_num*(pts_num-1)+i)+...
                        HbO_cond3{Subject}.beta(i:ch_num:ch_num*(pts_num-1)+i))/3,'black');
                    hold on
                    
                case 4
                    plot(t,(HbO_cond1{Subject}.beta(i:ch_num:ch_num*(pts_num-1)+i)+...
                        HbO_cond2{Subject}.beta(i:ch_num:ch_num*(pts_num-1)+i)+...
                        HbO_cond3{Subject}.beta(i:ch_num:ch_num*(pts_num-1)+i)+...
                        HbO_cond4{Subject}.beta(i:ch_num:ch_num*(pts_num-1)+i))/4,'black');
                    hold on
                    
            end
            
            %     ylim([-30 30]);
            title(strcat('CH',num2str(i)))
            xlabel('Time (pts)');
            ylabel('Magnitude (M^{-1})');
            %         axis([0 30 -10 10]);
        end
        
        switch condnum
            case 1
                legend('Cond1');
                
            case 2
                legend('Cond1','Cond2','Avg Cond');
                
            case 3
                legend('Cond1','Cond2','Cond3','Avg Cond');
                
            case 4
                legend('Cond1','Cond2','Cond3','Cond4','Avg Cond');
                
        end
        annotation('textbox',[.9 .9 .1 .1],'String',SubjStats(Subject).description(end-17:end));
        % Save the figure
        %         print(gcf,strcat('Subject',SubjStats(Subject).description(end-17:end),'.png'),'-dpng');
        %         close(gcf)
    end
end


% Extract the group level data

for Subject=1:length(HbO_cond1)
    for i=1:ch_num
        
        try
            DataMatrix.cond1(:,i,Subject)=HbO_cond1{Subject}.beta(i:ch_num:ch_num*(pts_num-1)+i);
        catch
        end
        try
            DataMatrix.cond2(:,i,Subject)=HbO_cond2{Subject}.beta(i:ch_num:ch_num*(pts_num-1)+i);
        catch
        end
        try
            DataMatrix.cond3(:,i,Subject)=HbO_cond3{Subject}.beta(i:ch_num:ch_num*(pts_num-1)+i);
        catch
        end
        try
            DataMatrix.cond4(:,i,Subject)=HbO_cond4{Subject}.beta(i:ch_num:ch_num*(pts_num-1)+i);
        catch
        end
    end
end

% Plot the group level data
try
    Cond1AVG=mean(DataMatrix.cond1,3);
    Cond2AVG=mean(DataMatrix.cond2,3);
    Cond3AVG=mean(DataMatrix.cond3,3);
    Cond4AVG=mean(DataMatrix.cond4,3);
catch
end

% Group level plot
% figure('position',[1 1 1200 900])
figure
set(gcf,'name','GroupLevelPlot');
for i=1:ch_num
    subplot(ceil(ch_num/7),7,i);
    try
        plot(Cond1AVG(:,i));
        hold on
        plot(Cond2AVG(:,i));
        hold on
        plot(Cond3AVG(:,i));
        hold on
        plot(Cond4AVG(:,i));
        hold on
    catch
    end
    switch condnum
        case 2
            plot((Cond1AVG(:,i)+Cond2AVG(:,i))/2,'black');
        case 3
            plot((Cond1AVG(:,i)+Cond2AVG(:,i)+Cond3AVG(:,i))/3,'black');
        case 4
            plot((Cond1AVG(:,i)+Cond2AVG(:,i)+Cond3AVG(:,i)+Cond4AVG(:,i))/4,'black');
    end
    title(strcat('CH',num2str(i)))
    xlabel('Time (s)');
    ylabel('Magnitude (M^{-1})');
end
switch condnum
    case 1
        legend('Cond1');
        
    case 2
        legend('Cond1','Cond2','Avg Cond');
        
    case 3
        legend('Cond1','Cond2','Cond3','Avg Cond');
        
    case 4
        legend('Cond1','Cond2','Cond3','Cond4','Avg Cond');
        
end

end

