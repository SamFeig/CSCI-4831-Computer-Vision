function [ outImg ] = swirlFilter(inImg, factor, ox, oy)
    [m, n, color] = size(inImg);
    
    outImg = uint8(zeros(m, n, color));
    
    
    for i = 1:m
        % Get x coordinate with respect to ox
        x = i - ox - factor;
        for j = 1:n
            % Get y coordinate with respect to oy
            y = j - oy + factor;
            
            % Convert to polar coordinates (r, theta)
            r = sqrt(x^2 + y^2);
            theta = atan(y / x);
            
            % Rotate point based on distance r and the factor
            new_theta = theta + r / factor;

            % Convert back to cartesian coordinates
            new_x = round(r * cos(new_theta)) + ox;
            new_y = round(r * sin(new_theta)) + oy;
            
            % Check index within bounds of image, set to nearest bound if not
            new_x = max(new_x, 1);
            new_x = min(new_x, m);
            new_y = max(new_y, 1);
            new_y = min(new_y, n);
            
            % Map rotated pixels to output
            outImg(i, j, :) = inImg(new_x, new_y, :);
        end
    end
end