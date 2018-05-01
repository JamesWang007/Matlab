% This test is mainly test the three filters and compare them.

addpath('images');
addpath('png');

img_ori_input       = {'2018.jpg','3063.jpg','5096.jpg','6046.jpg','8068.jpg'};
img_cmp_input    = {'2018.png','3063.png','5096.png','6046.png','8068.png'};

%I = imread( char(img_path(1)) );
%figure, imshow(I);


imgs_filtered_canny     = compare_multiple_images(img_ori_input, img_cmp_input, 'canny');
imgs_filtered_sobel     = compare_multiple_images(img_ori_input, img_cmp_input, 'sobel');
imgs_filtered_prewitt   = compare_multiple_images(img_ori_input, img_cmp_input, 'prewitt');

%I1 = cell2mat(imgs_filtered(2,1));
%figure,imshow(I1);

L = length(img_ori_input);
for i = 1:L
    I_canny     = cell2mat(imgs_filtered_canny(1, i)) ;
    I_filtered  = cell2mat(imgs_filtered(2, i)) ;
    
    figure
    imshowpair(I_filtered, I_canny, 'montage');
    title('ground-truth                                     canny Filter');
    
    
    % - compare sobel and prewitt
    I_sobel     = cell2mat(imgs_filtered_sobel(1, i));
    I_prewitt   = cell2mat(imgs_filtered_prewitt(1, i));
    
    figure
    imshowpair(I_sobel, I_prewitt, 'montage');
    title('sobel Filter                                    prewitt Filter');
   
end

