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
function [dispMap] = disparitySSD(frameLeftGray, frameRightGray, kernal)
    
    




    [mL, nL, colorL] = size(frameLeftGray);
    [mR, nR, colorR] = size(frameRightGray);
    minSAD = VALUE_MAX;

    for x = 0:mL - mR
        for y = 0:nL - nR
            SSD = 0.0;

    %       loop through the template image
            for j = 0:mL
                for i = 0:nL

                    p_SearchIMG = frameLeftGray(y+i)(x+j);
                    p_TemplateIMG = frameRightGray(i)(j);
                    SAD += pow2(p_SearchIMG - p_TemplateIMG);
                end

    %         // save the best found position 
                if minSAD > SSD 
                    minSAD = SSD;
        %             // give me min SAD
                    position.bestRow = y;
                    position.bestCol = x;
                    position.bestSAD = SSD;
                end
            end
        end
    end
   
    
    
    
end

