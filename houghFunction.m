function houghMat = houghFunction(input)
% HOUGHFUNCTION is a function that returns the max values of Hough Transform
% Matrix
%
%   houghMat = HOUGHFUNCTIOIN(input) takes an image as input and returns
%   the maximum values of the Hough Transform Matrix. It is a feature
%   extraction procedure, used on the input imge.
%
%% ========================================================================
%
[m n] = size(input);
if (m==0 || n==0)
    houghMat = zeros(1,12);
else
    H = hough(input, 'Theta', -90:15:89);
    houghMat = max(H);
end

