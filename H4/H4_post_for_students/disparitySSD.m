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
    [m, n] = size(frameLeftGray);
    disparityMap = zeros(m, n);
    
    windowWidth = floor(windowSize / 2);
    gaussWeights = fspecial('gaussian', windowSize, 1);
    maxDisp = 64;
    
    for i = 1:m
        for j = 1:n
            minSSD = Inf;
            
            for d = 0:maxDisp
                if j - d > 0
                    SSD = 0;
                    
                    if windowSize == 1
                        SSD = (frameLeftGray(i, j) - frameRightGray(i, j - d))^2;
                    else
                       for wi = -windowWidth:windowWidth
                           for wj = -windowWidth:windowWidth
                                if j - d + wj > 0 && j - d + wj <= n && i + wi > 0 && i + wi <= m
                                   val = (frameLeftGray(i, j) - frameRightGray(i, j - d))^2;
                                   SSD = SSD + gaussWeights(wi + windowWidth + 1, wj + windowWidth + 1) * val;
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
            if minSSD == Inf
                disparityMap(i, j) = maxDisp;
            end
        end
    end
end

