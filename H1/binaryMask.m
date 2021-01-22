function [ outImg] = binaryMask(inImg) 
    threshold = mean(inImg, 'all');
    outImg = inImg < threshold; 
end

