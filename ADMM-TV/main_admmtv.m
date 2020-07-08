clear all
clc
%%%%%
% ADMM-TV algorithm 
% file_names contains 'fern_root', 'resolution_target',
% 'dog_olfactory_membrane', 'blood_sample1', 'blood_sample2'
%% load data
file_name = 'fern_root';  
load('..\Data\mask_3d_shift.mat');
load(['..\Data\Testing_real_data\',file_name,'.mat']);
Phi = double(mask_3d_shift);
Phi = Phi./max(Phi(:));
[row, col, ch] = size(Phi);
A = @(f) R2(f,Phi);
AT = @(y) RT2(y,Phi);
y = meas./max(meas(:));
%% ADMM-TV reconstruction
Phi_sum = sum(Phi.^2,3);
para.lambda = 1;
para.Phi_sum = Phi_sum;
para.row = row;
para.col = col;
para.eta = 5;
para.TVweight = 10;                % please adjust this parameter to get the best result
para.iter =50;                      % iteration times

x_gaptv  =   TV4_ADMM_adaw_sp( y, para, A,AT);
temp = x_gaptv;
% shift back
step = 2;
for i = 1:ch
    temp(:,:,i) = circshift(squeeze(temp(:,:,i)),[0 -step*(i-1)]);
end
recon = temp(:,1:col-2*(ch-1),:);
%% show
lam24 = [454.4 459.5 464.9 470.5 476.2 482.1 488.4 494.8 501.5 508.5...
    515.8 523.4 531.4 539.7 548.4 557.5 567.0 577.0 587.6 598.7 610.3 622.6 635.6 649.3];
img_nb = [3,6,9,12,15,18,21,24];
vects = 4; vects2 = 2; intensity = 1;
dispCubeAshwin(recon(:,:,img_nb), intensity, lam24(img_nb),[],vects,vects2,0,1,['ADMMTV']);