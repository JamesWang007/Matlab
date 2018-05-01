function magnitude = sobelEdgeDetection( img_ori )

    maskX = [-1 0 1 ; -2 0 2; -1 0 1];
    maskY = [-1 -2 -1 ; 0 0 0 ; 1 2 1] ;

    resX = conv2(img_ori, maskX);
    resY = conv2(img_ori, maskY);

    magnitude = sqrt(resX.^2 + resY.^2); % L2-norm
    thresh = magnitude < 101/255; % hard coding
    magnitude(thresh) = 0;
    
end