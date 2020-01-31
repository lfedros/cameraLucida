% Polar Practice

%% center = (0,0)

% load image
load clown;
img = ind2rgb(X,map);

% convert pixel coordinates from cartesian to polar
[h, w, ~] = size(img);
[X, Y] = meshgrid(1:w, 1:h);
[theta, rho] = cart2pol(X, Y);
Z = zeros(size(theta));

% show pixel locations (sub-sample to show less dense points)
XX = X(1:8:end, 1:4:end);
YY = Y(1:8:end, 1:4:end);
tt = theta(1:8:end, 1:4:end);
rr = rho(1:8:end, 1:4:end);

subplot(121); scatter(XX(:), YY(:), 3, 'filled'); axis ij image
subplot(122); scatter(tt(:), rr(:), 3, 'filled'); axis ij square tight

% show images
figure
subplot(121); imshow(img); axis on
subplot(122); warp(theta, rho, Z, img); view(2); axis square

%% center = (w/2, h/2)

[X,Y] = meshgrid((1:w)-floor(w/2), (1:h)-floor(h/2));

%% mapping in inverse direction

[h,w,~] = size(img);
s = min(h,w)/2;
[rho,theta] = meshgrid( linspace(0, s-1, s), linspace(0,2*pi) );
[x,y] = pol2cart(theta, rho);
z = zeros(size(x));
subplot(121); imshow(img);
subplot(122); warp(x, y, z, img); view(2); axis square tight off









