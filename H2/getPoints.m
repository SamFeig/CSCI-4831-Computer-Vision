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
function [ output ] = getPoints(img1, img2)
    % Number of points to gather
    n = 10;
    
    % Instantiate (x, y) matrices for selected points from each image
    points1 = zeros(n, 2);
    points2 = zeros(n, 2);
    
    % Select n points on each image
    for i = 1:n
        % Display first image
        imagesc(img1)
        hold on
        title(['Select Point ' num2str(i) ' from Img 1'])
        
        % Plot previously selected points
        plot(points1(1:i-1, 1), points1(1:i-1, 2), '.m', 'MarkerSize', 10)
        
        % Get user input on new point
        points1(i, :) = ginput(1);
        hold off
        
        
        % Display second image
        imagesc(img2)
        hold on
        title(['Select Point ' num2str(i) ' from Img 2'])
        
        % Plot previously selected points
        plot(points2(1:i-1, 1), points2(1:i-1, 2), '.m', 'MarkerSize', 10)
        
        % Get user input on new point
        points2(i, :) = ginput(1);
        hold off
    end
    
    % Close any remaining ginput figures
    close all;
    
    % Switch x and y in each point set for output, since we want
    % (row, column) position
    output = [points1(:, 2), points1(:, 1), points2(:, 2), points2(:, 1)];

end