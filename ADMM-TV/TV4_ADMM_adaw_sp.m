
function  im    =   TV4_ADMM_CACTI_adaw_sp( y, para, M_func,Mt_func)
%if nargin==4%function
    A=@(x) M_func(x);
    At=@(z) Mt_func(z);
%else%Matrix
%    A=@(x)M_func*x;
%    At=@(z)M_func'*z;
%end

%if isfield(para,'ini')
%    im = para.ini;
%else
v          =    single(At( y ));
%end

lambda      =   para.lambda;
eta = para.eta;
Phi_sum = single(para.Phi_sum);
TVweight = para.TVweight;
%v = im; % initialization
theta = v;
b = zeros(size(v),'like',v);  
for  iter = 1 : para.iter   
     if (mod(iter, 5) == 0)||(iter==1)
       if isfield(para,'ori_im')
          % PSNR = 0;
          para.ori_im = single(para.ori_im);
           PSNR     =   psnr((v./max(v(:))), para.ori_im./max(para.ori_im(:)));              
           fprintf( 'CS-OCT Recovery , ADMM-TV, Iter %d : PSNR = %f\n', iter, PSNR );
       else
           fprintf( 'CS-OCT Recovery , ADMM-TV, Iter %d : MSE = %f, time to now: %d\n', iter, norm(y-A(v)), toc);
       end
     end
    
      thetab = theta +b;
      yb = A(thetab);
      v = thetab+lambda*(At((y-yb)./(Phi_sum+eta)));
 
      vmb = v-b;
      theta         =   tvdenoise_sp(vmb,  TVweight,20); 


      %
       b = theta-vmb; 
       TVweight = 0.999*TVweight;
       eta = 0.998*eta;
end
im     =  double(v);

%fprintf( 'CS-OCT Recovery , ADMM-TV, Iter %d : MSE = %f, time to now: %d\n', iter, norm(y-A(v)), toc);
end




