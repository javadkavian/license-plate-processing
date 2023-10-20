clc
close all;
clear;
[file,path]=uigetfile({'*.jpg;*.bmp;*.png;*.tif'},'Choose the image');
s=[path,file];
picture=imread(s);
picture=imresize(picture,[300 500]);
picture=rgb2gray(picture);%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
threshold = graythresh(picture);
picture =~imbinarize(picture,threshold);
P=500;
pic1=bwareaopen(picture,P);
subplot(3,1,1)
imshow(picture)
subplot(3,1,2)
imshow(pic1)


[row,column]=find(picture==1);
POINTS=[row';column'];
current_obj_num=1;
POINTS_NUM=size(POINTS,2);

while POINTS_NUM>0
    
   point_ini=POINTS(:,1);  
   POINTS(:,1)=[];
   [POINTS,newpoints]=close_points(point_ini,POINTS);
   current_obj=[point_ini newpoints];
   newpoints_len=size(newpoints,2);
   
   while newpoints_len>0
       newpoints2=[];
   for i=1:newpoints_len
       [POINTS,newpoints1]=close_points(newpoints(:,i),POINTS);
        newpoints2=[newpoints2 newpoints1];
   end
       current_obj=[current_obj newpoints2];
       newpoints=newpoints2;
       newpoints_len=size(newpoints,2);
   end
   
   OBJECT{current_obj_num}=current_obj;
   current_obj_num=current_obj_num+1;
   POINTS_NUM=size(POINTS,2);
end

% OBJECT_NEW
z=1;
current_obj_num=current_obj_num-1;
for i=1:current_obj_num
    if size(OBJECT{i},2)>P
        OBJECT_NEW{z}=OBJECT{i};
        z=z+1;
    end
end
display(current_obj_num);
PIC2=zeros(size(picture));
ind=sub2ind(size(picture),OBJECT_NEW{1}(1,:),OBJECT_NEW{1}(2,:));
PIC2(ind)=1;
subplot(3,1,3)
imshow(logical(PIC2))





function [POINTS,newpoints]=close_points(point_ini,POINTS)

POINTS_NUM=size(POINTS,2);
diff= abs(repmat(point_ini,1,POINTS_NUM)-POINTS);
index=find(diff(1,:)<=1 & diff(2,:)<=1);
newpoints=POINTS(:,index);
POINTS(:,index)=[];
end
