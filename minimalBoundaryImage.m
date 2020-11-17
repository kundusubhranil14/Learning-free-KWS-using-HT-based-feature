function [bgI] = minimalBoundaryImage(binaryImage,grayImage)
% MINIMALBOUNDARYIMAGE cuts the extra horizontal and vertical boundaries.
%
%   bgI = MINIMALBOUNDARYIMAGE(binaryImage, grayImage) takes in the
%   input image and removes the boundaries rows and columns that do
%   not contain a single data pixel.
%
%% ========================================================================

% Initialization of height and width
w = size(binaryImage,2);
h = size(binaryImage,1);
startRow = 1; endRow = h; 
startColumn = 1; endColumn = w;

% Lower Boundary for Binary Image
for i = 1:h
    for j = 1:w
        if (binaryImage(i,j) == 1)
            endRow = i;
        end
    end
end

% Upper Boundary for Binary Image
for i = h:-1:1
    for j = 1:w
        if (binaryImage(i,j) == 1)
            startRow = i;
        end
    end
end

% Right Boundary for Binary Image
for i = 1:w
    for j = 1:h
        if (binaryImage(j,i) == 1)
            endColumn = i;
        end
    end
end

% Left Boundary for Binary Image
for i = w:-1:1
    for j = 1:h
        if (binaryImage(j,i) == 1)
            startColumn = i;
        end
    end
end

if (sum(sum(binaryImage)) == 0)
    startRow = 1;
    endRow = h;
    startColumn = 1;
    endColumn = w;
end

% Initializing Boundary Rectified Gray and Binary Image
bgI = zeros(endRow-startRow+1, endColumn-startColumn+1,'uint8');
%bbI = zeros(endRow-startRow+1, endColumn-startColumn+1,'logical');

for i = startRow:endRow
    for j = startColumn:endColumn
        bgI(i-startRow+1,j-startColumn+1) = grayImage(i,j);  
        RbbI(i-startRow+1,j-startColumn+1) = binaryImage(i,j);
    end
end
end
