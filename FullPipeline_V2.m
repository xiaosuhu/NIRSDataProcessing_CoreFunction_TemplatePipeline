%% Define data directory and load raw datasets
%% ADD PATH TO TOOLBOX & SCRIPTS: /Volumes/kovelman/0_fNIRS_analyses_scripts/HLR01 data analysis 2020/Current Student Friendly R01 Code/
addpath(genpath('/Volumes/kovelman/0_fNIRS_analyses_scripts/HLR01 data analysis 2020/Current Student Friendly R01 Code/ '));
addpath(genpath('/Volumes/kovelman/0_fNIRS_analyses_scripts/HLR01 data analysis 2020/Frank_Code_Updated/ '));

%% ADD PATHS TO DATA - MAY NEED TO EDIT PATH BELOW:
datadir = '/Users/marksre/Desktop/DEMO/';
addpath(genpath(datadir));
%% Update final folder of your output directory:
outputdir = (fullfile(datadir,'/DataQC'))
addpath(genpath(outputdir));

%% Load data
disp('Loading in .nirs data files...')
raw = nirs.io.loadDirectory(datadir, {'Subject','Task'});
disp('All .nirs files loaded!')
disp('-----------------------')

%% Adjust gain (only necessary for first time processing .nirs files, then  adjustment is saved)
GainAdjustmentforCW6(datadir)

%% First Level Data Processing
disp('Running data resample...')
resample=nirs.modules.Resample();
resample.Fs=2;
downraw=resample.run(raw);

disp('Converting Optical Density...')
odconv=nirs.modules.OpticalDensity();
od=odconv.run(downraw);

disp('Applying  Modified Beer Lambert Law...')
mbll=nirs.modules.BeerLambertLaw();
hb=mbll.run(od);

disp('Trimming .nirs files...')
trim=nirs.modules.TrimBaseline();
trim.preBaseline=5;
trim.postBaseline=5;
hb_trim=trim.run(hb);

disp('Processing complete!')
disp('-----------------------')

%%%%%%%%%%%%%%%%%%%%%%
% VISUAL CHECK OF .NIRS FILES
%%%%%%%%%%%%%%%%%%%%%%
figure
for i=1:2:length(hb_trim)
    subplot(3,2,ceil(i/2));
    plot(hb_trim(i).time,hb_trim(i).data(:,1));
    hold on
    title(num2str(i));
    plot(hb_trim(i+1).time,hb_trim(i+1).data(:,1));
end

%%%%%%%%%%%%%%%%%%%%%%
% EXAMPLE QC
%%%%%%%%%%%%%%%%%%%%%%
%You will need to edit digit # below:
filenamedigit1=38;
filenamedigit2=46;

%% Generate images of HbO-HbR anticorrelation
p4=nirs.dataqualitycontrol.Anti_Corr_Check();
p4.channelofinterest=1:10;
p4.filenamedigit1=filenamedigit1;
p4.filenamedigit2=filenamedigit2;
anticorr=p4.run(hb_trim(1:end));
Anticorr_Channels1to10=mean(anticorr(:,1:10),2);
% saveas(gcf,[fullfile(outputdir),'/AntiCorr', '.png']);
%
% %% Generate graph of signal-to-noise ratio (SNR) for HbO and HbR
p7=nirs.dataqualitycontrol.SNRCheck();
p7.filenamedigit1=filenamedigit1;
p7.filenamedigit2=filenamedigit2;
p7.channelofinterest=[1 2];
SNR=p7.run(hb_trim(1:end));
SNR_Channels1to10(:,1)=mean(SNR(:,1:10,1),2);
SNR_Channels1to10(:,2)=mean(SNR(:,1:10,2),2);
%saveas(gcf,[fullfile(outputdir),'/SNR', '.png']);

%%%%%%%%%%%%%%%%%%%%%%%
%% FIRST LEVEL MODELING
%%%%%%%%%%%%%%%%%%%%%%%%
disp('Now running subject-level GLM!')
firstlevelglm=nirs.modules.AR_IRLS();
firstlevelbasis = nirs.design.basis.Canonical();
disp('Initial GLM complete')

% Adding temporal & dispersion derivatives to canonical HRF function, DCT matrix to account for signal drift over time
firstlevelbasis.incDeriv=1;
firstlevelglm.trend_func=@(t) nirs.design.trend.dctmtx(t,0.08);
disp('Added DCT matrix + 2 derivatives')

% HRF peak time = 6s based on Friederici and Booth papers (e.g. Brauer, Neumann & Friederici, 2008, NeuroImage)
firstlevelbasis.peakTime = 6;
firstlevelglm.basis('default') = firstlevelbasis;
disp('Peak time set at 6s')

SubjStats=firstlevelglm.run(hb_trim);
disp('Ready to save SubjStats...')

save('SubjStats')
disp('Done!')



% Generate individual subject plots (LH + RH)
% To generate, highlight from here to the very end of script (including plotting functions) and run
channelremove=0;
filenamedigit1=38;
filenamedigit2=46;
for i=1:length(SubjStats)
    figure
    for side=1:2
        
        c1=[1 0 0 1 0 0 1 0 0];
        intensity1=getintensity(c1,SubjStats(i));
        
        % Plot the 3D image
        onlypositive=1;
        
        subplot(1,2,side)
        plot(intensity1,onlypositive,channelremove,side);
        title(SubjStats(i).description(filenamedigit1:filenamedigit2));
        
    end
    % SPECIFICY CORRECT OUTPUT FILE TO SAVE SUBJECT LEVEL IMAGES:
    saveas(gcf,[fullfile(outputdir),'/FirstLevel_',num2str(i),'.png']);
    close
end


%%%%%%%%%%%%%%%%%%%%%%%
%% GROUP LEVEL MODELING
% %%%%%%%%%%%%%%%%%%%%%%%

%% Demographics Behavioral Correlation
Demo = nirs.modules.AddDemographics();
Demo.demoTable = readtable('/Users/marksre/Desktop/DEMO/data/BehavioralData.xlsx');
Demo.varToMatch='Subject';
SubjStats = Demo.run(SubjStats);

%% Initialize general linear mixed effects model
grouplevelpipeline = nirs.modules.MixedEffects();

%% Run GLM with SEPARATE conditions and NO REGRESSORS. Only TASK (conditions) vs. REST
% Interaction between task and condition (compare two tasks in one model)
disp('Running GroupStats1 GLM')
grouplevelpipeline.formula ='beta ~ -1 + Task:cond + (1|Subject)';
GroupStats1 = grouplevelpipeline.run(SubjStats);
disp('GroupStats done!')

%%%%%%%%%%%%%%%%%%%%%%%
%% VISUALIZE GROUP-LEVEL RESULTS
%%%%%%%%%%%%%%%%%%%%%%%%

channelremove=0;
% Morphological Word Processing (controlling for temp/disp derivatives)
c5=[1 0 0   1 0 0   0 0 0   0 0 0   0 0 0   0 0 0];
intensity5=getintensity(c5,GroupStats1);
intensity5(intensity5<0)=0;
% MA > PA
c2=[1 0 0   1 0 0   0 0 0   -1 0 0   -1 0 0   0 0 0];
intensity2=getintensity(c2,GroupStats1);
intensity2(intensity2<0)=0;
% Phonological Word Processing
c3=[0 0 0   0 0 0   0 0 0   1 0 0   1 0 0   0 0 0];
intensity3=getintensity(c3,GroupStats1);
intensity3(intensity3<0)=0;
% PA > MA
c4=[-1 0 0   -1 0 0   0 0 0   1 0 0   1 0 0   0 0 0];
intensity4=getintensity(c4,GroupStats1);
intensity4(intensity4<0)=0;
%
% Plot the 3D image
onlypositive=0;
channelremove=0;
side=1;

figure
subplot(2,2,1);
plot(intensity5, onlypositive, channelremove, side)
title('MA Easy + Hard')
subplot(2,2,3);
plot(intensity2, onlypositive, channelremove, side)
title('EN MA > EN PA')
subplot(2,2,2);
plot(intensity3, onlypositive, channelremove, side)
title('PA Easy + Hard')
subplot(2,2,4);
plot(intensity4, onlypositive, channelremove, side)
title('EN PA > EN MA')


%% Functions
% Functions
function intensity = getintensity(c,GroupStats)
Contrast=GroupStats.ttest(c);
Contrasttable=Contrast.table;
intensity=Contrasttable.tstat(strcmp(Contrasttable.type,'hbo')&ismember(Contrasttable.source,[1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16]));
end

function plot(intensity,onlypositive,channelremove,side)

if size(intensity,1)==54
    load MNIcoordV4BilateralCH_Twonewsource.mat % Load Coordinates
    MNIcoordNEW=MNIcoordV4Bilateral;
elseif size(intensity,1)==46
    load MNIcoordBilateralCH_Nonewsource.mat
    MNIcoordNEW=MNIcoord;
end


mx=4;
mn=-4;

%% BILATERAL
% remove the negative intensity associated ind
if onlypositive
    negind=find(intensity<=0);
    intensity(negind)=[];
    MNIcoordNEW(negind,:)=[];
end

MNIcoordstd=10*ones(length(MNIcoordNEW),1);

Plot3D_channel_registration_result(intensity, MNIcoordNEW, MNIcoordstd,mx,mn);

if side ==1
    view(-90,0)
    camlight('headlight','infinite');
    lighting gouraud
    material dull;
elseif side==2
    view(90,0)
    camlight('headlight','infinite');
    lighting gouraud
    material dull;
end
end