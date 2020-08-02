function bb = minBoundingBox(X)
% ����2άͼ�����С��Ӿ���

%����һ���ά�����С�߽��
%ʹ�ã�boundingBox=minBoundingBox�������
%���룺2x n���󣬰���n�����[x��y]����
%����������3���㲻����
%�����2x4���󣬰����߽��ǵ������ 


%����͹�ǣ�CH��X��2*k�����Ӽ��� 
k = convhull(X(1,:),X(2,:));
CH = X(:,k);


%����Ҫ���ԵĽǶȣ���CH�ߵĽǶȣ�������ʾ�����߿��һ�����͹����ǵı�Ե�� 
E = diff(CH,1,2);           % CH�� 
T = atan2(E(2,:),E(1,:));   % CH�ߵĽǶȣ�������ת�� 
T = unique(mod(T,pi/2));    % ��ΪΨһ�ĵ�һ���޽Ǽ�


%������ת�������а���T������*�Ƕȵ�2x2��ת����
%R��2n*2���� 
R = cos( reshape(repmat(T,2,2),2*length(T),2) ... %T�е��ظ��Ƕ�
       + repmat([0 -pi ; pi 0]/2,length(T),1));   %ת���������ҵ���λ�Ƕ�
RCH = R*CH;
%����߿��С[w1��h1��w2��h2������wn��hn]�Լ����п��ܱߵı߽������ 
bsize = max(RCH,[],2) - min(RCH,[],2);
area  = prod(reshape(bsize,2,length(bsize)/2));

%����С���
[a,i] = min(area);


%������ת֡�ϵĽ��ޣ���Сֵ�����ֵ�� 
Rf    = R(2*i+[-1 0],:);   % ��ת��� 
bound = Rf * CH;           % ����ת�Ŀ����ͶӰCH 
bmin  = min(bound,[],2);
bmax  = max(bound,[],2);

%����߽��Ľǵ�
Rf = Rf';
bb(:,4) = bmax(1)*Rf(:,1) + bmin(2)*Rf(:,2);
bb(:,1) = bmin(1)*Rf(:,1) + bmin(2)*Rf(:,2);
bb(:,2) = bmin(1)*Rf(:,1) + bmax(2)*Rf(:,2);
bb(:,3) = bmax(1)*Rf(:,1) + bmax(2)*Rf(:,2);