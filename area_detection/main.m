%%
% loading the image
img = imread('proteins.jpg');

%figure
%imshow(img)

% original image
x = img;
subplot(231), imshow(x); title('ori-img-01')

%% 
subplot(121), imshow(x); title('ori-img-01')

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

img_gray = rgb2gray(img);
[Gmag, Gdir] = imgradient(img_grad, 'prewitt');

figure
imshowpair(Gmag, Gdir, 'montage');
title('Gradient Magnitude, Gmag (left), and Gradient Direction, Gdir (right), using Prewitt method')



%% Noise Removal - averaging
% https://www.mathworks.com/help/images/noise-removal.html


J = img_gray;
% average
Kaverage = filter2(fspecial('average', 3), J)/255;
%figure, imshow(Kaverage)

% median
Kmedian = medfilt2(J);
imshowpair(Kaverage, Kmedian, 'montage')



%% Remove the noise using the wiener2 function

K = wiener2(J, [7, 7]);
%figure, imshow(K(600:1000, 1:600));
figure, imshow(K); title('wiener2');




%%   - 
bw = im2bw(img, 0.3);
figure, imshow(bw)



%%  - https://www.mathworks.com/help/images/ref/imbinarize.html
imbin = imbinarize(img_gray, 'adaptive');
figure, imshow(imbin)

%% pyramid
img_py = img_gray;

img_py1 = impyramid(img_py, 'reduce');
img_py2 = impyramid(img_py1, 'reduce');
img_py3 = impyramid(img_py2, 'reduce');

img_py33 = impyramid(img_py3, 'expand');
img_py22 = impyramid(img_py33, 'expand');
img_py11 = impyramid(img_py22, 'expand');



%% 




























