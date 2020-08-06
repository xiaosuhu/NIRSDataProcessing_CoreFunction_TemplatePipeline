%% fNIRS Data Analyses - Bilingual Litercy Project
%% Morphosyntax Grammaticality Judgement Task
% Script 3 of 4
%
% Neelima Wagley
%
% Modified: 08/07/18
%
% Updated by Xiaosu Hu Feb 11 2019
%% GLM Second (group) Level Analyses

% Data Analyses Pipile as listed below using Huppert et al NIRS Toolbox and
% inidividualized scripts created by Frank Hu.

% 4. Group Level (2nd) GLM (mixed effects)
% 5. Group Contrasts & Statistics
% 6. ANOVA
% 7. Export Data
%
%Demographics Behavioral Correlation
Demo = nirs.modules.AddDemographics();
Demo.demoTable = readtable('/Users/marksre/Desktop/DemograpicsENMAPA.xlsx');
Demo.varToMatch='subject';
SubjStats = Demo.run(SubjStats);

%% Initialize GLM group level analyses (mixed effects)
% Initalize GLM
grouplevelpipeline = nirs.modules.MixedEffects();
% grouplevelpipeline.robust=true;
grouplevelpipeline.include_diagnostics=true; % Include diagnostics in the output

%% Run GML with SEPARATE conditions and NO REGRESSORS. Only TASK (conditions) vs. REST

grouplevelpipeline.formula ='beta ~ -1 + Session:cond + (1|Subject)';
GroupStats = grouplevelpipeline.run(SubjStats);

GroupStats.draw('tstat',[-4 4]);

%% Extract the group Level diagnostics and export it into excel file
GroupLevelDiagnostic=GroupStats.variables.model{1,1};
save('GroupLevelDiagnostic.mat','GroupLevelDiagnostic');
% Plot the relevant numbers
figure
subplot(1,2,1)
hist(GroupLevelDiagnostic.Residuals.Studentized);
title('Group-Level Distribution of Residuals')
subplot(1,2,2)
imagesc(GroupLevelDiagnostic.CoefficientCovariance)
colorbar
title('Group-Level Coef Covariance');