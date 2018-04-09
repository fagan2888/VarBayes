%% Original image
clear; close all;
data = load('letterX.mat');
img = double(data.X); 
img = sign(img-mean(img(:)));

figure
subplot(2,2,1);
imagesc(img);
title('Original image');
axis image;
colormap gray;
%% Parameters
J = 1;
sigma = 1;
epoch = 20;
%% Noisy image
x = img + sigma*randn(size(img)); % noisy signal
subplot(2,2,2);
imagesc(x);
title('Noisy image');
axis image;
colormap gray;
%% Construct graph
[B,nodePot,factorPot] = im2fg(x,sigma,J);
% [A, nodeBel, edgeBel] = im2mrf(x,sigma,J);
%% Mean field on a factor graph
nodeBel0 = fgMf(B, nodePot, factorPot, epoch);

subplot(2,2,3);
imagesc(reshape(nodeBel0(1,:),size(img)));
title('Mean Field');
axis image;
colormap gray;
%% Belief propagation on a factor graph
[nb,fb] = fgBp(B, nodePot, factorPot, epoch);
% [nodeBel,edgeBel] = belProp(A, nodePot, edgePot, epoch);
% maxdiff(nb, nodeBel)

% lnZ = fgBethe(B, nodePot, factorPot, nb, fb);
% lnZ0 = bethe(A,nodePot,edgePot,nodeBel,edgeBel);
% maxdiff(lnZ,lnZ0)

subplot(2,2,4);
imagesc(reshape(nb(1,:),size(img)));
title('Belief Propagation');
axis image;
colormap gray;

