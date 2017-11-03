%% Original image
clear; close all;
data = load('letterX.mat');
img = double(data.X); 
img = sign(img-mean(img(:)));
figure;
subplot(2,3,1);
imagesc(img);
title('Original image');
axis image;
colormap gray;
%% Noisy image 
lambda = 4; % noise level lambda = 1/sigma^2
img = img + sqrt(1/lambda)*randn(size(img)); 
subplot(2,3,2);
imagesc(img);
title('Noisy image');
axis image;
colormap gray;
%% Parameters
epoch = 100;
n = numel(img);
a = 1;                       % edge weight: L(i,j) = -a
A = a*lattice(size(img));    % adjacent matrix
d = full(sum(A,1));          % node degree: L(i,i) = d(i)
D = sparse(1:n,1:n,d,n,n,n); % degree matrix
L = D-A;                     % Laplacian matrix
%% Closed form Gaussian Posterior
x = reshape(img,1,[]);
Lambda = lambda*speye(n)+L;
eta = lambda*x;
mu = Lambda\eta(:);

subplot(2,3,3);
imagesc(reshape(mu,size(img)));
title('Closed form');
axis image;
colormap gray;
% %% Image Gaussian MRF Mean Field
% d = reshape(d,size(img));
% mu0 = imageGmrfMeanField(img, lambda, d, -a, epoch);
% maxdiff(mu(:),mu0(:))
% 
% subplot(2,3,4);
% imagesc(mu0);
% title('Image GMRF MF');
% axis image;
% colormap gray;
% %% General Gaussian MRF Mean Field
% [mu1, lb1] = gmrfMeanField(x, lambda, L, epoch);
% maxdiff(mu(:),mu1(:))
% 
% subplot(2,3,5);
% imagesc(reshape(mu1,size(img)));
% title('GMRF MF');
% axis image;
% colormap gray;
%% Gaussian MRF Belief Propagation
mu2 = gmrfBelProp(Lambda, eta, epoch);
maxdiff(mu(:),mu2(:))

subplot(2,3,6);
imagesc(reshape(mu2,size(img)));
title('GMRF BP');
axis image;
colormap gray;
% %% Lower bound
% figure; plot(lb1); 
% % lb = gibbsGmrf(mu, Lambda, eta);

%% Gaussian free energy
lnZ = eta*(Lambda\eta')-logdet(Lambda)+0.5*n*log(2*pi);
