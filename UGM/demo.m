clear; close all;
%% Original Image
load X.mat
figure
subplot(2,2,1);
imagesc(X);
colormap gray
title('Original X');
%% Noisy Image
[nRows,nCols] = size(X);
X = X + randn(size(X))/2;
subplot(2,2,2);
imagesc(X);
colormap gray
title('Noisy X');
%% Mean Field
[A,np,ep] = im2mrf(X);
[A0,np0,ep0] = im2mrf0(X);
% [nbmf, ebmf, L] = meanField(A, np, ep);
% subplot(2,2,3);
% imagesc(reshape(nbmf(2,:),nRows,nCols));
% colormap gray
% title('Mean Field');
%% Belief Propagation
tic;
[nbbp,ebbp] = expProp(A, exp(np), exp(ep));
toc;
subplot(2,2,3);
imagesc(reshape(nbbp(2,:),nRows,nCols));
colormap gray
title('Belief Propagation');
%%
tic;
[nbep,ebep] = expProp0(A, exp(np), exp(ep));
toc;
subplot(2,2,4);
imagesc(reshape(nbbp(2,:),nRows,nCols));
colormap gray
title('Expectation Propagation');


maxdiff(nbbp,nbep)
maxdiff(ebbp,ebep)