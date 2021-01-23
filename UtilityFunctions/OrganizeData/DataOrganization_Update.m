%% fNIRS Raw Data Organization Functions
% Script 1 of 4
% 
% Neelima Wagley
% 
% Modified: 08/22/18
% 
% Jan 30, 2019, Xiaosu Hu
% 
% Modified: Feb 6 2019 Xiaosu Hu
%% Data Organization 

% Data Analyses Pipile as listed below using Huppert et al NIRS Toolbox and
% inidividualized scripts created by Frank Hu. 

% 1. Organize Dataset 
%  - Load data 
%  - Ordering triggers/stimuli
%  - ADD MORE DETAILS HERE 
%% Add path to NIRS toolbox (Huppert et al.)
% Insert hyperlink to NIRS Toolbox here.

toolboxpath=uigetdir();
addpath(genpath(toolboxpath));
scriptpath=uigetdir();
addpath(genpath(scriptpath));
%% Organize raw fNIRS files 
% ADD CODE HERE TO:
%% 
% # Load participant IDs and NIRS files 
% # Select only the ones to be included in the analyses
% # Create directory with working dataset to be used in the analyses
%% *Covert the "Aux" variable to "s"*

% [file,filepath] = uigetfile('*.*','Multiselect','on');
% cd(filepath);
% stimdur=.18;
% DataOrganization_auxtos(filepath,stimdur);

%% *Covert the "Aux" variable to "s"* with data in folder
stimdur=.2;
DataOrganization_auxtos_Separatefolder(stimdur);

%% Copy files into sequential subject folders *out from sequential subject folders*

% Move file in
[file,filedir] = uigetfile('*.*','Multiselect','on');
cd(filedir);
filestartnum=1;% Subject folder starting number 
iostatus='in';
DataOrganization_MoveInOut(file,filedir,iostatus,filestartnum);

% Move file out
filedir=uigetdir();
cd(filedir);
iostatus='out';
DataOrganization_MoveInOut([],filedir,iostatus,[]);
