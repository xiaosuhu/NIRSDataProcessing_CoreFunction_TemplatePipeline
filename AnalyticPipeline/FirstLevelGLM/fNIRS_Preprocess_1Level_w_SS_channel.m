%% Read in Data
% clear all
% load('Data/Data_Gain_Stimark.mat')

datafolder='F:\MatlabBackUp\PROJECT_HH_R01\HHdata_story';
% datafolder='/Volumes/Franknano/MatlabBackUp/PROJECT_DyslexiaR01/HHData_Cleaned';
raw = nirs.io.loadDirectory(datafolder,{'Group','Subject'});
%% adjust the word freq
tom_model = xlsread('F:\MatlabBackUp\PROJECT_HH_R01\TOM_modeling_behavior\HH_ToM_modeling.csv');
% tom_model = xlsread('/Volumes/Franknano/MatlabBackUp/PROJECT_HH_R01/TOM_modeling_behavior/HH_ToM_modeling.csv');
tom_model = fillmissing(tom_model, 'constant', 0);

cond1 = tom_model(find(tom_model(:,2)==1), 1);
cond2 = tom_model(find(tom_model(:,3)==1), 1);
% cond3 = tom_model(find(tom_model(:,4)==1), 1);
% cond4 = tom_model(find(tom_model(:,5)==1), 1);
% cond5 = tom_model(find(tom_model(:,6)==1), 1);

% Concatenate the arrays
% cond6 = [cond1; cond2; cond3; cond4; cond5];
cond3 = [cond1; cond2];

% Sort the concatenated array
% cond6 = sort(cond6);
% cond6_id = sort([find(tom_model(:,2)==1); find(tom_model(:,3)==1); find(tom_model(:,4)==1);  find(tom_model(:,5)==1); find(tom_model(:,6)==1)]);
% cond6_value = tom_model(cond6_id, 7)./10;

cond3 = sort(cond3);
cond3_id = sort([find(tom_model(:,2)==1); find(tom_model(:,3)==1)]);
cond3_value = tom_model(cond3_id, 7)./10;

for i = 1:length(raw)
    raw(i).stimulus.values{1, 3}.amp = raw(i).stimulus.values{1, 3}.amp .* cond3_value(1:length(raw(i).stimulus.values{1, 3}.amp));
end

%% Preprocessing
% label short separation channels 
j_ss = nirs.modules.LabelShortSeperation();
raw = j_ss.run(raw);

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

% save('Data_Gain_Stimark_Recode_Preprocess.mat','hb_trim','-v7.3','-nocompression')

%% FIRST LEVEL MODELING
% clear all
% load('Data_Gain_Stimark_Recode_Preprocess.mat')

disp('Now running subject-level GLM!')
firstlevelglm=nirs.modules.GLM();

firstlevelglm.type = 'AR-IRLS';
firstlevelglm.AddShortSepRegressors = true; % SS channel set up

firstlevelbasis = nirs.design.basis.Canonical();
% Adding temporal & dispersion derivatives to canonical HRF function, DCT matrix to account for signal drift over time
firstlevelbasis.incDeriv=0;
% firstlevelglm.trend_func=@(t) nirs.design.trend.dctmtx(t,0.008);
% HRF peak time = 6s based on Friederici and Booth papers (e.g. Brauer, Neumann & Friederici, 2008, NeuroImage)
firstlevelbasis.peakTime = 6;

firstlevelglm.basis('default') = firstlevelbasis;
disp('Peak time set at 6s')

% Run
SubjStats=firstlevelglm.run(hb_trim);
disp('Ready to save SubjStats...')

save('SubjStats.mat','SubjStats','-v7.3','-nocompression')
disp('Done!')

%% Add Age & Gender
% restoredefaultpath
% Grouping = readtable('../LangLit_Behave.csv');

Demo1 = nirs.modules.AddDemographics();
Demo1.demoTable = readtable('F:\MatlabBackUp\PROJECT_HH_R01\TOM_modeling_behavior/LangLit Data 2023.xlsx','Sheet', 'Behavioral');
% Demo.demoTable = Grouping;
Demo1.varToMatch='Subject';
SubjStats = Demo1.run(SubjStats);


Demo2 = nirs.modules.AddDemographics();
Demo2.demoTable = readtable('F:\MatlabBackUp\PROJECT_HH_R01\TOM_modeling_behavior/LangLit Data 2023.xlsx','Sheet', 'CSUS & ChildAnthropomorphism');
% Demo.demoTable = Grouping;
Demo2.varToMatch='Subject';
SubjStats = Demo2.run(SubjStats);
