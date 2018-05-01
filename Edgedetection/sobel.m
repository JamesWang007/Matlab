function out_img = sobel( img_ori )
%SOBEL Summary of this function goes here
%   Detailed explanation goes here


    I = rgb2gray(img_ori);
    I = im2double(I); 
    
    maskX = [-1 0 1 ; -2 0 2; -1 0 1];
    maskY = [-1 -2 -1 ; 0 0 0 ; 1 2 1] ;

    GX = conv2(I, maskX);
    GY = conv2(I, maskY);

    magnitude = sqrt(GX.^2 + GY.^2); % L2-norm
    %out_img(1:10, 1:10)
    out_img = magnitude > 101/255; % hard coding

end

