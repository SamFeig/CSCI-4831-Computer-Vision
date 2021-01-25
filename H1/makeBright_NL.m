function [ outImg ] = makeBright_NL(inImg, brightness)
    % Add brightness to each pixel value in the image
    outImg = inImg + brightness;
end