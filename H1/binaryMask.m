function [ outImg] = binaryMask(inImg)
    [x, y]=size(inImg, [1,2]); 
    inImg = double(inImg); 
    
    sum = 0; 
    for i=1:x 
        for j=1:y 
            sum = sum + inImg(i, j); 
        end
    end
     
    threshold = sum / ( x * y ); 
    outImg = zeros(x, y);
    
    for i=1:x 
        for j=1:y 
            if inImg(i, j) >= threshold 
                outImg(i, j) = 0; 
            else
                outImg(i, j)=1; 
            end
        end
    end   
end

