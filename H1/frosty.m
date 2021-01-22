function [ outImg ] = frosty( inImg, n, m )
    [x, y, z] = size(inImg);
    
    outImg = uint8(zeros(x, y, z));
    n_offset = floor(n / 2);
    m_offset = floor(m / 2);
    
    for i = 1:x
        m_left = max([1 i - m_offset]);
        m_right = min([i + m_offset x]);
        for j = 1:y
            n_left = max([1 j - n_offset]);
            n_right = min([j + n_offset y]);
            
            outImg(i, j, :) = inImg(randi([m_left m_right]), randi([n_left n_right]), :);
        end
    end
%     for i = 1:x
%         for j = 1:y
%                 neighbors = {};
%                 for nn = -n/2:n/2
%                     for mm = -m/2:m/2
%                         idxx = i+nn;
%                         idxy = j+mm;
%                         if idxx < 1
%                             idxx = 1;
%                         elseif idxx > x
%                             idxx = x;
%                         end
%                         if idxy < 1
%                             idxy = 1;
%                         elseif idxy > y
%                             idxy = y;
%                         end
%                         % disp(inImg(idxx, idxy, :))
%                         neighbors = [neighbors, inImg(idxx, idxy, :)];
%                     end
%                 end
% 
%                 frost = randi(numel(neighbors), 1);
%                 % disp(neighbors{frost})
% 
%                 outImg(i, j, :) = neighbors{frost};
%         end
%     end
end

