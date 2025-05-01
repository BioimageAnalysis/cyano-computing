clearvars
clc

I = imread('D:\Projects\Research\biocomputer\data\2025-05-01 Taewoo\NewLocation_0hrs_ch1_150-800.bmp');
I = rgb2gray(I);

Ifilt = imtophat(I, strel('disk', 7));

imshowpair(I, Ifilt, 'montage')
return

%% Filter the image

%mask = imbinarize(Ifilt, 'adaptive', 'Sensitivity', 1);
mask = Ifilt > 2;
mask = imopen(mask, strel('disk', 2));

skel = bwskel(mask,'MinBranchLength', 10);

imshowpair(I, skel)
return


%%


I = I(ROI(3):ROI(4), ROI(1):ROI(2), :);

%%

Ianalyze = imcomplement(I(:, :, 1));
Ianalyze = medfilt2(Ianalyze, [2 2]);

%%
mask = imbinarize(Ianalyze, 'adaptive', 'Sensitivity', 0.59);

mask = imopen(mask, strel('disk', 1));
mask = imclearborder(mask);

showoverlay(I, mask)

%%
%mask = bwmorph(mask, 'skel');
skel = bwskel(mask,'MinBranchLength', 30);

%%
Iout = showoverlay(I, imdilate(skel, [1 1; 1 1]), 'color', [0 0 1]);
imshow(Iout)

imwrite(imresize(I, 0.5), '20250306 Colony 2.jpg')
imwrite(imresize(Iout, 0.5), '20250306 Colony 2 traced.jpg')

%imshow(I(:, :, 1))

%% Try with color

clearvars
clc

I = imread('../data/DSC_3291.JPG');

ROI = [1743, 4389, 998, 3392];
I = I(ROI(3):ROI(4), ROI(1):ROI(2), :);

colorMatch = [102 122 69]./255;
colorMatch_LAB = rgb2lab(colorMatch);

I_LAB = rgb2lab(I);

a = I_LAB(:,:,2);
b = I_LAB(:,:,3);

a = double(a);
b = double(b);
%distance = zeros(size(a));

distance = ( (a - colorMatch_LAB(2)).^2 + ...
      (b - colorMatch_LAB(3)).^2 ).^0.5;

distance = medfilt2(distance, [2 2]);

%%
mask = distance < 12;

mask = imopen(mask, strel('disk', 2));

showoverlay(I, mask)