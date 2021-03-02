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
    % Convert both frames to doubles so that SSDs can be calculated
    % accurately
    frameLeftGray = im2double(frameLeftGray);
    frameRightGray = im2double(frameRightGray);

    % Get image size and initialize disparity map to default zero
    [m, n] = size(frameLeftGray);
    disparityMap = zeros(m, n);
    
    % Calculate window width, gaussian weight matrix
    windowWidth = floor(windowSize / 2);
    gaussWeights = fspecial('gaussian', windowSize, 1);
    
    % Maximum disparity value
    maxDisp = 64;
    
    % Loop over every pixel in the image 
    for i = 1:m
        for j = 1:n
            % Default minimum value
            minSSD = Inf;
            % Traverse epipolar line until maximum disparity value
            for d = 0:maxDisp
                % Check both directions
                for sign = [-1, 1]
                    SSD = 0;
                    % Check we are within the bounds of the image
                    if j + sign * d <= n && j + sign * d > 0
                        % For window size of 1, we have a single point
                        if windowSize == 1
                            SSD = SSD + (frameLeftGray(i, j) - frameRightGray(i, j  + sign * d))^2;
                        else
                            % For larger window size, we sum up over the window
                            for wi = -windowWidth:windowWidth
                                for wj = -windowWidth:windowWidth
                                    % Check image bounds
                                    if j + wj > 0 && j + wj <= n && j + sign * d + wj <= n && j + sign * d + wj > 0 ...
                                            && i + wi > 0 && i + wi <= m
                                        % Difference between two images
                                        val = frameLeftGray(i + wi, j + wj) - frameRightGray(i + wi, j + wj + sign * d);
                                        % Multiply by gaussian weight and add
                                        % to SSD value
                                        SSD = SSD + (gaussWeights(wi + windowWidth + 1, wj + windowWidth + 1) * val)^2;
                                    end
                                end
                            end
                        end
                        % If this value is the min SSD, set this to disparity.
                        if SSD < minSSD
                            minSSD = SSD;
                            % Disparity is abs(x - x'), so ignore sign
                            disparityMap(i, j) = d;
                        end
                    end
                end
            end
        end
    end
end

