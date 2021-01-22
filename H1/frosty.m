function [ outImg ] = frosty( inImg, n, m )
    [x, y, z] = size(inImg);
    
    outImg = zeros(x, y, z);
    
    for i = 1:x
        for j = 1:y
                neighbors = {};
                for nn = -n/2:n/2
                    for mm = -m/2:m/2
                        idxx = i+nn;
                        idxy = j+mm;
                        if idxx < 1
                            idxx = 1;
                        elseif idxx > x
                            idxx = x;
                        end
                        if idxy < 1
                            idxy = 1;
                        elseif idxy > y
                            idxy = y;
                        end
                        % disp(inImg(idxx, idxy, :))
                        neighbors = [neighbors, inImg(idxx, idxy, :)];
                    end
                end

                frost = randi(numel(neighbors), 1);
                % disp(neighbors{frost})

                outImg(i, j, :) = neighbors{frost};
        end
    end
end

