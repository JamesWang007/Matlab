function [img_py1, img_py2, img_py3, img_py11, img_py22, img_py33] = pyramid( img_py )
%PYRAMID Summary of this function goes here
%   Detailed explanation goes here

    img_py1 = impyramid(img_py, 'reduce');
    img_py2 = impyramid(img_py1, 'reduce');
    img_py3 = impyramid(img_py2, 'reduce');

    img_py33 = impyramid(img_py3, 'expand');
    img_py22 = impyramid(img_py33, 'expand');
    img_py11 = impyramid(img_py22, 'expand');
    
end

