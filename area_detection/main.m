%%
% loading the image
img = imread('proteins.jpg');

%figure
%imshow(img)

% original image
x = img;
<<<<<<< HEAD
subplot(231), imshow(x); title('ori-img-01')
%% 
=======
subplot(121), imshow(x); title('ori-img-01')
>>>>>>> c3d99a1f65c1da48636362a67edcf3c3b0b6f7f1

% gause noise reduction
y1 = fspecial('gaussian',5,0.1);
z1 = imfilter(x,y1,'symmetric');
subplot(122), imshow(z1); title('scale 5*5, std = 0.1')

y2 = fspecial('gaussian', 5,2);


%%
img_grad = rgb2gray(img);

figure
imshow(img_grad);

% edge detection
img_edge = rgb2gray(img);
figure
imshow(img_edge)


bw1 = edge(img_edge, 'Canny');
bw2 = edge(img_edge, 'Prewitt');

imshowpair(bw1, bw2, 'montage')

%%

img_grad = rgb2gray(img);
[Gmag, Gdir] = imgradient(img_grad, 'prewitt');

figure
imshowpair(Gmag, Gdir, 'montage');
title('Gradient Magnitude, Gmag (left), and Gradient Direction, Gdir (right), using Prewitt method')



%%


































