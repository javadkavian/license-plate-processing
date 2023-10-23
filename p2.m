clc
close all;
clear;
[file, path] = uigetfile('*.jpg;*.png;*.jpeg;*.bmp');
picture = imread([path, file]);
picture = rgb2gray(picture);
ther = graythresh(picture);
picture = ~imbinarize(picture, ther);
picture = imresize(picture, [600, 800]);
picture = bwareaopen(picture, 6000);
background = bwareaopen(picture, 20000);
picture = picture - background;
[L, Ne] = bwlabel(picture);
load trainingset;
file = fopen('number_Plate_Persian.txt', 'wt');
output = [];
numOfLetters = size(train, 2);
for n=1:Ne
    [r, c] = find(L == n);
    Y = picture(min(r):max(r), min(c):max(c));
    ro = zeros(1, numOfLetters);
    for k = 1:numOfLetters
        [row, col] = size(train{1,k});
        Y = imresize(Y, [row, col]);
        ro(k) = corr2(train{1,k},Y);
    end
    [MAXRO, pos] = max(ro);
    if MAXRO>.45
        out = cell2mat(train(2,pos));       
        output = [output out];
        fprintf(file,'%s\n', out);
    end
end
fclose(file);
winopen('number_Plate_Persian.txt')
toc
