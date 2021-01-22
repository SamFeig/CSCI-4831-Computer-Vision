function [ outImg ] = scaleBilinear( inImg, factor )
    [m, n, color] = size(inImg);
    outImg = uint8(zeros(floor(m * factor), floor(n * factor), color));
    
    for i = 1:size(outImg, 1)
        % x coords for corner points
        x1 = floor(i / factor);
        x2 = ceil(i / factor);
        
        if x1 == 0
            x1 = 1;
        end
        
        % x distance from new pixel to mapping
        x = rem(i / factor, 1);
        
        for j = 1:size(outImg, 2)
            % y coords for corner points
            y1 = floor(j / factor);
            y2 = ceil(j / factor);
            
            if y1 == 0
               y1 = 1;
            end
           
            % Neighbor pixels
            q10 = inImg(x1, y1, :);
            q00 = inImg(x2, y1, :);
            q11 = inImg(x1, y2, :);
            q01 = inImg(x2, y2, :);
           
            % y distance from new pixel to mapping
            y = rem(j / factor, 1);
           
            % Get weighted pixel color
            tr = (q11 * y) + (q10 * (1 - y));
            br = (q01 * y) + (q00 * (1 - y));
            outImg(i, j, :) = (tr * x) + (br * (1 - x));
        end
    end
end

