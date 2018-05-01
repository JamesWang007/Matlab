%I = imread('circuit.tif');
%BW1 = edge(I,'Canny');
%BW2 = edge(I,'Prewitt');
%imshowpair(BW1,BW2,'montage')


I = imread('5EJJH.jpg');
%f_ori = figure('Name', 'original image'), imshow(I);

% - using prewitt
I_prewitt = prewitt(I);
%f_p = figure('Name', 'prewitt'), imshow(I_prewitt);

%figure, edge(I_prewitt,'Prewitt', [], 'both', 'nothinning');


% - using sobel
I_sobel = sobel(I);
%f_sobel = figure('Name', 'sobel'), imshow(I_sobel);


% - using canny
I_canny = canny(I);
%f_c = figure('Name', 'canny'), imshow(I_canny);



% - compare
f_cmp1 = figure('Name', 'compare1')
imshowpair(I, I_prewitt, 'montage')
title('original image                                   Prewitt Filter');

f_cmp2 = figure('Name', 'compare2')
imshowpair(I_sobel, I_canny, 'montage')
title('Sobel Filter                                     Canny Filter');