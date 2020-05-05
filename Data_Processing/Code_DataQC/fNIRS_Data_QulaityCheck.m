%% Gain setting
gain=0;

if gain
    datadir=uigetdir();
    GainAdjustmentforCW6(datadir)
end

%% Data loading and preprocessing
datadir=uigetdir();
rawdata=nirs.io.loadDirectory(datadir,{'Subject'});

filenamedigit1=83;
filenamedigit2=95;
count=1;
for i=1:length(rawdata)-1
    disp(rawdata(i).description(filenamedigit1:filenamedigit2))
    subjectid{count,1}=rawdata(i).description(filenamedigit1:filenamedigit2);
    count=count+1;
end

p1=nirs.modules.OpticalDensity();
p2=nirs.modules.BeerLambertLaw(p1);
Hb=p2.run(rawdata);

p3=nirs.modules.Resample();
p3.Fs=2;
Hbdown=p3.run(Hb);
px=nirs.modules.Resample();
px.Fs=8;
Hbdown8hz=px.run(Hb);

%% Data QC process
p4=nirs.dataqualitycontrol.Anti_Corr_Check();
p4.channelofinterest=1:10;
p4.filenamedigit1=filenamedigit1;
p4.filenamedigit2=filenamedigit2;
anticorr=p4.run(Hbdown);
AnticorrCH1_CH10=mean(anticorr(:,1:10),2);

p5=nirs.dataqualitycontrol.Cardiac_Spectrum_Check();
p5.channelofinterest=[1 3];
p5.checkoption=2;
p5.filenamedigit1=filenamedigit1;
p5.filenamedigit2=filenamedigit2;
p5.run(Hbdown8hz);

p6=nirs.dataqualitycontrol.VarianceCheck();
p6.filenamedigit1=filenamedigit1;
p6.filenamedigit2=filenamedigit2;
OverallVariance=p6.run(Hbdown);
VarianceCH1_CH10(:,1)=mean(OverallVariance(:,1:10,1),2);
VarianceCH1_CH10(:,2)=mean(OverallVariance(:,1:10,2),2);

% p7=nirs.dataqualitycontrol.TemporalDerivativesCheck();
% p7.filenamedigit1=filenamedigit1;
% p7.filenamedigit2=filenamedigit2;
% p7.channelofinterest=1:2;
% TmpDriviate=p7.run(Hbdown(1:2:end-1));

p8=nirs.dataqualitycontrol.SNRCheck();
p8.filenamedigit1=filenamedigit1;
p8.filenamedigit2=filenamedigit2;
p8.channelofinterest=[1 2];
SNR=p8.run(Hbdown);
SNR_CH1_CH10(:,1)=mean(SNR(:,1:10,1),2);
SNR_CH1_CH10(:,2)=mean(SNR(:,1:10,2),2);

% p9=nirs.dataqualitycontrol.StationaryCheck();
% p9.filenamedigit1=filenamedigit1;
% p9.filenamedigit2=filenamedigit2;
% p9.lag=[10 20 50 100]';
% p9.run(Hbdown(1:2:end-1));

p10=nirs.dataqualitycontrol.MotionArtifactCheck();
p10.filenamedigit1=filenamedigit1;
p10.filenamedigit2=filenamedigit2;
p10.absvariance=50;
motionpercent=p10.run(Hbdown);
motionpercentHbO=mean(motionpercent(:,:,1),2);
motionpercentHbR=mean(motionpercent(:,:,2),2);

%% Put every pattern in a table and then export to an excel file
QCtable=table(subjectid,SNR_CH1_CH10,motionpercentHbO,motionpercentHbR,AnticorrCH1_CH10,VarianceCH1_CH10);
writetable(QCtable,'QCtable.xlsx','sheet','Average');

SNRHbO=SNR(:,:,1);
SNRHbR=SNR(:,:,2);
SNRtable=table(subjectid,SNRHbO,SNRHbR);
writetable(SNRtable,'QCtable.xlsx','sheet','SNR');

VarianceHbO=OverallVariance(:,:,1);
VarianceHbR=OverallVariance(:,:,2);
Variancetable=table(subjectid,VarianceHbO,VarianceHbR);
writetable(Variancetable,'QCtable.xlsx','sheet','Variance');

Anticorrtable=table(subjectid,anticorr);
writetable(Anticorrtable,'QCtable.xlsx','sheet','Anti-Correlation');

motionHbO=motionpercent(:,:,1);
motionHbR=motionpercent(:,:,2);
motiontable=table(subjectid,motionHbO,motionHbR);
writetable(motiontable,'QCtable.xlsx','sheet','motionartifact');



