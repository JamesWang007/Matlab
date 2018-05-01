%addpath(fullfile(pwd,'TOOLBOX'));
%addpath(fullfile(pwd,'images'));

%Sobel Edge Detection 
I = imread('5EJJH.jpg');
I_gray = rgb2gray(I);
I = im2double(I_gray);    
    
f_ori = figure,imshow(I);
message = sprintf('Sobel Edge Detection');

f_c = figure, I_sobel = sobelEdgeDetection(I);
imshow(I_sobel);



%uiwait(msgbox(message,'Done', 'help'));
%close all