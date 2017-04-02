function [nodeBel, lnZ] = meanField(A, nodePot, edgePot, epoch)
% Mean field for MRF
% Assuming egdePot is symmetric
% Input: 
%   A: n x n adjacent matrix of undirected graph, where value is edge index
%   nodePot: k x n node potential
%   edgePot: k x k x m edge potential
% Output:
%   nodeBel: k x n node belief
%   edgeBel: k x k x m edge belief
%   L: variational lower bound
% Written by Mo Chen (sth4nth@gmail.com)
if nargin < 4
    epoch = 10;
end
tol = 1e-4;
lnZ = -inf(1,epoch+1);
[nodeBel,L] = softmax(-nodePot,1);    % init nodeBel    
for iter = 1:epoch
    for i = 1:numel(L)
        [~,j,e] = find(A(i,:));             % neighbors
        np = nodePot(:,i);
        [lnp ,lnz] = lognormexp(-np-reshape(edgePot(:,:,e),2,[])*reshape(nodeBel(:,j),[],1));
        p = exp(lnp);
        L(i) = -dot(p,lnp+np)+lnz; %
        nodeBel(:,i) = p;
    end
    lnZ(iter+1) = sum(L)/2;
%     if abs(lnZ(iter+1)-lnZ(iter))/abs(lnZ(iter)) < tol; break; end
end
lnZ = lnZ(2:iter);