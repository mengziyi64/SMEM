function f = RTfuntwist(y,C); 

n1 = size(C,1);
n2 = size(C,2);
m = size(C,3);

y=reshape(y,n1,n2);

yp = repmat(y,[1,1,m]);       
f = yp.*C;                       