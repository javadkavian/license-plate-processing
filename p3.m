clc
close all;
clear;

load trainingset;

[file, path] = uigetfile('*.jpg;*.png;*.jpeg;*.bmp');
picture = imread([path, file]);
picture = rgb2gray(picture);
imshow(picture);
threshold =  graythresh(picture);
picture = ~imbinarize(picture, threshold-0.1);
imshow(picture);
width = 600;
length = 800;
picture = imresize(picture, [width, length]);
picture = bwareaopen(picture, 60); 
imshow(picture);
picture = picture - bwareaopen(picture, 1670);
imshow(picture);

max_rows_changes = 0;
max_cols_changes = 0;
y_max_changes = 1;
x_max_changes = 1;
rows_changes_count = zeros(1, width);
cols_changes_count = zeros(1, length);

for i=1: width
    changes_count = 0;
    for j=1: length - 1
        if picture(i, j + 1) ~= picture(i, j)
            changes_count = changes_count + 1;
        end
    end
    rows_changes_count(i) = changes_count;
    if changes_count > max_rows_changes && i > 340 && i < 500
        max_rows_changes = changes_count;
        y_max_changes = i;
    end
end

y_down = width - 100;
y_top = 100;

x_right = length - 100;
x_left = 100;

for i=100: y_max_changes
    if abs(max_rows_changes - rows_changes_count(i)) < 20 && y_max_changes - i < 50
        y_top = i;
        break;
    end
end    

for i=width - 100:-1: y_max_changes
    if abs(max_rows_changes - rows_changes_count(i)) < 20 && i - y_max_changes < 50
        y_down = i;
        break;
    end
end

for j=1: length
    changes_count = 0;
    for i=1: width - 1
        if picture(i + 1, j) ~= picture(i, j)
            changes_count = changes_count + 1;
        end
    end
    cols_changes_count(i) = changes_count;
    if changes_count > max_cols_changes && j > 300 && j < 400
        max_cols_changes = changes_count;
        x_max_changes = j;
    end
end

for j=220: x_max_changes
    if abs(max_cols_changes - cols_changes_count(j)) < 30 && x_max_changes - j < 230
        x_left = j;
        break;
    end
end

for j=length - 200:-1: x_max_changes
    if abs(max_cols_changes - cols_changes_count(j)) < 30 && j - x_max_changes < 300
        x_right = j;
        break;
    end
end

delta_y = y_down - y_top;

if delta_y < 60
    y_down = y_down + 80 - delta_y;
end

plate = picture(y_top:y_down,x_left:x_right);
imshow(plate);