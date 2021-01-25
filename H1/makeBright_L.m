function [ outImg ] = makeBright_L(inImg, brightness)
    outImg = inImg;
    
    % Loop through each value in the image
    for i = 1:size(inImg, 1)
        for j = 1:size(inImg, 2)
            for k = 1:size(inImg, 3)
                % Add the brightness to each pixel value
                outImg(i, j, k) = inImg(i, j, k) + brightness;
            end
        end
    end
end