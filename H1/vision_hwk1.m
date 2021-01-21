% This script creates a menu driven application

%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% your information
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all;close all;clc;

% Display a menu and get a choice
choice = menu('Choose an option', 'Exit Program', 'Load Image', ...
              'Display Image', 'Brighten', 'Brighten 2', ...
              'Invert', 'Invert 2', 'Add Random Noise', ...
              'Luminance', 'Red Filter', 'Binary Image', ...
              'Mean Filter', 'Frosty Filter', 'Scale Nearest', ...
              'Scale Bilinear', 'Fun Filter', 'Famous Me');
% Choice 1 is to exit the program
while choice ~= 1
    switch choice
        case 0
           disp('Error - please choose one of the options.')
        case 2
           % Load an image
           image_choice = menu('Choose an image', 'lena1', 'mandril1', 'sully', 'yoda', 'shrek');
           switch image_choice
               case 1
                   filename = 'lena1_small.jpg';
               case 2
                   filename = 'mandrill1.jpg';
               case 3
                   filename = 'sully.bmp';
               case 4
                   filename = 'yoda_small.bmp';
               case 5
                   filename = 'shrek.bmp';
               % fill in cases for all the images you plan to use
           end
           current_img = imread(filename);
        case 3
           % Display image
           figure
           imagesc(current_img);
           if size(current_img,3) == 1
               colormap gray
           end
           
        case 4
            % Brighten
            prompt = {'Input a Brightness Value'};
            dlgtitle = 'Input';
            input = inputdlg(prompt, dlgtitle);
            brightness = str2double(input{1});
            
            outImg = makeBright_L(current_img, brightness);
            
            figure
            subplot(1, 2, 1)
            imagesc(current_img);
            subplot(1, 2, 2)
            imagesc(outImg);
            
            current_img = outImg;
        case 5
            % Brighten 2
            prompt = {'Input a Brightness Value'};
            dlgtitle = 'Input';
            input = inputdlg(prompt, dlgtitle);
            brightness = str2double(input{1});
            
            outImg = makeBright_NL(current_img, brightness);
            
            figure
            subplot(1, 2, 1)
            imagesc(current_img);
            subplot(1, 2, 2)
            imagesc(outImg);
        case 6
            % Invert
        case 7
            % Invert 2
        case 8
            % AddRandomNoise
        case 9
            % Luminance
        case 10
            % Red Filter
        case 11
            % Binary Image
        case 12
%             % Mean Filter
% 
%             % 1. Ask the user for size of kernel
% 
%             % 2. Call the appropriate function
%             newImage = meanFilter(current_img, k_size); % create your own function for the mean filter
% 
%             % 3. Display the old and the new image using subplot
%             % ....
%             %subplot(...)
%             %imagesc(current_img)
% 
%             % subplot(...)
%             %imagesc(newImage)
%             % 4. Save the newImage to a file

        case 13
            % Frosty Filter
        case 14
            % Scale Nearest
        case 15
            % Scale Bilinear
        case 16
            % Swirl/Fun Filter
        case 17
            % Famous Me
        


   end
   % Display menu again and get user's choice
   choice = menu('Choose an option', 'Exit Program', 'Load Image', ...
              'Display Image', 'Brighten', 'Brighten 2', ...
              'Invert', 'Invert 2', 'Add Random Noise', ...
              'Luminance', 'Red Filter', 'Binary Image', ...
              'Mean Filter', 'Frosty Filter', 'Scale Nearest', ...
              'Scale Bilinear', 'Fun Filter', 'Famous Me');
end
