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


function gray_image = mygrayfun(rgb_image)
    % Extract the red, green, and blue color channels.
    red_channel = rgb_image(:, :, 1);
    green_channel = rgb_image(:, :, 2);
    blue_channel = rgb_image(:, :, 3);

    % Calculate the grayscale image using the formula you provided.
    gray_image = 0.299 * red_channel + 0.578 * green_channel + 0.114 * blue_channel;
end
