function [image_p, threshold, sd, slope_theta] = preProcessingNew(image)

% PREPROCESSINGNEW implements Contrast Normalisation and Main Zone Normali-
% sation
%   [image_p, slope_theta] = PREPROCESSINGNEW(image) takes the original  
%   image as input and performs Sauvola's Binarization, following the Main  
%   Zone Normalisation on the image.
%
%% ===================== Part a: Contrast Normalisation ===================
%
% If Intensity value is outside range of a and b, then pixel is hard
% assigned to foreground or background. Else, the pixel intensity is given
% by I_cn = (I-a) / (b-a), if I_cn is the contrast normalised image
% intensity at that point adn I is the original intensity.

% Finding the negative of the image as it is useful, keeping with our
% convention for Sauvola's Binarization
image = 255 - image;
[m,n] = size(image);
image_cn = zeros(m,n);

% Calling the function sauvola.m to perform Contrast Normalization
[image_cn, threshold, sd] = sauvola(image, {[3 3], 0.14, 'replicate'});
%figure(1);
%imshow((image_cn));
% Replacing NaN by 0
for i = 1:m
    for j = 1:n
        if ( isnan(image_cn(i,j)) )
            image_cn(i,j) = 0;
        end
    end
end

%% ===================== Part b: Main Zone Normalisation ==================
% 
% The main zone normalisation is a crucial step, and involves identifying
% the upperline and the baseline. This is done using the horizontal
% projection of the Image intensty, with respect to a certain range of
% angles using the Radon Transform

% Taking the limit of theta from -8 to 8 degrees and declaring useful
% variables
theta = [-8, -7, -6, -5, -4, -3, -2, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8];

% Taking msf and meh as the maximum sum so far, and the maximum
% ending here, and a and b as corresponding starting and ending index,
% Radon Transform is implemented. p is chosen to be the parameter for the
% difference between the upper and base levels. arr holds column values,
% corresponding to each theta, arr_scl holda the scaled values, arr_s has
% the value of the sum of total elements in the array, and arrmax_s holds 
% the sum of the largest contiguous subarray. J vector is used to hold the
% max values corresponding to each angle in the range of theta.  
R = radon(image_cn,theta);
[r,c] = size(R);
arr = zeros(r,1);
J = zeros(c,1);
for j = 1:c
    arr = R(:,j);
    a = 1;
    b = 1 ;
    temp = 1;
    p = (sum(arr.^2))/((sum(arr))^2);
    arr_s = sum(arr); 
    msf = intmin; meh = 0;
    for i = 1:r 
        meh = meh + arr(i) - (p * ((i-temp)/r));
        if msf < meh
            msf = meh;
            a = temp;
            b = i;
        end
        if meh < 0
            meh = 0;
            temp = i+1;
        end
    end
    arrmax_s = msf;
    J(j) = arrmax_s/(0.95*arr_s);
end

% That value of theta, which gives the maximum value of J is identified as
% the slope angle
[~,thetamax_ind] = max(J);
slope_theta = theta(thetamax_ind);

% Having found this angle, the intention now is to de-skew the given image,
% thereby obtaining the main zone normalised image
tform = affine2d([cosd(slope_theta) -sind(slope_theta) 0; ...
                    sind(slope_theta) cosd(slope_theta) 0; ...
                    0 0 1]);
image_mn = imwarp(image_cn, tform);
% figure(10);
% imshow(mat2gray(image_mn));

image_p = imresize(image_mn, [m n], 'nearest');
end
