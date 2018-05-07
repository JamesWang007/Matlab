% Five steps:
%    step 1 : Gaussian Filter
%    step 2 : Convolution
%    step 3 : Non Maximum Supression
%    step 4 : Double Thresholding
%    step 5 : Hysteresis Thresholding
%    
% load an image
I = imread ('rocks.jpg');
figure, imshow(I);
I_gray = rgb2gray(I);
I_gray_double = double(I_gray);

% Step 1
% create the Gaussian Filter operator
B = [2, 4, 5, 4, 2; 4, 9, 12, 9, 4;5, 12, 15, 12, 5;4, 9, 12, 9, 4;2, 4, 5, 4, 2 ];
B = 1/159 .* B;

% apply convolution to image by Gaussian Coefficient
A=conv2(I_gray_double , B, 'same');

% apply filter in horizontal and vertical directions
Gx = [-1, 0, 1; -2, 0, 2; -1, 0, 1];
Gy = [1, 2, 1; 0, 0, 0; -1, -2, -1];

% apply convolution to image by horizontal and vertical filter
Filtered_GX = conv2(A, Gx, 'same');
Filtered_GY = conv2(A, Gy, 'same');

% apply calculate directions/orientations
angle_GauFilter = atan2 (Filtered_GY, Filtered_GX);
angle_GauFilter = angle_GauFilter*180/pi;

img_height = size(A,1);
img_width  = size(A,2);

% modify all value positive
for i=1:img_height
    for j=1:img_width
        if (angle_GauFilter(i,j)<0) 
            angle_GauFilter(i,j)=360+angle_GauFilter(i,j);
        end;
    end;
end;

angle_GauFilter2=zeros(img_height , img_width);

% modify directions to nearest 0, 45, 90, or 135 degree
for i = 1  : img_height
    for j = 1 : img_width
        if ((angle_GauFilter(i, j) >= 0 ) && (angle_GauFilter(i, j) < 22.5) || (angle_GauFilter(i, j) >= 337.5) && (angle_GauFilter(i, j) <= 360) || (angle_GauFilter(i, j) >= 157.5) && (angle_GauFilter(i, j) < 202.5))
            angle_GauFilter2(i, j) = 0;
        elseif ((angle_GauFilter(i, j) >= 22.5) && (angle_GauFilter(i, j) < 67.5) || (angle_GauFilter(i, j) >= 202.5) && (angle_GauFilter(i, j) < 247.5))
            angle_GauFilter2(i, j) = 45;
        elseif ((angle_GauFilter(i, j) >= 67.5 && angle_GauFilter(i, j) < 112.5) || (angle_GauFilter(i, j) >= 247.5 && angle_GauFilter(i, j) < 292.5))
            angle_GauFilter2(i, j) = 90;
        elseif ((angle_GauFilter(i, j) >= 112.5 && angle_GauFilter(i, j) < 157.5) || (angle_GauFilter(i, j) >= 292.5 && angle_GauFilter(i, j) < 337.5))
            angle_GauFilter2(i, j) = 135;
        end;
    end;
end;

figure, imagesc(angle_GauFilter2); colorbar;

% Step 2
% Calculate magnitude
magnitude = (Filtered_GX.^2) + (Filtered_GY.^2);
magnitude2 = sqrt(magnitude);

img_NMSupression = zeros (img_height, img_width);


% Step 3
% apply Non-Maximum Supression
for i=2:img_height-1
    for j=2:img_width-1
        if (angle_GauFilter2(i,j)==0)
            img_NMSupression(i,j) = (magnitude2(i,j) == max([magnitude2(i,j), magnitude2(i,j+1), magnitude2(i,j-1)]));
        elseif (angle_GauFilter2(i,j)==45)
            img_NMSupression(i,j) = (magnitude2(i,j) == max([magnitude2(i,j), magnitude2(i+1,j-1), magnitude2(i-1,j+1)]));
        elseif (angle_GauFilter2(i,j)==90)
            img_NMSupression(i,j) = (magnitude2(i,j) == max([magnitude2(i,j), magnitude2(i+1,j), magnitude2(i-1,j)]));
        elseif (angle_GauFilter2(i,j)==135)
            img_NMSupression(i,j) = (magnitude2(i,j) == max([magnitude2(i,j), magnitude2(i+1,j+1), magnitude2(i-1,j-1)]));
        end;
    end;
end;

img_NMSupression = img_NMSupression.*magnitude2;
figure, imshow(img_NMSupression);

% Step 4 & 5
% apply Hysteresis Thresholding
threshold_low = 0.075;
threshold_high = 0.175;
%threshold_low = 0.030;
%threshold_high = 0.30;
threshold_low = threshold_low * max(max(img_NMSupression));
threshold_high = threshold_high * max(max(img_NMSupression));

threshold_res = zeros (img_height, img_width);

for i = 1  : img_height
    for j = 1 : img_width
        if (img_NMSupression(i, j) < threshold_low)
            threshold_res(i, j) = 0;
        elseif (img_NMSupression(i, j) > threshold_high)
            threshold_res(i, j) = 1;
        elseif ( img_NMSupression(i+1,j)>threshold_high || img_NMSupression(i-1,j)>threshold_high || img_NMSupression(i,j+1)>threshold_high || img_NMSupression(i,j-1)>threshold_high || img_NMSupression(i-1, j-1)>threshold_high || img_NMSupression(i-1, j+1)>threshold_high || img_NMSupression(i+1, j+1)>threshold_high || img_NMSupression(i+1, j-1)>threshold_high)
            threshold_res(i,j) = 1;
        end;
    end;
end;

final_res = uint8(threshold_res.*255);
% final result
figure, imshow(final_res);
