function y = TVnormspectralimaging(x)

for i = 1:size(x,3)
y(i) = sum(sum(sqrt(diffh(x(:,:,i)).^2+diffv(x(:,:,i)).^2)));
end

y = sum(y);