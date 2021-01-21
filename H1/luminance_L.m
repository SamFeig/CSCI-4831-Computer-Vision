function [ outImg ] = luminance_L(inImg)
    outImg = .299 * inImg(:, :, 1) + .587 * inImg(:, :, 2) + .114 * inImg(:, :, 3);
end