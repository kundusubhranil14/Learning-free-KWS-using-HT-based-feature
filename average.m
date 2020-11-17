function [imageMean, imageSD] = average(image, varArgIn)
% AVERAGEFILTER performs 2-dimensional mean filtering
%
%   [imageMean, imageSD] = AVERAGEFILTER(image, varargin) performs mean    
%   filtering of two dimensional matrix A with integral image method. Each   
%   output pixel contains the mean value of the 3-by-3 neighborhood, (or as  
%   specified by the user in calling function) around the corresponding 
%   pixel in the input image.
%
%% ========================================================================
%
% Parameter checking
numVarArgs = length(varArgIn);
if numVarArgs > 2
    error('myfuns:somefun2Alt:TooManyInputs', ...
        'requires at most 2 optional inputs');
end

% Setting defaults for optional inputs
optArgs = {[3 3] 0};            
optArgs(1:numVarArgs) = varArgIn;

% use memorable variable names
[window, padding] = optArgs{:}; 
m = window(1);
n = window(2);

% Checking for even window sizes
if ~mod(m,2)
    m = m-1; 
end       
if ~mod(n,2)
    n = n-1;
end

% Checking for color pictures
if (ndims(image)~=2)            
    display('The input image must be a two dimensional array.')
    display('Consider using rgb2gray or similar function.')
    return
end

% Initialization
[rows columns] = size(image);
imageMean = zeros(rows,columns);
imageSD = zeros(rows,columns);

% Padding the image
imageP  = padarray(image, [(m-1)/2 (n-1)/2], 'replicate', 'pre');
imagePP = padarray(imageP, [(m-1)/2 (n-1)/2], 'replicate', 'post');

% Calculating the sum
for i = 1:rows
    for j = 1:columns
        sum = 0;
        for rowSum = i:i+2
            for columnSum = j:j+2
                sum = sum + imagePP(rowSum,columnSum);
            end
        end
        imageMean(i,j) = sum/(m*n);
        sumSq = 0;
        for rowSum = i:i+2
            for columnSum = j:j+2
                sumSq = sumSq + ((imagePP(rowSum,columnSum) - imageMean(i,j))^2);
            end
        end
        imageSD(i,j) = sqrt(sumSq/(m*n));
    end
end

        


