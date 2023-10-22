clc
clear
close all

directory = dir('trainingset');
st = {directory.name};
nam = st(3:end);
len = length(nam);

train = cell(2,len);
for i=1:len
   train(1,i)={imread(['trainingset','\',cell2mat(nam(i))])};
   temp=cell2mat(nam(i));
   train(2,i)={temp(1)};
end

save('trainingset.mat', 'train');
clear;