%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Sam Feig 
% Vladimir Zhdanov
%
% CSCI 4831/5722
% Homework 4
% Instructor: Ioana Fleming
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [disparityMap] = disparitySSD(frameLeftGray, frameRightGray, windowSize)
    frameLeftGray = im2double(frameLeftGray);
    frameRightGray = im2double(frameRightGray);

    [m, n] = size(frameLeftGray);
    disparityMap = zeros(m, n);
    
    windowWidth = floor(windowSize / 2);
    gaussWeights = fspecial('gaussian', windowSize, 1);
    maxDisp = 64;
    
    for i = 1:m
        for j = 1:n
            minSSD = Inf;
            for d = 0:maxDisp
                SSD = 0;
                
                if j + d <= n
                    if windowSize == 1
                        SSD = SSD + (frameLeftGray(i, j + d) - frameRightGray(i, j))^2;
                    else
                       for wi = -windowWidth:windowWidth
                           for wj = -windowWidth:windowWidth
                                if j + wj > 0 && j + d + wj <= n && i + wi > 0 && i + wi <= m
                                   val = frameLeftGray(i + wi, j + wj + d) - frameRightGray(i + wi, j + wj);
                                   SSD = SSD + (gaussWeights(wi + windowWidth + 1, wj + windowWidth + 1) * val)^2;
                                end
                           end
                       end
                    end
                    
                    if SSD < minSSD
                       minSSD = SSD;
                       disparityMap(i, j) = d;
                    end
                end
            end
        end
    end
end

