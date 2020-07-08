% For normal cpu:
function y=R2(f,H_4d)
% Number of images:
%nt=size(shift,2);

% Make sure in 4D shape:
%f=reshape(f,[row,col,nC]);

% Punch:
y = sum(f.*H_4d,3);
%gp=bsxfun(@times, f,Cs);

% Sum up the 3rd dimensions in each seperate image:
%y=y(:);