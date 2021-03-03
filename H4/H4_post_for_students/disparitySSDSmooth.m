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
function [disparityMap] = disparitySSDSmooth(frameLeftGray, frameRightGray, windowSize, smoothness)
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
    
    % Keep track of unique values and disparity directions
    unique = ones(m, n);
    dir = zeros(m, n);
    
    % Reorder j values, start from the middle and go outwards instead of
    % going from left to right
    n1 = floor(n/2):-1:1;
    n2 = floor(n/2)+1:n;
    n_middle = zeros(1, n);
    n_middle(1:2:n) = n2;
    n_middle(2:2:n) = n1;
    
    % Loop over every pixel in the image 
    for i = 1:m
        % Reset previous disparity values values between rows
        prevDispList = NaN * ones(1, n);
        j_index = 0;
        for j = n_middle
            % Default minimum value
            minSSD = Inf;
            
            % Keep track of which index j is at, since its not in order
            % anymore
            j_index = j_index + 1;
            % If first value in row, check over full disparity range
            if j_index == 1
                dispRange = -maxDisp:maxDisp;
            else
                % Get previous (neighbor) disparity value, and build a
                % disparity range based on the smoothness value
                prevDisp = prevDispList(n_middle(j_index - 1));
                disp_left = max(-maxDisp, round(prevDisp - maxDisp * smoothness));
                disp_right = min(maxDisp, round(prevDisp + maxDisp * smoothness));
                dispRange = disp_left:disp_right;
            end
            
            % Loop over disparity range (changes each iteration)
            for d = dispRange
                SSD = 0;
                % Check we are within the bounds of the image
                if j + d <= n && j + d > 0 && unique(i, j + d) == 1
                    % For window size of 1, we have a single point
                    if windowSize == 1
                        SSD = SSD + (frameLeftGray(i, j) - frameRightGray(i, j + d))^2;
                    else
                        % For larger window size, we sum up over the window
                        for wi = -windowWidth:windowWidth
                            for wj = -windowWidth:windowWidth
                                % Check image bounds
                                if j + wj > 0 && j + wj <= n && j + d + wj <= n && j + d + wj > 0 ...
                                        && i + wi > 0 && i + wi <= m
                                    % Difference between two images
                                    val = frameLeftGray(i + wi, j + wj) - frameRightGray(i + wi, j + wj + d);
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
                        disparityMap(i, j) = abs(d);
                        dir(i, j) = sign(d);

                        % Keep track of previous disparity values for next
                        % iterations
                        prevDispList(j) = d;
                    end
                end
            end
            % Mark this disparity value as taken for the uniqueness
            % constraint
            unique(i, j + (dir(i, j) * disparityMap(i, j))) = 0;
        end
    end
end

