function zones = verticalZoneDivision(image_p,noOfDiv,overlapColSize)
% VERTICALZONEDIVISION divides the entire word into several sections or  
% zones, along the X-axis.
%
%   zones = VERTICALZONEDIVISION(image_p,noOfDiv,overlapColSize)   
%   takes the preprocessed image, number of divisions, density and  
%   overlapping columns size as input. These zones are overlapping in 
%   nature.
%
%% ========================================================================
%
% Initialising Window Sizes and Zone Width
[r,cols] = size(image_p);
totalColsLost = (noOfDiv - 1) * overlapColSize;
colsWithoutOverlap = totalColsLost + cols;
zoneWidth = colsWithoutOverlap / noOfDiv;

% Initializing required 3D Array
zones = zeros(r, zoneWidth, noOfDiv);

% Splitting the image into zones
for i = 1:noOfDiv
    endIndex = ((zoneWidth - overlapColSize)*i) + overlapColSize;
    startIndex = endIndex - (zoneWidth - 1);
    zones(:,:,i) = image_p(:,startIndex:endIndex);
end

end