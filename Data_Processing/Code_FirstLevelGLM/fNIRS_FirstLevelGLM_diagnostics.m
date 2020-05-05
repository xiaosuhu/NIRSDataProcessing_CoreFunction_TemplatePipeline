%% fNIRS Data Analyses - Bilingual Litercy Project
%% Bilingual R01
%  This script should be used to begin fNIRS data processing (after
%  checking data quality!)
%  Script contains (1) preprocessing, (2) first level modeling, and
%  (3) first level diagnostic check
%  Check that you have added all the necessary paths!

%% Define data directory and load raw rataset
%%
clear
datadir =uigetdir();

rawdata = nirs.io.loadDirectory(datadir, {'Subject','Session'});
disp('All .nirs files loaded!')

filenamedigit1=44;
filenamedigit2=54;
count=1;
for i=1:2:length(rawdata)-1
    disp(rawdata(i).description(filenamedigit1:filenamedigit2))
    subjectid{count,1}=rawdata(i).description(filenamedigit1:filenamedigit2);
    count=count+1;
end

%% ADD CODE HERE TO PLOT RAW SIGNAL
%% Preprocessing for GLM (Subject-Level)
p1=nirs.modules.OpticalDensity();
disp('OD conversion done')
p2=nirs.modules.BeerLambertLaw(p1);
disp('MBLL done')
p3=nirs.modules.Resample(p2);
p3.Fs=2;
Hbdown=p3.run(rawdata(1:2:end-1));
disp('Downsample done')

p4=nirs.modules.TrimBaseline();
p4.preBaseline=5;
p4.postBaseline=5;
Hbdownt=p4.run(Hbdown);
disp('Files trimmed')

%% First visual check
% Visualize time series for 2 tasks on one plot
% NOTE: MAY NEED TO CHANGE DIMENSIONS OF SUBPLOT (length,height)
%
% figure
% for i=1:2:length(Hbdownt)
%     subplot(5,2,ceil(i/2));
%     plot(hb_trim(i).time,Hbdownt(i).data(:,1));
%     hold on
%     plot(hb_trim(i+1).time,Hbdownt(i+1).data(:,1));
% end
%
% % Check numerical order of subject files
% for i=1:length(Hbdownt)
%     disp(num2str(i))
%     disp(hb(i).description)
% end

%% Defining GLM (Subject-Level)
disp('Defining First Level analysis function')
% GLM Basis Function
firstlevelbasis = nirs.design.basis.Canonical();
firstlevelbasis.incDeriv=1;
% Hemodynamic Response Peak Time
firstlevelbasis.peakTime = 6; % peak time determined based on Friederici and Booth papers (insert link)

% Regular GLM
disp('...Setting function for model')
p5=nirs.modules.AR_IRLS();
p5.basis('default') = firstlevelbasis;
p5.trend_func = @(t) nirs.design.trend.dctmtx(t,0.005);

% Running Diagnostics
disp("...Setting function model's diagnostic check")
p6=nirs.dataqualitycontrol.AR_IRLS_Diagnostics();
p6.basis('default') = firstlevelbasis;
p6.trend_func = @(t) nirs.design.trend.dctmtx(t,0.005);

%% Running GLM
%%
% Run Job
% disp('Runing regular GLM')
% SubjStats=p5.run(Hbdownt);
disp('Ready for model diagnostic check')
diagnostic=p6.run(Hbdownt);

%% Output table into excel file
for i=1:numel(diagnostic)
    counthbo=1;
    counthbr=1;
    for j=1:2:numel(diagnostic{i})-1
        robust_s(i,counthbo,1)=diagnostic{i}{j}.robust_s;
        ols_s(i,counthbo,1)=diagnostic{i}{j}.ols_s;
        residmean(i,counthbo,1)=mean(diagnostic{i}{j}.resid);
        residstd(i,counthbo,1)=std(diagnostic{i}{j}.resid);
        w(i,counthbo,1)=mean(diagnostic{i}{j}.w);
        firstlevel_t1(i,counthbo,1)=diagnostic{i}{j}.t(1);
        firstlevel_t2(i,counthbo,1)=diagnostic{i}{j}.t(4);
        firstlevel_t3(i,counthbo,1)=diagnostic{i}{j}.t(7);
        counthbo=counthbo+1;
    end
    
    for j=2:2:numel(diagnostic{i})
        robust_s(i,counthbr,2)=diagnostic{i}{j}.robust_s;
        ols_s(i,counthbr,2)=diagnostic{i}{j}.ols_s;
        residmean(i,counthbr,2)=mean(diagnostic{i}{j}.resid);
        residstd(i,counthbr,2)=std(diagnostic{i}{j}.resid);
        w(i,counthbr,2)=mean(diagnostic{i}{j}.w);
        firstlevel_t1(i,counthbr,2)=diagnostic{i}{j}.t(1);
        firstlevel_t2(i,counthbr,2)=diagnostic{i}{j}.t(4);
        firstlevel_t3(i,counthbr,2)=diagnostic{i}{j}.t(7);
        counthbr=counthbr+1;
    end
end


robust_s_hbo=mean(robust_s(:,:,1),2);
robust_s_hbr=mean(robust_s(:,:,2),2);

ols_s_hbo=mean(ols_s(:,:,1),2);
ols_s_hbr=mean(ols_s(:,:,2),2);

residmean_hbo=mean(residmean(:,:,1),2);
residmean_hbr=mean(residmean(:,:,2),2);

residstd_hbo=sqrt(sum(residstd(:,:,1),2)/size(residstd,2));
residstd_hbr=sqrt(sum(residstd(:,:,2),2)/size(residstd,2));

w_hbo=mean(w(:,:,1),2);
w_hbr=mean(w(:,:,2),2);

firstlevel_t1_hbo=mean(firstlevel_t1(:,:,1),2);
firstlevel_t1_hbr=mean(firstlevel_t1(:,:,2),2);
firstlevel_t2_hbo=mean(firstlevel_t2(:,:,1),2);
firstlevel_t2_hbr=mean(firstlevel_t2(:,:,1),2);
firstlevel_t3_hbo=mean(firstlevel_t3(:,:,1),2);
firstlevel_t3_hbr=mean(firstlevel_t3(:,:,1),2);

FirstLevelFit=table(subjectid,robust_s_hbo,robust_s_hbr,ols_s_hbo,ols_s_hbr,residmean_hbo,residmean_hbr,...
    residstd_hbo,residstd_hbr,w_hbo,w_hbr,...
    firstlevel_t1_hbo,firstlevel_t1_hbr,firstlevel_t2_hbo,firstlevel_t2_hbr,firstlevel_t3_hbo,firstlevel_t3_hbr);

writetable(FirstLevelFit,'FirstLevelFit.xlsx','sheet','Average');

robuststable=table(subjectid,robust_s(:,:,1),robust_s(:,:,2));
writetable(robuststable,'FirstLevelFit.xlsx','sheet','robust_s');

olstable=table(subjectid,ols_s(:,:,1),ols_s(:,:,2));
writetable(olstable,'FirstLevelFit.xlsx','sheet','ols_s');

residualmeantable=table(subjectid,residmean(:,:,1),residmean(:,:,2));
writetable(residualmeantable,'FirstLevelFit.xlsx','sheet','residualmean');

residualstdtable=table(subjectid,residstd(:,:,1),residstd(:,:,2));
writetable(residualstdtable,'FirstLevelFit.xlsx','sheet','residualstd');

weighttable=table(subjectid,w(:,:,1),w(:,:,2));
writetable(weighttable,'FirstLevelFit.xlsx','sheet','robust_weights');

Ttable=table(subjectid,firstlevel_t1(:,:,1),firstlevel_t2(:,:,1),firstlevel_t3(:,:,1),...
    firstlevel_t1(:,:,2),firstlevel_t2(:,:,2),firstlevel_t3(:,:,2));
writetable(Ttable,'FirstLevelFit.xlsx','sheet','FirstLevelTvalues');

%% *Check the Individual Activation Map*
%%
% % Contrast vector
% c=[1 1 -2];
%
% % Do contrast for everyone in the group
% for i=1:length(SubjStats)
%     ContrastStats = SubjStats(i).ttest(c);
%     ContrastStats.draw;
% end
