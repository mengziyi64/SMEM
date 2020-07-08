function f=RT2(y0,H_4d)

f = bsxfun(@times, y0,H_4d);
% y=zeros(1,1,1,size(H_4d,4));
% y(1,1,1,:) = y0;
% % size(y)= [xsize ysize 1 frames]
% %% Replicate to number of channels in system:
% f = squeeze(sum(bsxfun(@times, y, H_4d),4));
% size(yp)=[xsize ysize m frames] and yp(:,:,1,:)=yp(:,:,2,:)=yp(:,:,m,:)
%% Punch the slices:
%f=yp.*Cs;

%% Sum up on the 4th dimension:
% size(f)=[xsize ysize wchannel] 3-D data
