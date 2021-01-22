function [ outImg ] = scaleNearest(inImg, factor) 
    [m, n, color] = size(inImg);
    
    outImg = uint8(zeros(floor(m * factor), floor(n * factor), color));
    
    for i = 1:size(outImg, 1)
        for j = 1:size(outImg, 2)
            outImg(i, j, :) = inImg(round((i - 1)/ factor) + 1, round((j - 1)/factor) + 1, :);
        end
    end
end