clc
clear

imgPath = 'D:\���ӿƴ��Ͽομ�\���ӿƴ��Ͽομ�\�ۺϿγ����\������ĸѵ����\4\';
imgDir = dir([imgPath '*.jpg']); % ��������jpg��ʽ�ļ�
k=1;
for i = 1:length(imgDir) % �����ṹ��Ϳ���һһ����ͼƬ��
    img = imread([imgPath imgDir(i).name]); %��ȡÿ��ͼƬ
    im = imresize(img,[32 16]);
    im1 = im2bw(im);
    im2 = reshape(im1,512,1);
    out = im2double(im2);
    shuzix4(k,:) = out;%�洢ͼ������;  
    shuziy4(k,1) =5;%�����ݼӱ�ǩ;  
    k = k + 1; 
end
save shuzix4.mat;
save shuziy4.mat;
