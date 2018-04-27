function out_img = prewitt( input_image )
%PREWITT Summary of this function goes here
%

    I = rgb2gray(input_image);
    I = im2double(I); 

    % mask
    maskX=[-1 -1 -1;0 0 0;1 1 1]/6;
    maskY=[-1 0 1; -1 0 1; -1 0 1]/6;
    
    Gx=abs(conv2(I, maskY, 'same'));
    Gy=abs(conv2(I, maskX, 'same'));
    
    magnitude = sqrt( Gx.^2 + Gy.^2); % L2 norm
    out_img = magnitude > 0.08995; % hard coding
   

end

