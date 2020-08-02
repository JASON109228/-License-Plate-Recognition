function bw = findblue(H, blue_minH, blue_maxH, threshS)
% bw = findblue(H, blue_minH, blue_maxH, threshS) �ж�ÿ�����ص��Ƿ�Ϊ��ɫ
% ���ص�Ϊ��ɫ�����ֵͼ��Ӧ��λ��Ϊ 1����֮Ϊ 0 

% bw ���صĶ�ֵͼ����ɫΪ1��
% H hsi�ռ��ͼ��
% blue_minH ��С��ɫ��ֵ����һ��ֵ��
% blue_maxH �����ɫ��ֵ����һ��ֵ��
% shreshS ��С���Ͷ�ֵ����һ��ֵ��


[a,b,c] = size(H);
bw = zeros(a, b);
for i1 = 1:a
    for j1 = 1:b
        if H(i1,j1,1)>=blue_minH && H(i1,j1,1)<=blue_maxH
            bw(i1,j1) = 1;
        else
            bw(i1,j1) = 0;
        end
    end
end
for i2 = 1:a
    for j2 = 1:b
        if bw(i2,j2) == 1
            if H(i2,j2,2) >= threshS
                bw(i2,j2) = 1;
            else
                bw(i2,j2) = 0;
            end
        end
    end
end

end