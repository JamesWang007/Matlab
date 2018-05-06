%addpath(fullfile(pwd,'TOOLBOX'));
%addpath(fullfile(pwd,'images'));

%Sobel Edge Detection 
I = imread('rocks.jpg');
I_gray = rgb2gray(I);
I_gray_double = double(I_gray); 
f_ori = figure,imshow(I_gray_double);
message = sprintf('Sobel Edge Detection');

f_c = figure, I_sobel = sobelEdgeDetection(I_gray_double);
imshow(I_sobel);



%uiwait(msgbox(message,'Done', 'help'));
%close all