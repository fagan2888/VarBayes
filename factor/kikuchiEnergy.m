function lnZ = kikuchiEnergy(A, nodePot, factorPot, nodeBel, factorBel)
% Compute Kikuchi free energy

edgePot = reshape(edgePot,[],size(edgePot,3));
edgeBel = reshape(edgeBel,[],size(edgeBel,3));
Ex = dot(nodeBel,nodePot,1);
Exy = dot(edgeBel,edgePot,1);
Hx = -dot(nodeBel,log(nodeBel),1);
Hxy = -dot(edgeBel,log(edgeBel),1);
d = full(sum(logical(A),1));
lnZ = -sum(Ex)-sum(Exy)-sum((d-1).*Hx)+sum(Hxy);