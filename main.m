% This is the main function, that calls all the other related sub-functions
% that together implement Word Recognition. We divide the function into
% several parts to implement various stages.
% 
%% ================ Part 1: Reading and Resizing the image ================
%
% Loading the image from the required directory, resizing it and converting it into
% grayscale, and rectifying its boundaries.
for searchWordIndex = 0:4
    searchWordPath = sprintf('//home//kundusubhranil14//Dropbox//Summer 2019//WordSearching//Search Word//Dataset_ICDAR2015//q%04d.jpg',searchWordIndex);
    searchImage = imread(searchWordPath);
    searchImageLetter = 9;
    searchImageGray = rgb2gray(searchImage);
    searchImageRectified = ...
        minimalBoundaryImage(imbinarize(searchImageGray), searchImage); 

%% ===================== Part 2: Resizing the image =======================
%
% This portion of the code resizes the image, so that it's possible to do
% vertical zoning, with equal segments later on.
    [rows,cols] = size(searchImageRectified);
    noOfDiv = searchImageLetter;
    overlapColSize = 10;
    reqCols = resizeCols(cols, noOfDiv, overlapColSize);
    searchImageResize = ...
        imresize(searchImageRectified, [rows reqCols], 'nearest'); 
    %figure(1);
    %imshow(searchImageResize);
    searchImageResizeNeg = 255 - searchImageResize;
    % path = 'C:\\Users\\pc\\Dropbox\\Summer 2019\\WordSearching\\Papers\\Self\\BW_25.jpg';
    % imwrite(searchImageResizeNeg,path,'JPG');
    %figure(2);
    %imshow(searchImageResizeNeg);
%% =================== Part 3: Preprocessing the image ====================
%
% This part involves performing Contrast Normalisation and Main Zone
% Normalisation on the grayscaled Search Image. There are two variables
% returned by preProcessing.m, namely searchImagePP, that stores the
% preprocessed image and phi_c, which is the value of angle, corresponding
% to the central slope of the image. This is further followed by
% converting the image into black and white.
    % [searchImagePP, threshold, sd, phi_cs] = preProcessingNew(searchImageResize);
    % figure(1);
    % destPath = 'C:\\Users\\pc\\Dropbox\\Summer 2019\\WordSearching\\Papers\\Self\\MN_25.jpg';
    % imwrite(searchImagePP,destPath,'JPG');
    % imshow(mat2gray(searchImagePP));
      searchImagePP = imbinarize(searchImageResizeNeg);

%% ==================== Part 4: Vertical Zoning ===========================
%
% This section involves splitting the image, along the X-axis, into number
% of divisions equal to number of letters in the Search Word.
    zoneSearch = verticalZoneDivision(searchImagePP, noOfDiv, overlapColSize);

%% =================== Part 5: Feature Extraction =========================
%
% This part of the program calls function extractFeature.m and performs
% feature extraction on each zone of the preprocessed image, searchImagePP 
% previously obtained. This uses a modified version of the Projection of 
% Oriented Gradients, or mPOG.
    for i = 1:noOfDiv
        featureSearch(i,:) = houghFunction(zoneSearch(:,:,i));    
    end

% Initialising the Feature vector length, to be made use of later
    [~,featureLength] = size(featureSearch);

%% =================== Part 6: Feature Matching ===========================
%
% Loading the image from the required directory and converting it into
% grayscale and displaying it.
    numberOfWords = 3234;
    numOfZero = 0;
    index = 1; 
    scoreMat = zeros(numberOfWords,2);
    for wordIndex = 1:numberOfWords
            targetWordPath = ...
                sprintf('//home//kundusubhranil14//Dropbox//Summer 2019//WordSearching//To Search From//Dataset_ICDAR2015//w%04d.jpg',wordIndex);
            targetImage = imread(targetWordPath);
            targetImageGray = rgb2gray(targetImage);
%           targetImageGray = targetImage;
            [rows,cols] = size(targetImageGray);
            if (rows <= 20 || cols <= 20)
                numOfZero = numOfZero+1;
                continue
            end
            reqCols = resizeCols(cols, noOfDiv, overlapColSize);
            targetImageResize = imresize(targetImageGray, [rows reqCols], 'nearest');
            targetImageResizeNeg = 255 - targetImageResize;

% Pre-processing the Target Image, for Contrast Normalisation and Main Zone
% Normalisation
    %       [targetImagePP, threshold, sd, phi_ct] = preProcessingNew(targetImageResize);
    %       figure(2);
    %       imshow(mat2gray(targetImagePP));
            targetImagePP = imbinarize(targetImageResizeNeg);
% Dividing the Target Word Image into number of zones equal to the number
% of letters in the Search Word
            zoneTarget = verticalZoneDivision(targetImagePP, noOfDiv, overlapColSize);

% Performing feature extraction of the Target Image
            for i = 1:noOfDiv
                featureTarget(i,:) = houghFunction(zoneTarget(:,:,i));    
            end

% Calculating distance metric
            score = dtw(featureSearch,featureTarget);

% Storing in tabular format    
            scoreMat(wordIndex,1) = wordIndex;
            scoreMat(wordIndex,2) = score;
            scoreMatOld = scoreMat;
    end

% Declaring a new Score Matrix
    numberOfWordsRect = numberOfWords - numOfZero;
    scoreMatRect = zeros(numberOfWordsRect,2);
    for i = 1:numberOfWords
        if (scoreMat(i,1) ~= 0)
            scoreMatRect(index,1)=scoreMat(i,1);
            scoreMatRect(index,2)=scoreMat(i,2);
            index = index+1;
        end
    end

% Arranging the words according to matching score
    for i = 1:numberOfWordsRect-1
        for j = 1:numberOfWordsRect-1-i
            if ( scoreMatRect(j,2)>=scoreMatRect(j+1,2) )
                tempScore = scoreMatRect(j,2);
                tempIndex = scoreMatRect(j,1);
                scoreMatRect(j,2) = scoreMatRect(j+1,2);
                scoreMatRect(j,1) = scoreMatRect(j+1,1);
                scoreMatRect(j+1,2) = tempScore;
                scoreMatRect(j+1,1) = tempIndex;
            end
        end
    end
    for i = 1:30
        path = sprintf('//home//kundusubhranil14//Dropbox//Summer 2019//WordSearching//To Search From//Dataset_ICDAR2015//w%04d.jpg',scoreMatRect(i,1));
        reqImage = imread(path);
        destPath = sprintf('//home//kundusubhranil14//Dropbox//Summer 2019//WordSearching//Codes//Code Version 9b_C2C Matching Hough without BZ (16.08.19)//Result Images_ICDAR2015//SW%02d//w%02d.jpg',searchWordIndex,i);
        imwrite(reqImage,destPath,'JPG');
    end
end