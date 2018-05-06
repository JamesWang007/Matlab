function out_imgs = compare_multiple_images( input_imgs, input_cmp_imgs, filter_name)
%COMPARE_MULTIPLE_IMAGES Summary of this function goes here
%   Detailed explanation goes here

    % - reserve data structure
    out_imgs = cell(2, length(input_imgs));
    
    for i = 1 : length(input_imgs)
        I = imread( char(input_imgs(i)) );
        if strcmp(filter_name, 'canny')
            func = @canny;
        elseif strcmp(filter_name, 'sobel')
            func = @sobel;
        elseif strcmp(filter_name, 'prewitt')
            func = @prewitt;
        end
        
        I_filter = func(I);
        %figure('Name', char(input_imgs(i)))
        %imshowpair(I, I_filter, 'montage');
        %title('original image                                   canny Filter');
        
        %imshow(I_filter);
        %if i == 1
            %out_imgs = I_filter;
        %end
        out_imgs(1, i) = {I_filter};
        
        
        I_cmp = imread( char(input_cmp_imgs(i)) );
        out_imgs(2, i) = {I_cmp}; 
    end
    
end

