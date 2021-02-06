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
%% Task 2: Computing the Homography Parameters
function[ H_out ] = computeH(points)
    n = 20;
    H = zeros(3, 3, n);
    num_points = size(points, 1);
    
    distance = zeros(n, 1);
    p = zeros(num_points,3);

    % Repeat 20 times
    for i = 1:n
        % Select 4 random points
        rand_indices = randperm(num_points,4);
        selectPoints = points(rand_indices,:);
        
        A = zeros(8,9);
        for j = 1:4
            x1 = selectPoints(j,1);
            y1 = selectPoints(j,2);
            x2 = selectPoints(j,3);
            y2 = selectPoints(j,4);
            
            % Build A matrix from (x1, y1) and (x2, y2) values
            A(2*j-1, :) = [-x1, -y1, -1, 0, 0, 0, x1*x2, y1*x2, x2];
            A(2*j, :) = [0, 0, 0, -x1, -y1, -1, x1*y2, y1*y2, y2];
        end
    
        % SVD of the A matrix, we only need V in this case
        [~,~,V] = svd(A);
        
        % The last column of V is the solution for h.
        h_sol = V(:, end);
        
        % Reshape V into H matrix based on formula in homography paper
        H(:, :, i) = transpose(reshape(h_sol, [3,3]));
        
        % Project image 1 points onto image 2
        for j = 1:num_points
          p(j, :) = H(:, :, j) * [points(j, 1); points(j, 2); 1];
          p(j, :) = p(j, :) / p(j, 3);
        end
        
        % Calculate Euclidean distance between all of the points in image 2
        % and the transformed points from image 1
        e_dist = sqrt(sum((points(:, 3) - p(:, 1)).^2 + (points(:, 4) - p(:, 2)).^2, 2));
        
        % Save the average distance value to find the minimum at the end
        distance(i) = sum(e_dist) / num_points;
    end
    
    % Find index of minimum average distance
    min_index = find(distance == min(distance));
    H_out = H(:, :, min_index(1));
end

