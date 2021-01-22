function [ outImg ] = scaleNearest(inImg, factor) 
    [m, n, color] = size(inImg);
    
    outImg = uint8(zeros(floor(m * factor), floor(n * factor), color));
    
    for i = 1:size(outImg, 1)
        for j = 1:size(outImg, 2)
            x = min([round((i - 1)/ factor)+1 m]);
            y = min([round((j - 1)/factor)+1 n]);
            outImg(i, j, :) = inImg(x, y, :);
        end
    end
end