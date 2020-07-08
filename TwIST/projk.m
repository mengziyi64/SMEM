function u=projk(g,lambda,opQ,opQt,niter)
%
% Usage:
% function u=projk(g,lambda,opQ,opQT,niter)
%
% Chambolle projection's algorithm from 
%
% "An Algorithm for Total Variation Minimization and
%  Applications", 2004
%
% This algorithm solves the following problem: 
%
%    arg min_u = 0.5*|| u - g ||_2^2 + lambda ||op(u)||_1   (1)
%
%
% 
% The solution of (1) is given by: 
%
%    u = g - projk(g)
% 
% See the refered paper for details.
%
% ======================
% Parameters:
%
% 'g'       : noisy image (size X: ny * nx)
%  
% 'lambda'  : lambda parameter according to (1)
%
% 'opQ'     : Functional Op(u): X -> X1*X2 (product space)
%             The return of this function should be a matrix with two columns
%             in this form: [X1(:)' X2(:)'] (size: (ny*nx) * 2)
%
% 'opQt'    : Adjoint operator of Op(u). OpQt: X1*X2 -> X
%             The input should be a matrix of size (ny*nx) * 2 
%
% 'niter'   : Number of iterations
%
% 
% =======================
%
% Coded by Joao Oliveira - May 2008
%
% http://www.lx.it.pt/~jpaos/
%
%


tau=0.25;


[uy,ux]=size(g);
pn=zeros(uy*ux,2);


for i=1:niter
    S=opQ(-opQt(pn)-g./lambda);
    pn=(pn+tau*S)./(1+tau*modulo(S));
end

u=-lambda.*opQt(pn);

function R=modulo(x)

R=sqrt(sum(x.^2,2));

R=repmat(R,[1 2]);

