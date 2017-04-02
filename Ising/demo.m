% clear; close all; clc;
close all; clear;
% load letterA.mat;
% X = A;
load letterX.mat
%%
[M, N] = size(X); 
K = 2;
sigma  = 1; % noise level
img    = double(X);
img = sign(img-mean(img(:)));
y = img + sigma*randn(M,N); %y = noisy signal
z = [1;-1];
J = 1;

figure;
subplot(3,2,1);
imagesc(img);
title('original image');
axis image;
colormap gray;

subplot(3,2,2);
imagesc(y);
title('noisy image');
axis image;
colormap gray;

%%
epoch = 10;
y = reshape(y,1,[]);
nodePot = (y-z).^2/(2*sigma^2);
edgePot = -J*(z*z');
%% original
logodds = reshape(diff(nodePot),M,N);
J = 1;
mu0 = meanFieldIsingGrid(logodds, J, epoch);

subplot(3,2,3);
imagesc(mu0)
title('MLAPP mean field');
axis image;
colormap gray;
%% Ising mean field 
h = reshape(0.5*diff(nodePot),M,N);
J = 1; % coupling strength
mu = isingMeanField(h, J, epoch);
maxdiff(mu0,mu)

subplot(3,2,4);
imagesc(mu)
title('Ising mean field');
axis image;
colormap gray;

%% Image mean field
nodeBel = imageMeanField(M, N, nodePot, edgePot, epoch);
maxdiff(reshape(mu,1,[]),z'*nodeBel)

subplot(3,2,5);
imagesc(reshape(nodeBel(1,:),M,N))
title('Image mean field');
axis image;
colormap gray;

%% graph mean field
A = lattice([M,N]);
edgePot = repmat(edgePot,[1, 1, nnz(tril(A))]);
[nodeBel0, lnZ] = meanField(A, nodePot, edgePot, epoch);
maxdiff(nodeBel0,nodeBel)

subplot(3,2,6);
imagesc(reshape(nodeBel0(1,:),M,N))
title('Image mean field');
axis image;
colormap gray;

%%
% y = reshape(y, M, N);





