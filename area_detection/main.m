
% loading the image
img = imread('proteins.jpg');

figure
imshow(img)

% original image
x = img;
subplot(231), imshow(x); title('ori-img-01')

% gause noise reduction
y1 = fspecial('gaussian',5,0.1);
z1 = imfilter(x,y1,'symmetric');
subplot(232), imshow(z1); title('scale 5*5, std = 0.1')

y2 = fspecial('gaussian', 5,2);










