%I = imread('circuit.tif');
%BW1 = edge(I,'Canny');
%BW2 = edge(I,'Prewitt');
%imshowpair(BW1,BW2,'montage')


% - using prewitt
I = imread('http://i.stack.imgur.com/5EJJH.jpg');

figure, imshow(I);
I_prewitt = prewitt(I);

%figure, edge(I_prewitt,'Prewitt', [], 'both', 'nothinning');


% - using canny
I_canny = canny(I);
figure, imshow(I_canny)


