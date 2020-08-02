function  plate_image = findplate1(car_im)
close all
clc
%% 变量 point4 储存各个待选车牌区域的外接矩形的四个顶点坐标
% lie ： 3*4 的矩阵 每行储存一个待选区域的四个顶点的列坐标
% hang ：3*4 的矩阵，每行储存一个待选区域的四个顶点的行坐标
point4 = struct('lie',zeros(3,4),'hang',zeros(3,4),'top',0);

I = car_im;
[a, b, ~] = size(I);
%将原始彩色图像转换为灰度图像
I1=rgb2gray(I);

%使用高斯滤波器来做Robert算子边缘检测，方差为0.15
I2=edge(I1,'roberts',0.15,'both');
figure(2),imshow(I2);title('robert算子边缘检测');

%图像腐蚀，并展示腐蚀后的图像
se=[1;1;1];
I3=imerode(I2,se);
figure(3),imshow(I3);title('腐蚀后的图像');


%构造结构元素，用长方形构造一个se
se=strel('rectangle',[40,40]);
%对图像实现闭运算，闭运算也能平滑图像的轮廓，但是与开运算相反，它一般融合窄的缺口和细长的弯口，去掉小洞，填补轮廓上的缝隙
I4=imclose(I3,se);

%从二进制图像中移除所有少于2000像素的连接的组件
I5=bwareaopen(I4,2000);
I6=bwareaopen(I5,10000);
figure(4),imshow(I6);title('从对象中移除小对象后的图像');
    %% 寻找蓝色连通区
[L,number] = bwlabel(I6);
total = number;
%% 连通区筛选 ： 筛选出待选车牌区域
for i3 = 1 : number
    [r, c] = find(L == i3);
    x = length(r);
     
    % 3：对连通区求最小外接矩形，并删除不满足要求的连通区
    minbox = minBoundingBox([c'; r']); % 最小外接矩形的四个顶点
    [phibox, Lbox, Hbox] = BoxFeature(minbox); % 外接矩形的特征
    if phibox > 1 || Lbox < 2.68*Hbox || Lbox > 5*Hbox %外接矩形的倾斜角度和长宽比例不符合特征
        L = clean(L, r, c);
        total = total - 1;
        continue
    end
    if x < 0.5*Lbox*Hbox %外接矩形内 连通区面积太小
        L = clean(L, r, c);
        total = total - 1;
        continue
    end
    
    % 将外接矩形的四个顶点存入 point4
    point4.top = point4.top + 1;
    point4.lie(point4.top, :) = minbox(1, :);
    point4.hang(point4.top, :) = minbox(2, :);
end
xx = round(point4.lie(1, :)); % 车牌区域最小外接矩形的四个点列坐标
yy = round(point4.hang(1, :)); % 车牌区域最小外接矩形的四个点行坐标
b1 = min(xx);
b2 = max(xx);
a1 = min(yy);
a2 = max(yy);
Ig = L(a1:a2, b1:b2);

H = rgb2hsi(I);     % HSI 空间的图像
minH = 160/360;     % H 参数的最小值
maxH = 245/360;     % H 参数的最大值
threshS = 0.2;      % S 参数的最小值
bw = findblue(H, minH, maxH,threshS);%判断每个像素点是否为蓝色,像素点为蓝色，则二值图相应的位置为 1，反之为 0

bwIg = bw(a1:a2, b1:b2); % 连通图中的车牌区域

figure(5),imshow(bwIg);title('二值图中的车牌区域');

%查找车牌的四个顶点 用45度的斜线

% 左上：
target = 0;
for i = 1 : a2-a1+1
    temp_sum = i+1;
    for j = 1:i
        k = temp_sum - j;
        if Ig(j,k) > 0
            p1 = [k,j]; % [列, 行]
            target = 1;
            break
        end
    end
    if target ==1
        break
    end
end

% 右上：
target = 0;
for i = 1:a2-a1+1
    temp_sum = i+1;
    for j = 1:i
        k = temp_sum - j;
        k = b2 - b1 + 2 - k;
        if Ig(j,k) > 0
            p2 = [k,j]; % [列, 行]
            target = 1;
            break
        end
    end
    if target ==1
        break
    end
end

% 左下：
target = 0;
for i = 1:a2-a1+1
    temp_sum = i+1;
    for j = 1:i
        j1 = a2-a1+2 - j;
        k = temp_sum - j;
        if Ig(j1,k) > 0
            p3 = [k,j1]; % [列, 行]
            target = 1;
            break
        end
    end
    if target ==1
        break
    end
end

% 右下：
target = 0;
for i = 1:a2-a1+1
    temp_sum = i+1;
    for j = 1:i
        k = temp_sum - j;
        k = b2 - b1 + 2 - k;
        j1 = a2-a1+2 - j;
        if Ig(j1,k) > 0
            p4 = [k,j1]; % [列, 行]
            target = 1;
            break
        end
    end
    if target ==1
        break
    end
end
PP = [p1; p2; p3; p4]; %四个顶点，依次为： 左上 右上 左下 右下
plate_image = adjust(bwIg, PP); % 透视畸变矫正