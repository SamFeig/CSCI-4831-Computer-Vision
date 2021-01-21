function [ outImg ] = meanFilter(inImg, kernel_size)
    outImg = inImg;
    [m, n, color] = size(inImg);
    
    kernel_offset = floor(kernel_size / 2);
    
    for i = 1:size(inImg, 1)
        i_left = max([1 i - kernel_offset]);
        i_right = min([i + kernel_offset m]);
        for j = 1:size(inImg, 2)
            j_left = max([1 j - kernel_offset]);
            j_right = min([j + kernel_offset n]);
            for k = 1:size(inImg, 3)
                outImg(i, j, k) = mean(inImg(i_left:i_right, j_left:j_right, k), 'all');
            end
        end
    end
    
end