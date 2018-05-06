% This test is mainly test canny filters with different 'sigma' value


addpath('images');
addpath('png');

img_ori_input    = {'2018.jpg','3063.jpg','5096.jpg','6046.jpg','8068.jpg'};
img_cmp_input    = {'2018.png','3063.png','5096.png','6046.png','8068.png'};


sigma = 5;
%h = fspecial('gaussian', 5, sigma);

ii = 1;
% I_canny     = canny(imread( char(img_ori_input(ii))));
% I_filtered  = imread( char(img_cmp_input(ii)) ) ;
% 
% %fname = strcmp('sigma = ', char(sigma));
% figure('Name', 'sigma = 5')
% imshowpair(I_filtered, I_canny, 'montage');
% title('ground-truth                                     canny Filter');


sigma = [0.5, 1, 1.5, 2, 3, 5]; 
for ii = 1:5
    for i = 1:6
        I = imread( char(img_ori_input(ii)));
        I_canny = canny_sigma(I, sigma(i));

        figure('Name', strcat('sigma = ', char(string(sigma(i)))))
        imshow(I_canny);
    end
end