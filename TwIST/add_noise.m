%% add noise
clear all
close all
QE=0.45;  % quantum efficient of your CCD
d = dir(['..\meas\*.mat']);
for k = 2:10
    load(['..\meas\', d(k).name]);
    meas = meas_real./max(meas_real(:));
    meas_noisy = binornd(round(meas*4095/QE),QE);
    meas_real = meas_noisy./max(meas_noisy(:));
    meas_real(find(meas_real<0))=0;
    save(['..\meas_noisy\scene',int2str(k),'.mat'],'meas_real')
end