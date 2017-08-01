function m = imageGmrfMeanField(L, l, eta, epoch)
% L: \Lambda_{ij}
% l: \Lambda_{ii}
% eta: \lambda_i*x_i
if nargin < 3
    epoch = 10;
end
[M,N] = size(eta);
m =  eta;
stride = [-1,1,-M,M];
for t = 1:epoch
    for j = 1:N
        for i = 1:M
            pos = i + M*(j-1);
            ne = pos + stride;
            ne([i,i,j,j] == [1,M,1,N]) = [];
            m(i,j) = (eta(i,j)-L*sum(m(ne)))/l(i,j);
        end
    end
end 

