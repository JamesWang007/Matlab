function [ output ] = fun_binary_img( I )
%FUN_BINARY_IMG Summary of this function goes here
%   Detailed explanation goes here

    BW = im2bw(I,level)
    BW = im2bw(X,cmap,level)
    BW = im2bw(RGB,level)

end

