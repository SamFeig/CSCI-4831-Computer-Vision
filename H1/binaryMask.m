function [ outImg] = binaryMask(inImg) 
    % Set threshold for the mask as the mean color in the image
    threshold = mean(inImg, 'all');
    
    % Convert to binary mask based on threshold
    outImg = inImg < threshold; 
end

