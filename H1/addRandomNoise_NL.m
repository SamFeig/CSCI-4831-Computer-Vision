function [ outImg ] = addRandomNoise_NL(inImg)
    inImg = double(inImg);
    noise = randi([-255, 255], size(inImg, 1), size(inImg, 2), size(inImg, 3));
    outImg = uint8(inImg + noise);
end
