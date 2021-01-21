function [ outImg] = binaryMask(inImg) 
    inImg = double(inImg); 
    threshold = mean(inImg, 'all');
    
    outImg = inImg < threshold;
    
end

