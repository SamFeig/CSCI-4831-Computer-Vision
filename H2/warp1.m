%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Sam Feig 
% Vladimir Zhdanov
%
% CSCI 4831/5722
% Homework 2
% Instructor: Ioana Fleming
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Task 3: Warping Images to Produce Output Mosiac
function [ outImg ] = warp1(H, img1, img2, frame)
    % Get sizes of both images
    [m1, n1, ~] = size(img1);
    [m2, n2, ~] = size(img2);
    
    % Corners of the second image
    img2_corners = [1 1; m2 1; 1 n2; m2 n2];
    
    % Warp the corners of img2 to determine the required size of the final
    % image
    new_corners = zeros(4, 3);
    for i = 1:size(img2_corners, 1)
        p = [img2_corners(i, 1); img2_corners(i, 2); 1];
        new_corners(i, :) = H \ p;
        new_corners(i, :) = new_corners(i, :) / new_corners(i, 3);
    end
    
    % Find the minimum x and y values from image 1 and the transformed
    % image 2 corners
    min_m = min([new_corners(:, 1); 1; m1]);
    max_m = max([new_corners(:, 1); 1; m1]);
    min_n = min([new_corners(:, 2); 1; n1]);
    max_n = max([new_corners(:, 2); 1; n1]);

    % Instantiate output image of the required size
    outImg = uint8(zeros(ceil(max_m - min_m), ceil(max_n - min_n), 3));
    
    % Calculate x and y offset
    x_offset = ceil(1 - min_m);
    y_offset = ceil(1 - min_n);
    
    
    % Mesh for interpolation
    [X_mesh, Y_mesh] = meshgrid(1:n2, 1:m2);
    dimg2 = double(img2);
    
    % Values which will be interpolated in image 2
    img2_ivals = zeros(size(outImg, 1), size(outImg, 2));
    img2_jvals = zeros(size(outImg, 1), size(outImg, 2));
    
    % Map each point from the output to image 2 coordinates
    for i = 1:size(outImg, 1)
        for j = 1:size(outImg, 2)
            img2_mapping = H * [i - x_offset; j - y_offset; 1];
            img2_mapping = img2_mapping / img2_mapping(3);
            img2_ivals(i, j) = img2_mapping(1);
            img2_jvals(i, j) = img2_mapping(2);
        end
    end
    % Create warped image 2 by interpolating each (x, y) value in the
    % output image to image 2
    warped_img2 = zeros(size(outImg));
    
    % Interpolate each color channel seperately since interp2 only works in 2D
    warped_img2(:, :, 1) = interp2(X_mesh, Y_mesh, dimg2(:, :, 1), img2_jvals, img2_ivals);
    warped_img2(:, :, 2) = interp2(X_mesh, Y_mesh, dimg2(:, :, 2), img2_jvals, img2_ivals);
    warped_img2(:, :, 3) = interp2(X_mesh, Y_mesh, dimg2(:, :, 3), img2_jvals, img2_ivals);
    warped_img2 = uint8(warped_img2);
    
    % Fill in the output image
    for i = 1:size(outImg, 1)
        for j = 1:size(outImg, 2)
            % Calculate (i, j) values of image 1 for the current (i, j) of
            % the output image
            img1_i = i - x_offset;
            img1_j = j - y_offset;
            % Check if current point in output is in image 1
            in_img1 = 0 <  img1_i &&  img1_i <= m1 && 0 < img1_j &&  img1_j <= n1;
            
            % Calculate (i, j) values of image 2 for the current (i, j) of
            % the output image
            img2_i = img2_ivals(i, j);
            img2_j = img2_jvals(i, j);
            % Check if current point in output is in image 2
            in_img2 = 0 < img2_i && img2_i <= m2 && 0 < img2_j && img2_j <= n2;
            
            % If both images overlap, use image 1
            if in_img1 && in_img2
                % Use this line instead to pick the max of both pixels
                % outImg(i, j, :) = max(img1(img1_i, img1_j, :), warped_img2(i, j, :));
                
                % Map overlap to image 2 if doing frame, otherwise use image 1 as
                % it won't be warped.
                if frame == 1
                    outImg(i, j, :) = warped_img2(img1_i, img1_j, :);
                else 
                    outImg(i, j, :) = img1(img1_i, img1_j, :);
                end
            % If only in image 1, show pixel from image 1
            elseif in_img1
                outImg(i, j, :) = img1(img1_i, img1_j, :);
            % If only in image 2, show pixel from warped (interpolated) image 2
            elseif in_img2
                outImg(i, j, :) = warped_img2(i, j, :);
            end
        end
    end
end