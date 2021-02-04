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
function[ Hout, minDis ] = computeH(points, n)
    H = zeros(3,3,20);
    distance = zeros(20,1);
    newPt = zeros(n,3);

    % Repeat 20 times
    for i = 1:20
        % Select 4 random points
        idx = randperm(n,4);
        selectPoints = points(idx,:);
        
        A = zeros(8,9);
        for j = 1:4
            x1 = selectPoints(j,1);
            y1 = selectPoints(j,2);
            x2 = selectPoints(j,3);
            y2 = selectPoints(j,4);
            
            % Solve linear equation
            A(2*j-1, :) = [-x1, -y1, -1, 0, 0, 0, x1*x2, y1*x2, x2];
            A(2*j, :) = [0, 0, 0, -x1, -y1, -1, x1*y2, y1*y2, y2];
        end
    
        % Svd of the 8*9 matrix
        [~,~,V] = svd(A);
        % Reshape last column of V into 3*3 matrix
        % Compute Ax = b
        H(:, :, i) = transpose(reshape(V(:, end), [3,3]));
        
        % Calc projection coord
        for j = 1:n
          newPt(j, :) = H(:, :, j) * [points(j, 1); points(j, 2); 1];
          newPt(j, :) = newPt(j, :) / newPt(j, 3);
        end
        % Calc euclidean distance for all 10 points
        distance(i) = sum(sqrt(sum((newPt(:, 1:2) - points(:, 3:4)).^2, 2)));
    end
    
    minDis = min(distance);
    % Find index of min distance
    idx = find(distance == minDis);
    Hout = H(:, :, idx(1));
end

