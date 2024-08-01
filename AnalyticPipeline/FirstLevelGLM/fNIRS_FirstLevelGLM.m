%% fNIRS Data Analyses - Bilingual Litercy Project 
%% Morphosyntax Grammaticality Judgement Task
% Script 2 of 4
% 
% Neelima Wagley
% 
% Modified: 08/07/18
% 
% Xiaosu Hu
% 
% Modified:Apr.29.2019
%% Preprocessing & GLM First (individual) Level Analyses

% Data Analyses Pipile as listed below using Huppert et al NIRS Toolbox and
% inidividualized scripts created by Frank Hu.

% 2. Preprocessing
%    - Resample data at lower frequency
%    - ADD MORE DETAILS HERE
% 3. Subject (1st) Level GLM
%% Add path to NIRS toolbox (Huppert et al.)
% Insert hyperlink to NIRS Toolbox here. 
%%
% toolboxdir=uigetdir();
% addpath(genpath(toolboxdir));
%% Define data directory and load raw rataset
%%
clear
datadir =uigetdir();
% Gain adjustment
% GainAdjustmentforCW6(datadir)
%load Data
raw = nirs.io.loadDirectory(datadir, {'Subject'});

%% Check the data quality
% digit1=77;
% digit2=97;
% chinterest=1;
% CWTCardiacBaselineShiftCheck(raw,chinterest,digit1,digit2);

%% Check HbO HbR Correlation
% hbohbrcorr=HbOHbRCorrCheck(raw);

%% Mark stimuli onsets for analyses 
%%
% OPTIONAL: CAN SHIFT TIMECOURSE ONSET OF STIMS

onset_shift = 0; %duration of onset time SHIFT (sec)
dur = 8; %duration of trial (sec)

for i=1:length(raw)
    for j=1:length(raw(i).stimulus.keys)
        raw(i).stimulus.values{j}.onset=raw(i).stimulus.values{j}.onset + repmat(onset_shift,size(raw(i).stimulus.values{j}.onset,1),1);
        raw(i).stimulus.values{j}.dur=repmat(dur,size(raw(i).stimulus.values{j}.dur,1),1);
    end
end
%% ADD CODE HERE TO PLOT RAW SIGNAL 
%% Initialize GLM (Subject-Level) 

firstlevelpipeline = nirs.modules.default_modules.single_subject;
List = nirs.modules.pipelineToList(firstlevelpipeline); % Applies job

% Downsample Data from 50Hz to N Hz
List{4}.Fs = 2;

List{8}.preBaseline=5;
List{8}.postBaseline=5;

% GLM Basis Function
firstlevelbasis = nirs.design.basis.Canonical();
firstlevelbasis.incDeriv=0;

% Hemodynamic Response Peak Time
firstlevelbasis.peakTime = 6; % peak time determined based on Friederici and Booth papers (insert link)
List{9}.basis('default') = firstlevelbasis;
List{9}.trend_func = @(t) nirs.design.trend.dctmtx(t,0.005);

% Convert the modified list back to pipeline
firstlevelpipeline = nirs.modules.listToPipeline(List);
%% Complete First Level Pre-Processing & GLM
%%
% Run Job
firstlevelpipeline.run(raw);
%% Initialize GLM group level analyses (mixed effects)
% Initalize GLM
grouplevelpipeline = nirs.modules.MixedEffects();

% Run GML with SEPARATE conditions and NO REGRESSORS. Only TASK (conditions) vs. REST

grouplevelpipeline.formula ='beta ~ -1 + cond + (1|Subject)';
GroupStats = grouplevelpipeline.run(SubjStats);

GroupStats.draw('tstat',[-4 4],'p<.05');

c=[1 -0.5 -0.5];
Contrast = GroupStats.ttest(c);
