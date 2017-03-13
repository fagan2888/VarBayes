function [nodeBel, edgeBel, L] = expProp(A, nodePot, edgePot)
% Expectation propagation for MRF
% Input: 
%   A: n x n adjacent matrix of undirected graph, where value is edge index
%   nodePot: k x n node potential
%   edgePot: k x k x m edge potential
% Output:
%   nodeBel: k x n node belief
%   edgeBel: k x k x m edge belief
%   L: variational lower bound (Bethe energy)
% Written by Mo Chen (sth4nth@gmail.com)
tol = 1e-4;
epoch = 50;
[k,n] = size(nodePot);
m = size(edgePot,3);

[s,t,e] = find(tril(A));
M = sparse([s;t],[t;s],[e;e+m]);       % digraph adjacent matrix, where value is message index
mu = ones(k,2*m)/k;         % message
for iter = 1:epoch
    mu0 = mu;
    for l = 1:m
        i = s(l);
        j = t(l);
        ep = edgePot(:,:,e(l));

        np = nodePot(:,i);        
        ne = find(A(i,:));
        out = M(i,j);
        in = M(setdiff(ne,j),i);
        mu(:,out) = normalize(ep*(np.*prod(mu(:,in),2)));
        
        np = nodePot(:,j);
        ne = find(A(j,:));
        out = M(j,i);
        in = M(setdiff(ne,i),j);
        mu(:,out) = normalize(ep*(np.*prod(mu(:,in),2)));
    end
    if sum(abs(mu(:)-mu0(:))) < tol; break; end
end

nodeBel = zeros(k,n);
for i = 1:n
    [~,~,in] = find(M(:,i));
    nodeBel(:,i) = nodePot(:,i).*prod(mu(:,in),2);
end
nodeBel = normalize(nodeBel,1);

edgeBel = zeros(k,k,m);
for l = 1:m
    nbt = nodeBel(:,t(l))./mu(:,M(s(l),t(l)));
    nbs = nodeBel(:,s(l))./mu(:,M(t(l),s(l)));
    eb = (nbt*nbs').*edgePot(:,:,e(l));
    edgeBel(:,:,e(l)) = eb./sum(eb(:));
end

