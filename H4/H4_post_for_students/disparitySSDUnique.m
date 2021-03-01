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
function [disparityMap] = disparitySSDUnique(frameLeftGray, frameRightGray, windowSize)
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
        
    unique = ones(m, n);
    SSDMap = zeros(m, n, maxDisp + 1);
    % Loop over every pixel in the image 
    for i = 1:m
        for j = 1:n
            % Default minimum value
            minSSD = Inf;
            SSDs = Inf(1, maxDisp + 1);
            % Traverse epipolar line until maximum disparity value
            for d = 0:maxDisp
                SSD = 0;
                % Check we are within the bounds of the image
                if j + d <= n
                    % For window size of 1, we have a single point
                    if windowSize == 1
                        SSD = SSD + (frameLeftGray(i, j + d) - frameRightGray(i, j))^2;
                    else
                        % For larger window size, we sum up over the window
                        for wi = -windowWidth:windowWidth
                            for wj = -windowWidth:windowWidth
                                % Check image bounds
                                if j + wj > 0 && j + d + wj <= n && i + wi > 0 && i + wi <= m
                                    % Difference between two images
                                    val = frameLeftGray(i + wi, j + wj + d) - frameRightGray(i + wi, j + wj);
                                    % Multiply by gaussian weight and add
                                    % to SSD value
                                    SSD = SSD + (gaussWeights(wi + windowWidth + 1, wj + windowWidth + 1) * val)^2;
                                end
                            end
                        end
                    end
                    SSDs(d + 1) = SSD;
                    if SSD < minSSD
                        minSSD = SSD;
                        disparityMap(i, j) = d;
                    end
                end
            end
%             SSDs
        end
    end
    
%     for i = 1:m
%         for j = 1:n
%         
%         end
%     end
    for threshold = 0:2:maxDisp
        for i = 1:m
            for j = 1:n
                d = disparityMap(i, j);
                if d < threshold && unique(i, j + d) == 1
                    unique(i, j + d) = 0;
                end
            end
        end
    end
    
    for threshold = maxDisp:-4:0
        threshold
        for i = 1:m
            for j = 1:n
                d = disparityMap(i, j);
                if d > threshold && unique(i, j + d) == 0
                    for dd = 1:maxDisp
                        if j + dd <= n && unique(i, j + dd) == 1
                            disparityMap(i, j) = dd;
                            unique(i, j + dd) = 0;
                        end
                    end
                end
            end
        end
    end
%         for dd = 1:maxDisp
%     if j + dd <= n && unique(i, j + dd) == 1
%         disparityMap(i, j) = dd;
%     end
% end
%     end
end

