function bb = minBoundingBox(X)
% 计算2维图像的最小外接矩形

%计算一组二维点的最小边界框
%使用：boundingBox=minBoundingBox（点矩阵）
%输入：2x n矩阵，包含n个点的[x，y]坐标
%必须至少有3个点不共线
%输出：2x4矩阵，包含边界框角点的坐标 


%计算凸壳（CH是X的2*k矩阵子集） 
k = convhull(X(1,:),X(2,:));
CH = X(:,k);


%计算要测试的角度，即CH边的角度，如下所示：“边框的一侧包含凸面外壳的边缘” 
E = diff(CH,1,2);           % CH边 
T = atan2(E(2,:),E(1,:));   % CH边的角度（用于旋转） 
T = unique(mod(T,pi/2));    % 简化为唯一的第一象限角集


%创建旋转矩阵，其中包含T中所有*角度的2x2旋转矩阵
%R是2n*2矩阵 
R = cos( reshape(repmat(T,2,2),2*length(T),2) ... %T中的重复角度
       + repmat([0 -pi ; pi 0]/2,length(T),1));   %转换余弦正弦的移位角度
RCH = R*CH;
%计算边框大小[w1；h1；w2；h2；…；wn；hn]以及所有可能边的边界框区域 
bsize = max(RCH,[],2) - min(RCH,[],2);
area  = prod(reshape(bsize,2,length(bsize)/2));

%求最小面积
[a,i] = min(area);


%计算旋转帧上的界限（最小值和最大值） 
Rf    = R(2*i+[-1 0],:);   % 旋转框架 
bound = Rf * CH;           % 在旋转的框架上投影CH 
bmin  = min(bound,[],2);
bmax  = max(bound,[],2);

%计算边界框的角点
Rf = Rf';
bb(:,4) = bmax(1)*Rf(:,1) + bmin(2)*Rf(:,2);
bb(:,1) = bmin(1)*Rf(:,1) + bmin(2)*Rf(:,2);
bb(:,2) = bmin(1)*Rf(:,1) + bmax(2)*Rf(:,2);
bb(:,3) = bmax(1)*Rf(:,1) + bmax(2)*Rf(:,2);