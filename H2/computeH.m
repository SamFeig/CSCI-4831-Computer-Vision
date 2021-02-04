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

    % repeat for 20 times
    for j=1:20
        % Select 4 random points
        idx = randperm(n,4);
        selectPoints = points(idx,:);
        
        A = zeros(8,9);

        for i = 1:4
            x1 = selectPoints(i,1);
            y1 = selectPoints(i,2);
            x2 = selectPoints(i,3);
            y2 = selectPoints(i,4);
            
            % Solve linear equation
            A(2*i-1, :) = [-x1, -y1, -1, 0, 0, 0, x1*x2, y1*x2, x2];
            A(2*i, :) = [0, 0, 0, -x1, -y1, -1, x1*y2, y1*y2, y2];
        end
    
        % Svd of the 8*9 matrix
        [~,~,V] = svd(A);
        % Reshape last column of V into 3*3 matrix
        % Compute Ax = b
        H(:, :, j) = transpose(reshape(V(:, end), [3,3]));
        
        % Calc projection coord
        for i2 = 1:n
          newPt(i2, :) = H(:, :, j) * [points(i2, 1); points(i2, 2); 1];
          newPt(i2, :) = newPt(i2, :) / newPt(i2, 3);
        end
        % Calc euclidean distance for all 10 points
        distance(j) = sum(sqrt(sum((newPt(:, 1:2) - points(:, 3:4)).^2, 2)));
    end
    
    minDis = min(distance);
    % Find index of min distance
    idx = find(distance == minDis);
    Hout = H(:, :, idx(1));
end

