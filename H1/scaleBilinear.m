function [ outImg ] = scaleBilinear( inImg, factor )
    [m, n, color] = size(inImg);
    
    outImg = uint8(zeros(floor(m * factor), floor(n * factor), color));
    
    for i = 1:size(outImg, 1)
        x1 = floor(i/factor);
        x2 = ceil(i/factor);
        
        if x1 == 0
            x1 = 1;
        end
        if x2 > size(outImg, 1)
            x2 = size(outImg, 1);
        end
        
        for j = 1:size(outImg, 2)
            y1 = floor(j/factor);
            y2 = ceil(j/factor);
            if y1 == 0
                y1 = 1;
            end
            if y2 > size(outImg, 2)
                y2 = size(outImg, 2);
            end
            disp(x1)
            disp(x2)
            disp(y1)
            disp(y2)
            disp(sum(inImg(x1:x2, y1:y2, :)) / 4)
            
            outImg(i, j, :) = sum(inImg(x1:x2, y1:y2, :)) / 4;
        end
    end
end

