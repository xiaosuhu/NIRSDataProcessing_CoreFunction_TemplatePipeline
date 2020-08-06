% Toolbox path loading
toolboxpath=uigetdir();
addpath(genpath(toolboxpath));

% Data loading process
datadir=uigetdir();
raw = nirs.io.loadDirectory(datadir, {'subject'});

% Create a pipeline that will do FIR work
job = nirs.modules.default_modules.single_subject;
List=nirs.modules.pipelineToList(job);
% Downsample part
List{4}.Fs=2;
List{8}.preBaseline=5;
List{8}.postBaseline=5;
% FIR specification
basis = nirs.design.basis.FIR;
basis.isIRF=false;
basis.binwidth=2;
basis.nbins=20;
List{9}.basis('default')=basis;

% Convert the modified list back to pipeline
job = nirs.modules.listToPipeline(List);

% Run job
job.run(raw);

% FIR curve ploting and averaging
pts_num=basis.nbins;
Fs=1;
ch_num=height(SubjStats(1).probe.link)/2;
individual_plot=0;
DataMatrix = FIR_AveragePlot(SubjStats,pts_num,ch_num,individual_plot,Fs);




