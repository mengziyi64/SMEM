function [img_estimated]=mycalltoTVnewMatrix2cpu(mycube,th,piter)
% th=.4;
% piter=4;
% mycube=rand(400,400,37);
% tic, [img_estimated]=mycalltoTVnewMatrix2cpu(mycube,th,piter); toc

x = mycube(:,:,1);
[uy ux] = size(x);
uz=size(mycube,3);

zv=zeros(1,size(x,2),'single');
zh=zeros(size(x,1),1,'single');
pn=zeros(uy*ux,2,'single');

vect = @(x) x(:);
opQ = @(x) [vect(dh(x,zh)) vect(dv(x,zv))] ;
opQt = @(x) dht(reshape(x(:,1),uy,ux),zh)+dvt(reshape(x(:,2),uy,ux),zv);

img_estimated=zeros(uy,ux,uz,'single');
for i = 1:uz
    x = mycube(:,:,i);
    
    img_estimated(:,:,i) = x - projk(x,th/2,opQ,opQt,piter,pn);
end

% Proj function:
function u=projk(g,lambda,opQ,opQt,niter,pn)
tau=0.25;
for i=1:niter
    S=opQ(-opQt(pn)-g./lambda);
    pn=(pn+tau*S)./(1+tau*modulo(S));
end
u=-lambda.*opQt(pn);

function R=modulo(x)
R=sqrt(sum(x.^2,2));
R=[R R];

% Derivatives:
function y = dh(x,zh)
x = [x zh] - [zh x];
x(:,end) = x(:,end)+x(:,1);
y = x(:,2:end);


function y = dht(x,zh)
x = [zh x] - [x zh];
x(:,1) = x(:,end)+x(:,1);
y = x(:,1:end-1);


function y = dv(x,zv)
x = [x; zv]- [zv; x];
x(end,:) = x(end,:)+x(1,:);
y = x(2:end,:);


function y = dvt(x,zv)
x = [zv; x]-[x; zv];
x(1,:) = x(end,:)+x(1,:);
y = x(1:end-1,:);
