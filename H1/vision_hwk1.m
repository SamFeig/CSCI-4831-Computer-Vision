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
              'Display Image', 'Brighten_L', 'Brighten_NL', ...
              'Invert_L', 'Invert_NL', 'Add Random Noise', ...
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
            brightness = -1000;
            while brightness < -255 || brightness > 255
                prompt = {'Input a Brightness Value (-255 to 255)'};
                dlgtitle = 'Input';
                input = inputdlg(prompt, dlgtitle);
                brightness = str2double(input{1});
            end
            
            outImg = makeBright_L(current_img, brightness);
            
            figure
            subplot(1, 2, 1)
            imagesc(current_img);
            subplot(1, 2, 2)
            imagesc(outImg);
            saveas(gcf,'MakeBright_L_Result.jpg')
        case 5
            % Brighten_NL
            brightness = -1000;
            while brightness < -255 || brightness > 255
                prompt = {'Input a Brightness Value (-255 to 255)'};
                dlgtitle = 'Input';
                input = inputdlg(prompt, dlgtitle);
                brightness = str2double(input{1});
            end
            
            outImg = makeBright_NL(current_img, brightness);
            
            figure
            subplot(1, 2, 1)
            imagesc(current_img);
            subplot(1, 2, 2)
            imagesc(outImg);
            saveas(gcf,'MakeBright_NL_Result.jpg')
        case 6
            % Invert_L
            outImg = invert_L(current_img);
            
            figure
            subplot(1, 2, 1)
            imagesc(current_img);
            subplot(1, 2, 2)
            imagesc(outImg);
            saveas(gcf,'Invert_L_Result.jpg')
        case 7
            % Invert_NL
            outImg = invert_NL(current_img);
            
            figure
            subplot(1, 2, 1)
            imagesc(current_img);
            subplot(1, 2, 2)
            imagesc(outImg);
            saveas(gcf,'Invert_NL_Result.jpg')
        case 8
            % AddRandomNoise
            outImg = addRandomNoise_NL(current_img);
            
            figure
            subplot(1, 2, 1)
            imagesc(current_img);
            subplot(1, 2, 2)
            imagesc(outImg);
            saveas(gcf,'AddRandomNoise_Result.jpg')
        case 9
            % Luminance
            outImg = luminance_L(current_img);
            
            figure
            subplot(1, 2, 1)
            imagesc(current_img);
            subplot(1, 2, 2)
            imagesc(outImg);
            colormap gray;
            saveas(gcf,'LuminanceFilter_Result.jpg')
        case 10
            % Red Filter
            redVal = -1;
            while redVal < 0 || redVal > 1
                prompt = {'Input a Red Value (0 to 1)'};
                dlgtitle = 'Input';
                input = inputdlg(prompt, dlgtitle);
                redVal = str2double(input{1});
            end
            
            outImg = redFilter(current_img, redVal);
            
            figure
            subplot(1, 2, 1)
            imagesc(current_img);
            subplot(1, 2, 2)
            imagesc(outImg);
            saveas(gcf,'RedFilter_Result.jpg')
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
            saveas(gcf,'BinaryMask_Result.jpg')
        case 12
            % Mean Filter
            kernel_size = -1;
            while kernel_size < 0 || mod(kernel_size, 2) == 0
                prompt = {'Input the Kernel Size (Positive Odd Number)'};
                dlgtitle = 'Input';
                input = inputdlg(prompt, dlgtitle);
                kernel_size = str2double(input{1});
            end
            
            outImg = meanFilter(current_img, kernel_size);
            
            figure
            subplot(1, 2, 1)
            imagesc(current_img);
            subplot(1, 2, 2)
            imagesc(outImg);
            saveas(gcf,'MeanFilter_Result.jpg')
        case 13
            % Frosty Filter
            n = -1;
            m = -1;
            
            while n < 1 || m < 1 || n > size(current_img, 1) || m > size(current_img, 2)
                prompt = {['Input a positive odd number between 1 and ' num2str(size(current_img, 1))] ['Input a positive odd number between 1 and ' num2str(size(current_img, 2))]};
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
            saveas(gcf,'FrostyFilter_Result.jpg')
        case 14
            % Scale Nearest
            factor = -1;
            while factor <= 0
                prompt = {'Input a Positive Scaling Factor'};
                dlgtitle = 'Input';
                input = inputdlg(prompt, dlgtitle);
                factor = str2double(input{1});
            end
            
            outImg = scaleNearest(current_img, factor);
            
            figure
            subplot(1, 2, 1)
            imagesc(current_img);
            subplot(1, 2, 2)
            imagesc(outImg);
            saveas(gcf,'ScaleNearest_Result.jpg')
        case 15
            % Scale Bilinear
            factor = -1;
            while factor <= 0
                prompt = {'Input a Positive Scaling Factor'};
                dlgtitle = 'Input';
                input = inputdlg(prompt, dlgtitle);
                factor = str2double(input{1});
            end
            
            outImg = scaleBilinear(current_img, factor);
            
            figure
            subplot(1, 2, 1)
            imagesc(current_img);
            subplot(1, 2, 2)
            imagesc(outImg);

            saveas(gcf,'ScaleBilinear_Result.jpg')
            
        case 16
            % Swirl/Fun Filter
            ox = -1;
            oy = -1;
            factor = -2;
            
            while factor < -1 || factor > 1 || ox <= 0 || ox > size(current_img, 1) || oy <= 0 || oy > size(current_img, 2)
                prompt = {'Input the factor value (-1 to 1)' ['Input the rotation origin x-value (1 to ' num2str(size(current_img, 1)) ')'] ['Input the rotation origin y-value (1 to ' num2str(size(current_img, 2)) ')']};
                dlgtitle = 'Input';
                input = inputdlg(prompt, dlgtitle);
                factor = str2double(input{1});
                ox = str2double(input{2});
                oy = str2double(input{3});
            end
    
            outImg = swirlFilter(current_img, factor, ox, oy);
            
            figure
            subplot(1, 2, 1)
            imagesc(current_img);
            subplot(1, 2, 2)
            imagesc(outImg);
            
            saveas(gcf,'FunFilter_Result.jpg')
        case 17
            % Famous Me
            [file,path] = uigetfile('*.*');
            if isequal(file,0)
               disp('User selected Cancel');
            else
               disp(['User selected ', fullfile(path,file)]);
            end
          
            famousImg = imread(fullfile(path,file));
            
            factor = -1;
            n = -1;
            m = -1;
            % factor > 0, n & m >= 1, 
            % n & m <= size(current_img, 1) - size(famousImg, 1) * factor
            % n, m must be at a location that still allows enough room to
            % place the famousImg inside the current_img
            while factor <= 0 || n < 1 || m < 1 || n > size(current_img, 1) - size(famousImg, 1) * factor || m > size(current_img, 2) - size(famousImg, 2) * factor
                prompt = {'Input a Positive Scaling Factor' ['Input a positive number between 1 and ' num2str(size(current_img, 1)) ' to place the image'] ['Input a positive number between 1 and ' num2str(size(current_img, 2)) ' to place the image']};
                dlgtitle = 'Input';
                input = inputdlg(prompt, dlgtitle);
                factor = str2double(input{1});
                n = str2double(input{2});
                m = str2double(input{3});
            end
            
            outImg = famousMe(current_img, famousImg, factor, n, m);

            figure
            subplot(1, 3, 1)
            imagesc(famousImg);
            subplot(1, 3, 2)
            imagesc(current_img);
            subplot(1, 3, 3)
            imagesc(outImg);
            saveas(gcf,'FamousMe_Result.jpg')

   end
   % Display menu again and get user's choice
   choice = menu('Choose an option', 'Exit Program', 'Load Image', ...
              'Display Image', 'Brighten', 'Brighten 2', ...
              'Invert', 'Invert 2', 'Add Random Noise', ...
              'Luminance', 'Red Filter', 'Binary Image', ...
              'Mean Filter', 'Frosty Filter', 'Scale Nearest', ...
              'Scale Bilinear', 'Fun Filter', 'Famous Me');
end
