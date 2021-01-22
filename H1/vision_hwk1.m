% This script creates a menu driven application

%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Sam Feig 
% Vladimir Zhdanov
%
% CSCI 4831/5722
% Homework 1
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
           image_choice = menu('Choose an image', 'lena1', 'mandril1', 'sully', 'yoda', 'shrek', 'red balloon', 'wrench1');
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
               case 6
                   filename = 'redBaloon.jpg';
               case 7
                   filename = 'wrench1.jpg';
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
            % Brighten_L
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
        case 5
            % Brighten_NL
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
            % Invert_L
            outImg = invert_L(current_img);
            
            figure
            subplot(1, 2, 1)
            imagesc(current_img);
            subplot(1, 2, 2)
            imagesc(outImg);
        case 7
            % Invert_NL
            outImg = invert_NL(current_img);
            
            figure
            subplot(1, 2, 1)
            imagesc(current_img);
            subplot(1, 2, 2)
            imagesc(outImg);
        case 8
            % AddRandomNoise
            outImg = addRandomNoise_NL(current_img);
            
            figure
            subplot(1, 2, 1)
            imagesc(current_img);
            subplot(1, 2, 2)
            imagesc(outImg);
        case 9
            % Luminance
            outImg = luminance_L(current_img);
            
            figure
            subplot(1, 2, 1)
            imagesc(current_img);
            subplot(1, 2, 2)
            imagesc(outImg);
            colormap gray;
        case 10
            % Red Filter
            prompt = {'Input a Red Value (0 to 1)'};
            dlgtitle = 'Input';
            input = inputdlg(prompt, dlgtitle);
            redVal = str2double(input{1});
            
            outImg = redFilter(current_img, redVal);
            
            figure
            subplot(1, 2, 1)
            imagesc(current_img);
            subplot(1, 2, 2)
            imagesc(outImg);
        case 11
            % Binary Image
            if size(current_img, 3) > 1
                current_img = luminance_L(current_img);
            end
            outImg = binaryMask(current_img);
            
            figure
            subplot(1, 2, 1)
            imagesc(current_img);
            subplot(1, 2, 2)
            imagesc(outImg);
            colormap gray;
        case 12
            % Mean Filter
            prompt = {'Input the Kernel Size'};
            dlgtitle = 'Input';
            input = inputdlg(prompt, dlgtitle);
            kernel_size = str2double(input{1});
            
            outImg = meanFilter(current_img, kernel_size);
            
            figure
            subplot(1, 2, 1)
            imagesc(current_img);
            subplot(1, 2, 2)
            imagesc(outImg);
        case 13
            % Frosty Filter
            n = -1;
            m = -1;
            
            while n < 1 || m < 1 || n > size(current_img, 1) || m > size(current_img, 2)
                prompt = {['Input a positive number between 1 and ' num2str(size(current_img, 1))] ['Input a positive number between 1 and ' num2str(size(current_img, 2))]};
                dlgtitle = 'Input';
                input = inputdlg(prompt, dlgtitle);
                n = str2double(input{1});
                m = str2double(input{2});
            end
            
            outImg = frosty(current_img, n, m);
            
            figure
            subplot(1, 2, 1)
            imagesc(current_img);
            subplot(1, 2, 2)
            imagesc(outImg);
        case 14
            % Scale Nearest
            prompt = {'Input a positive Scaling Factor'};
            dlgtitle = 'Input';
            input = inputdlg(prompt, dlgtitle);
            factor = str2double(input{1});
            
            outImg = scaleNearest(current_img, factor);
            
            figure
            subplot(1, 2, 1)
            imagesc(current_img);
            subplot(1, 2, 2)
            imagesc(outImg);
        case 15
            % Scale Bilinear
            prompt = {'Input a positive Scaling Factor'};
            dlgtitle = 'Input';
            input = inputdlg(prompt, dlgtitle);
            factor = str2double(input{1});
            
            outImg = scaleBilinear(current_img, factor);
            
            figure
            subplot(1, 2, 1)
            imagesc(current_img);
            subplot(1, 2, 2)
            imagesc(outImg);
            
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
