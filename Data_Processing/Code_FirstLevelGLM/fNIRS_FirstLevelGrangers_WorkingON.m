%% fNIRS Data Analyses 
%% Grangers Causality Analysis
% Xiaosu Hu
% 
% Modified:1.19.2019
%% Add path to NIRS toolbox (Huppert et al.)
% Insert hyperlink to NIRS Toolbox here. 

toolboxdir=uigetdir();
addpath(genpath(toolboxdir));
%% Define data directory and load raw rataset

datadir =uigetdir();
raw = nirs.io.loadDirectory(datadir, {'subject'});
%% Mark stimuli onsets for analyses 

% OPTIONAL: CAN SHIFT TIMECOURSE ONSET OF STIMS

onset_shift = 0; %duration of onset time SHIFT (sec)
dur = 4; %duration of trial (sec)    

for i=1:length(raw)
    for j=1:length(raw(i).stimulus.keys)
        raw(i).stimulus.values{j}.onset=raw(i).stimulus.values{j}.onset + repmat(onset_shift,size(raw(i).stimulus.values{j}.onset,1),1);
        raw(i).stimulus.values{j}.dur=repmat(dur,size(raw(i).stimulus.values{j}.dur,1),1);
    end
end
%% *Preprocessing of the data*

% Converting the data to optical density
jOD=nirs.modules.OpticalDensity();
OD=jOD.run(raw);
% Converting the data to Hemoglobin Concentration
jMBLL=nirs.modules.BeerLambertLaw();
Hb=jMBLL.run(OD);

% Downsample
jDown=nirs.modules.Resample();
jDown.Fs=2;
Hb_down=jDown.run(Hb);

% Control the before and after session time
jTrim=nirs.modules.TrimBaseline();
jTrim.preBaseline=5;
jTrim.postBaseline=5;
Hb_Trim=jTrim.run(Hb_down);
%% 
% Run Grangers function individual level

jGrangers=nirs.modules.Connectivity();
jGrangers.corrfcn=@(data)nirs.sFC.grangers(data,'5xFs','true');

jGrangers.run(Hb_Trim);