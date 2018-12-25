%%
% loading the image
img = imread('proteins.jpg');

%figure
%imshow(img)

% original image
x = img;
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








