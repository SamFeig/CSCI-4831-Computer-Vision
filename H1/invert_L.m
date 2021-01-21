function [ outImg ] = invert_L(inImg)
    outImg = inImg;
    for i = 1:size(inImg, 1)
        for j = 1:size(inImg, 2)
            for k = 1:size(inImg, 3)
                outImg(i, j, k) = 255 - inImg(i, j, k);
            end
        end
    end
end