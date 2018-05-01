sigma = 1.4;
h = fspecial('gaussian', 5, sigma);

159*h

H = ones(5,5);
for i = 1:5
    for j = 1:5
        H(i,j) = (1/((2*pi*sigma*sigma)))*exp( -((i-3)^2+(j-3)^2)/(2*sigma*sigma) );
        
    end
end

H*159