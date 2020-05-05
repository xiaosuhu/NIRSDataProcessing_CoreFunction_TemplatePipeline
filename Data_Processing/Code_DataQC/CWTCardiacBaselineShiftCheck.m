function CWTCardiacBaselineShiftCheck(raw,chinterest,digit1,digit2)
% This function checks if the fNRIS signal file contains the cardiac band
% information, and baseline shift in preselected channel of interest
% Created by Xiaosu Hu 9/16/2019
% Version 9/16/2019

% Plot two tasks for each participant to check baseline shift, bad raw data
figure
for i=1:length(raw)
    subplot(ceil(length(raw)/6),6,i);
    plot(raw(i).data(:,chinterest));
    title(raw(i).description(digit1:digit2));
end

figure
% CWT Part
down=nirs.modules.Resample();
down.Fs=4;
down.run(raw);

for i=1:length(raw)
    [cfs,frq] = cwt(raw(i).data(:,chinterest),down.Fs);
    subplot(ceil(length(raw)/6),6,i);
    surface(raw(i).time,frq,abs(cfs));
    axis tight
    shading flat
    title(raw(i).description(digit1:digit2));
end

end

