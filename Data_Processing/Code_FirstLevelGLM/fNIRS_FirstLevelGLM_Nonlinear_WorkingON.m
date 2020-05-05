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
%load Data
raw = nirs.io.loadDirectory(datadir, {'Subject','Session'});

%% Initialize GLM (Subject-Level) 

odconv=nirs.modules.OpticalDensity();
mbll=nirs.modules.BeerLambertLaw(odconv);
resample=nirs.modules.Resample(mbll);
resample.Fs=2;
baselinetrim=nirs.modules.TrimBaseline(resample);
baselinetrim.preBaseline=5;
baselinetrim.postBaseline=5;

Hbdown=resample.run(raw);

% GLM Basis Function
firstlevelbasis = nirs.design.basis.nonlinearHRF();

% firstlevelbasis.incDeriv=1;
% firstlevelbasis.peakTime = 6; % peak time determined based on Friederici and Booth papers (insert link)

% GLM part specification
firstlevelglm=nirs.modules.nonlin_GLM();
firstlevelglm.basis('default') = firstlevelbasis;
firstlevelglm.trend_func = @(t) nirs.design.trend.dctmtx(t,0.005);
%% Complete First Level Pre-Processing & GLM
%%
% Run Job
SubjStats=firstlevelglm.run(Hbdown);
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