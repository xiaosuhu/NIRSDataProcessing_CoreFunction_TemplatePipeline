function gimmedataprepare(datadir,COI,hbohbr,option,downsamplerate)

%% GIMME script - January 2nd, 2019
% Adapted by Xiaosu Hu May 19 2020

% datadir = the directory containing the data you want to covert
% COI = the channel of interest
% hbohbr=hbohbr switch, 1= hbo, 2=hbr
% option = the way you want to get the data
%               1 - pick individual data points every n sec
%               2 - average data points within n sec
% downsamplerate= the sampling frequency you want for the GIMME analysis, 2
% is default
if nargin<3
    hbohbr=1;
    option=1;
    downsamplerate=2;
elseif nargin<4
    option=1;
    downsamplerate=2;
elseif nargin<5
    downsmaplerate=2;
end

%% Load Data
raw = nirs.io.loadDirectory(datadir,{'subject'});

%%Processing, using Spline and OLS canonical response
j1=nirs.modules.OpticalDensity();
j2=nirs.modules.BeerLambertLaw();

% Extract a 3D data matrix
switch option
    case 1
        j3=nirs.modules.Resample();
        j3.Fs=downsamplerate;
        od=j1.run(raw);
        oddown=j3.run(od);
        hb=j2.run(oddown);
        
    case 2
        od=j1.run(raw);
        hb=j2.run(od);
        % Data downsample by averaging
        for i=1:length(hb)
            mergingperiod=1/downsamplerate*hb(i).Fs;
            tmpdatamat=hb(i).data;
            for j=1:size(tmpdatamat,2)
                for k=1:size(tmpdatamat,1)/mergingperiod
                    tmpdatamatdown(k,j)=mean(tmpdatamat((k-1)*mergingperiod+1:k*mergingperiod,j));
                end
            end
            hb(i).data=tmpdatamatdown;
        end
        
        % Implement the pipeline
end

% Extract data from GIMME
GIMMEdataExtract(hb,COI,hbohbr)

end
%% Extracts HbO data from 11 ROIs (left frontal and parietal) and saves them into text files
function GIMMEdataExtract(data,COI,hbohbr)

for i=1:length(data)
    clearvars R_data hboind hbrind;
    
    % find COI
    switch hbohbr
        case 1
            hboind=find(strcmp(data(i).probe.link.type,'hbo'));
            COImatch=hboind(COI);
        case 2
            hbrind=find(strcmp(data(i).probe.link.type,'hbr'));
            COImatch=hbrind(COI);
    end
    
    for j=1:length(COImatch)
        R_data(:,1)=data(i).data(:,COImatch(j));
    end
    
    save(strcat('GIMME_data',num2str(i),'.txt'),'R_data','-ascii','-tabs');
end

end