% fNIRS Data Analyses - Bilingual Litercy Project 
% Morphosyntax Grammaticality Judgement Task
% Script 2 of 4
% Neelima Wagley
% Modified: 08/07/18
% Xiaosu Hu
% Modified:1.19.2019
% Preprocessing & GLM First (individual) Level Analyses
% Data Analyses Pipile as listed below using Huppert et al NIRS Toolbox and
% inidividualized scripts created by Frank Hu. 

% 2. Preprocessing 
%    - Resample data at lower frequency
%    - ADD MORE DETAILS HERE
% 3. Subject (1st) Level GLM

% Add path to NIRS toolbox (Huppert et al.)
% Insert hyperlink to NIRS Toolbox here. 
toolboxdir=uigetdir();
addpath(genpath(toolboxdir));

% Define data directory and load raw rataset
datadir =uigetdir();
raw = nirs.io.loadDirectory(datadir, {'subject'});

% Mark stimuli onsets for analyses 
% OPTIONAL: CAN SHIFT TIMECOURSE ONSET OF STIMS

onset_shift = 0; %duration of onset time SHIFT (sec)
dur = 6; %duration of trial (sec)    

for i=1:length(raw)
    for j=1:length(raw(i).stimulus.keys)
        raw(i).stimulus.values{j}.onset=raw(i).stimulus.values{j}.onset + repmat(onset_shift,size(raw(i).stimulus.values{j}.onset,1),1);
        raw(i).stimulus.values{j}.dur=repmat(dur,size(raw(i).stimulus.values{j}.dur,1),1);
    end
end

% ADD CODE HERE TO PLOT RAW SIGNAL 
% 
% Initialize GLM (Subject-Level) 
% "Job" deifnes the pipeline of pre-processing the data.
% "Job" deifnes the pipeline of pre-processing the data.
% Job "List" consists of: 
% 1. Import Data
% 2. Remove Stims (what are the parameters here)
% 3. Resample (50 Hz to 5Hz)
% 4. Optical Density
% 5. Apply Beer Lambert Law
% 6. Export Data 
% 7. Trim Baseline (how is baseline determined?)
% 8. GLM
% 9. Export Data 

% Downsample Data from 50Hz to N Hz
downsample=nirs.modules.Resample();
downsample.Fs=2;
raw=downsample.run(raw);

trim=nirs.modules.TrimBaseline();
trim.preBaseline=5;
trim.postBaseline=5;
raw=trim.run(raw);

OD=nirs.modules.OpticalDensity();
OD=OD.run(raw);
MBLL=nirs.modules.BeerLambertLaw();
HB=MBLL.run(OD);
HbTconvert=nirs.modules.CalculateTotalHb();
HBT=HbTconvert.run(HB);

% GLM Basis Function
firstlevelbasis = nirs.design.basis.Canonical();
% firstlevelbasis.incDeriv=1;

% Hemodynamic Response Peak Time
firstlevelbasis.peakTime = 6; % peak time determined based on Friederici and Booth papers (insert link) 
firstlevel=nirs.modules.AR_IRLS();

firstlevel.basis('default') = firstlevelbasis;
% List{9}.trend_func = @(t) nirs.design.trend.dctmtx(t,0.01);

% Run Job
SubjStats=firstlevel.run(HBT);

% Check the Individual Activation Map
% Contrast vector
c=[1 1 -2];

% Do contrast for everyone in the group
for i=1:length(SubjStats)
   ContrastStats = SubjStats(i).ttest(c);
   ContrastStats.draw;
end
