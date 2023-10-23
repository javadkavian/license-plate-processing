clc
close all;
clear;

load trainingset;

[file, path] = uigetfile('*.jpg;*.png;*.jpeg;*.bmp');
picture = imread([path, file]);
picture = rgb2gray(picture);
threshold =  graythresh(picture);
picture = ~imbinarize(picture, threshold-0.1);
width = 600;
length = 800;
picture = imresize(picture, [width, length]);
picture = bwareaopen(picture, 50); 
picture = picture - bwareaopen(picture, 2000);
maximum_horizental_changes = 0;
maximum_vertical_changes = 0;
y_max_changes = 1;
x_max_changes = 1;
horizental_changes_count = zeros(1, width);
vertical_changes_count = zeros(1, length);

for i=1: width
    changes_count = 0;
    for j=1: length - 1
        if picture(i, j + 1) ~= picture(i, j)
            changes_count = changes_count + 1;
        end
    end
    horizental_changes_count(i) = changes_count;
    if changes_count > maximum_horizental_changes && i > 300 && i < 500
        maximum_horizental_changes = changes_count;
        y_max_changes = i;
    end
end

down_bound = width - 100;
up_bound = 100;

right_bound = length - 100;
left_bound = 100;

for i=100: y_max_changes
    if abs(horizental_changes_count(i) - maximum_horizental_changes) < 20 && y_max_changes - i < 50
        up_bound = i;
        break;
    end
end    

for i=width - 100:-1: y_max_changes
    if abs(horizental_changes_count(i) - maximum_horizental_changes) < 20 && i - y_max_changes < 50
        down_bound = i;
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
    vertical_changes_count(i) = changes_count;
    if changes_count > maximum_vertical_changes && j > 300 && j < 500
        maximum_vertical_changes = changes_count;
        x_max_changes = j;
    end
end

for j=220: x_max_changes
    if abs(vertical_changes_count(j) - maximum_vertical_changes) < 40 && x_max_changes - j < 300
        left_bound = j;
        break;
    end
end

for j=length - 200:-1: x_max_changes
    if abs(vertical_changes_count(j) - maximum_vertical_changes) < 40 && j - x_max_changes < 300
        right_bound = j;
        break;
    end
end

width_of_picture = down_bound - up_bound;

if width_of_picture < 50
    down_bound = down_bound + 90 - width_of_picture;
end

picture = picture(up_bound:down_bound,left_bound:right_bound);
picture = bwareaopen(picture, 100);
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
winopen('number_Plate_Persian.txt');















