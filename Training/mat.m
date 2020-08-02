clc
clear

imgPath = 'D:\电子科大上课课件\电子科大上课课件\综合课程设计\数字字母训练集\4\';
imgDir = dir([imgPath '*.jpg']); % 遍历所有jpg格式文件
k=1;
for i = 1:length(imgDir) % 遍历结构体就可以一一处理图片了
    img = imread([imgPath imgDir(i).name]); %读取每张图片
    im = imresize(img,[32 16]);
    im1 = im2bw(im);
    im2 = reshape(im1,512,1);
    out = im2double(im2);
    shuzix4(k,:) = out;%存储图像数据;  
    shuziy4(k,1) =5;%给数据加标签;  
    k = k + 1; 
end
save shuzix4.mat;
save shuziy4.mat;
