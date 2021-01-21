function [ outImg ] = addRandomNoise_NL(inImg)
    r = randi([-255,255], size(inImg, 1), size(inImg, 2))
    outImg = inImg * r;
end
