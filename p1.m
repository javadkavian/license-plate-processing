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
picture = myremovecom(picture, 500);
subplot(1,3,1)
imshow(logical(picture))
background = myremovecom(picture, 3000);
picture = picture - background;
subplot(1, 3, 3)
imshow(picture);
[L, Ne] = mysegmentation(picture);
load trainingset;
num_of_letters = size(train, 2);

figure
output = [];
test = [];
for n=1:Ne
    [r, c] = find(L == n);
    Y = picture(min(r):max(r), min(c):max(c));
    Y = imresize(Y, [42, 24]);
    ro = zeros(1, num_of_letters);
    for k=1:num_of_letters
        ro(k) = corr2(train{1, k}, Y);
    end
    [max_cor, ind] = max(ro);
    if max_cor > .45
        out = cell2mat(train(2, ind));
        output = [output out];
    end
end
file = fopen('number_Plate.txt', 'wt');
fprintf(file,'%s\n',output);
fclose(file);
winopen('number_Plate.txt')
toc


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


function [out_picture,ther] = myremovecom(in_picture, n)
    [row, col] = find(in_picture == 1);
    points = [row';col'];
    obj_count = 1;
    points_count = size(points, 2);
    while points_count > 0
        initial_point = points(:, 1);
        points(:, 1) = [];
        [points, new_points] = close_points(initial_point, points);
        cur_obj = [initial_point new_points];
        new_points_len = size(new_points, 2);
        while new_points_len > 0
            new_points2 = [];
            for i = 1:new_points_len
                [points, new_points1] = close_points(new_points(:,i), points);
                new_points2 = [new_points2 new_points1];
            end
            cur_obj = [cur_obj new_points2];
            new_points = new_points2;
            new_points_len = size(new_points, 2);
        end
        obj{obj_count} = cur_obj;
        obj_count = obj_count + 1;
        points_count = size(points, 2);
    end
    obj_count = obj_count - 1;
    t = 1;
    for i = 1:obj_count
        if size(obj{i}, 2) > n
            new_obj{t} = obj{i};
            t = t + 1;
        end
    end
    ther = max(obj{i},2);
    out_picture = zeros(size(in_picture));
    for i = 1:t-1
        ind=sub2ind(size(in_picture),new_obj{i}(1,:),new_obj{i}(2,:));
        out_picture(ind) = 1;
    end
end


function [POINTS,newpoints]=close_points(point_ini,POINTS)

POINTS_NUM=size(POINTS,2);
diff= abs(repmat(point_ini,1,POINTS_NUM)-POINTS);
index=find(diff(1,:)<=1 & diff(2,:)<=1);
newpoints=POINTS(:,index);
POINTS(:,index)=[];
end

function [out_picture, num_objects] = mysegmentation(in_picture)
    [row, col] = find(in_picture == 1);
    points = [row'; col'];
    obj_count = 1;
    points_count = size(points, 2);
    while points_count > 0
        initial_point = points(:, 1);
        points(:, 1) = [];
        [points, new_points] = close_points(initial_point, points);
        cur_obj = [initial_point new_points];
        new_points_len = size(new_points, 2);
        while new_points_len > 0
            new_points2 = [];
            for i = 1:new_points_len
                [points, new_points1] = close_points(new_points(:, i), points);
                new_points2 = [new_points2 new_points1];
            end
            cur_obj = [cur_obj new_points2];
            new_points = new_points2;
            new_points_len = size(new_points, 2);
        end
        obj{obj_count} = cur_obj;
        obj_count = obj_count + 1;
        points_count = size(points, 2);
    end
    num_objects = obj_count - 1;
    out_picture = zeros(size(in_picture));
    for i = 1:num_objects
        ind = sub2ind(size(in_picture), obj{i}(1,:), obj{i}(2,:));
        out_picture(ind) = i;
    end
end
























