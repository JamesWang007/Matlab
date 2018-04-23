I = imread('circuit.tif');
% imshow(I)




BW1 = edge(I,'Canny');

BW2 = edge(I,'Prewitt');

imshowpair(BW1,BW2,'montage')




I = gpuArray(imread('circuit.tif'));

BW = edge(I,'prewitt');

figure, imshow(BW)







