function [ outImg ] = makeBright_L(inImg, brightness)
    outImg = inImg;
    for i = 1:size(inImg, 1)
        for j = 1:size(inImg, 2)
            for k = 1:size(inImg, 3)
                outImg(i, j, k) = inImg(i, j, k) + brightness;
            end
        end
    end
end