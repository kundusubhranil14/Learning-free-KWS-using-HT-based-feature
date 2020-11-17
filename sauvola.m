function [image_cn, threshold, sd] = sauvola(image, varArgIn)
% SAUVOLA implements Contrast Normalisation
%
%   image_cn = SAUVOLA(image, varargin) takes as the input arguments, the
%   input grayscale image, and the parameters for the Contrast
%   Normalisation. 
%
%% ========================================================================
%
% Initialization
numVarArgs = length(varArgIn);
[rows cols] = size(image);
image_cn = zeros(rows, cols);

% Checking that there are 3 optional inputs at most
if numVarArgs > 3
    error('myfuns:somefun2Alt:TooManyInputs', ...
     'Possible parameters are: (image, [m n], threshold, padding)');
end

% Setting defaults
optArgs = {[3 3] 0.14 'replicate'}; 
 
% Using memorable variable names
optArgs(1:numVarArgs) = varArgIn;   
[window, k, padding] = optArgs{:};

% Must be 2-dimensional image
if ndims(image) ~= 2
    error('The input image must be a two-dimensional array.');
end

% Converting to double
image = double(image);
% figure(4);
% imshow(mat2gray(image));

% Mean value
[mean, sd] = average(image, {window, padding});
% figure(5);
% imshow(mat2gray(mean));

% Standard deviation
% meanSquare = averageFilter(image.^2, {window, padding});
% figure(6);
% imshow(mat2gray(meanSquare));

% deviation = (meanSquare - mean.^2).^0.5;
% figure(7);
% imshow(mat2gray(deviation));

% Sauvola
R = 128; %max(deviation(:));
threshold = mean.*(1 - k * (1 - sd/R));
% threshold = mean + (k*sd);
% figure(8);
% imshow(mat2gray(threshold));

% image_cn = (image > threshold);
for i = 1:rows
    for j = 1:cols
        a = threshold(i,j) - (0.05 * sd(i,j));
        b = threshold(i,j) + (0.3 * sd(i,j));
        if ( image(i,j) <= a )
            image_cn(i,j) = 0;
        elseif ( (image(i,j) > a) && (image(i,j) <= b) )
            image_cn(i,j) = 255 * ((image(i,j) - a)/(b - a));
        elseif ( image(i,j) > b)
            image_cn(i,j) = 255;
        end
    end
end
% figure(9);
% imshow(mat2gray(image_cn));

end

