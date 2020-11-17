function reqCols = resizeCols(cols, noOfDiv, overlapColSize)
% RESIZECOLS adjusts the number of columns of the image.
%   
%   reqCols = RESIZECOLS(cols, noOfDiv, overlapColSize) takes the 
%   number of columns, required, number of Target Divisions and Overlapping 
%   Window Size, as input, and accordingly, returns the required number of 
%   columns, for proper Vertical Zone Division.
%
%% ========================================================================
%
% Initializing important variables
totalColsLost = (noOfDiv - 1) * overlapColSize;
colsWithoutOverlap = totalColsLost + cols;
reqColsWithoutOverlap = colsWithoutOverlap;

% Calculating required no of columns
if (mod(colsWithoutOverlap,noOfDiv) ~= 0)
    for i = (colsWithoutOverlap + 1):(colsWithoutOverlap + noOfDiv - 1)
        if (mod(i,noOfDiv)==0)
            reqColsWithoutOverlap = i;
            break;
        end
    end
end
reqCols = reqColsWithoutOverlap - totalColsLost;

end

