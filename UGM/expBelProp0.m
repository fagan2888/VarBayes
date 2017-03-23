function [nodeBel, edgeBel, L] = expBelProp0(A, nodePot, edgePot)
% Expectation Belief propagation for MRF, calculation in log scale
% Assuming egdePot is symmetric
% 
% This is something between expectation propagation and belief propagation.
% Expectation propagation updates (two) messages for each edge and computes (two) node beliefs in each step.
% Belief propagation updates messages async and does not care about node belief.
% This function update messages async and compute node beliefs in each step
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
A = sparse([s;t],[t;s],[e;e+m]);       % digraph adjacent matrix, where value is message index
mu = zeros(k,2*m)-log(k);    
nodeBel = nodePot-logsumexp(nodePot,1);
for iter = 1:epoch
    mu0 = mu;
    for i = 1:n
        [ne,~,in] = find(A(:,i));
        for l = 1:numel(ne)
            j = ne(l);
            eji = in(l);
            eij = rd(eji,m);
            ep = edgePot(:,:,ud(eji,m));
            
            nodeBel(:,j) = nodeBel(:,j)-mu(:,eij);
            mut = logsumexp(ep+(nodeBel(:,i)-mu(:,eji)),1);
            mu(:,eij) = mut-logsumexp(mut);
            nb = nodeBel(:,j)+mu(:,eij);
            nodeBel(:,j) = nb-logsumexp(nb);
        end
    end
    if max(abs(mu(:)-mu0(:))) < tol; break; end
end

edgeBel = zeros(k,k,m);
for l = 1:m
    eij = e(l);
    eji = eij+m;
    ep = edgePot(:,:,eij);
    nbt = nodeBel(:,t(l))-mu(:,eij);
    nbs = nodeBel(:,s(l))-mu(:,eji);
    eb = (nbt+nbs')+ep;
    edgeBel(:,:,eij) = eb-logsumexp(eb(:));
end
nodeBel = exp(nodeBel);
edgeBel = exp(edgeBel);

function i = rd(i, m)
% reverse direction edge index
i = mod(i+m-1,2*m)+1;

function i = ud(i, m)
% undirected edge index
i = mod(i-1,m)+1;