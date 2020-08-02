function [theta, L, H] = BoxFeature(X)
% [theta, L, H] = BoxFeature(X) ���ؾ����������
% ��L����H���Լ�L��ˮƽ�ߵļнǵ�����ֵtheta
% X Ϊ�����ĸ���������꣺��һ��Ϊˮƽ���꣬�ڶ���Ϊ��ֱ����
LH = zeros(1, 2);
for i = 1 : 2
    x1 = X(1, i);
    y1 = X(2, i);
    x2 = X(1, i+1);
    y2 = X(2, i+1);
    LH(1, i) = sqrt((x2-x1)^2+(y2-y1)^2);
end

if LH(1, 1) > LH(1, 2)
    L = LH(1, 1);
    H = LH(1, 2);
    theta = abs((X(2, 2)-X(2, 1))/(X(1, 2)-X(1, 1)));
else
    L = LH(1, 2);
    H = LH(1, 1);
    theta = abs((X(2, 3)-X(2, 2))/(X(1, 3)-X(1, 2)));
end

end