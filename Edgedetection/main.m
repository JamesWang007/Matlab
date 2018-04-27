%I = imread('circuit.tif');
%BW1 = edge(I,'Canny');
%BW2 = edge(I,'Prewitt');
%imshowpair(BW1,BW2,'montage')


% - using prewitt
I = imread('5EJJH.jpg');
f_ori = figure('Name', 'original image'), imshow(I);

I_prewitt = prewitt(I);
%f_p = figure('Name', 'prewitt'), imshow(I_prewitt);

%figure, edge(I_prewitt,'Prewitt', [], 'both', 'nothinning');


% - using canny
I_canny = canny(I);
%f_c = figure('Name', 'canny'), imshow(I_canny);


f_cmp = figure('Name', 'compare')
imshowpair(I_prewitt, I_canny, 'montage')


