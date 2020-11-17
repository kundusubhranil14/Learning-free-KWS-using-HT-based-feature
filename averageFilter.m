function image = averageFilter(image, varArgIn)
% AVERAGEFILTER performs 2-dimensional mean filtering
%
%   image = AVERAGEFILTER(image, varargin) performs mean filtering of two  
%   dimensional matrix A with integral image method. Each output pixel  
%   contains the mean value of the 3-by-3 neighborhood around the 
%   corresponding pixel in the input image. 
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

% Padding the image
imageP  = padarray(image, [(m+1)/2 (n+1)/2], padding, 'pre');
% figure(2);
% imshow(mat2gray(imageP));
imagePP = padarray(imageP, [(m-1)/2 (n-1)/2], padding, 'post');
% figure(3);
% imshow(mat2gray(imagePP));
% Using double because uint8 would be too small
imageD = double(imagePP);
% figure(2);
% imshow(mat2gray(imageD));
% Matrix 't' is the sum of numbers on the left and above the current cell
t = cumsum(cumsum(imageD),2);

% Calculating the mean values from the look up table 't'.
imageI = t(1+m:rows+m, 1+n:columns+n) + t(1:rows, 1:columns)...
    - t(1+m:rows+m, 1:columns) - t(1:rows, 1+n:columns+n);

% Now each pixel contains sum of the window, so the average value would be:
imageI = imageI/(m*n);
% figure(5);
% imshow(mat2gray(imageI));

% Returning matrix in the original type class.
image = cast(imageI, class(image));
% figure(3);
% imshow(mat2gray(image));

end

