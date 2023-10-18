clc
close all;
clear;
tic;
[file,path]=uigetfile({'*.jpg;*.bmp;*.png;*.tif'},'Choose the image');
s=[path,file];
picture=imread(s);
figure
subplot(1,2,1)
imshow(picture)
picture = imresize(picture, [300, 500]);
picture=mygrayfun(picture);
figure
subplot(1,2,1)
imshow(picture)
ther = find_ther(picture) - 20;
picture = ~mybinaryfun(picture, ther);
subplot(1,2,2)
imshow(picture)

function gray_image = mygrayfun(image)
    red_channel = image(:, :, 1);
    green_channel = image(:, :, 2);
    blue_channel = image(:, :, 3);
    gray_image = 0.299 * red_channel + 0.578 * green_channel + 0.114 * blue_channel;
end

function binary_image = mybinaryfun(gray_image, threshold)
    binary_image = gray_image > threshold;
end

function thereshold = find_ther(image)
    thereshold = (min(image) + max(image)) / 2;
end    

