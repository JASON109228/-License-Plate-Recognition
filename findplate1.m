function  plate_image = findplate1(car_im)
close all
clc
%% ���� point4 ���������ѡ�����������Ӿ��ε��ĸ���������
% lie �� 3*4 �ľ��� ÿ�д���һ����ѡ������ĸ������������
% hang ��3*4 �ľ���ÿ�д���һ����ѡ������ĸ������������
point4 = struct('lie',zeros(3,4),'hang',zeros(3,4),'top',0);

I = car_im;
[a, b, ~] = size(I);
%��ԭʼ��ɫͼ��ת��Ϊ�Ҷ�ͼ��
I1=rgb2gray(I);

%ʹ�ø�˹�˲�������Robert���ӱ�Ե��⣬����Ϊ0.15
I2=edge(I1,'roberts',0.15,'both');
figure(2),imshow(I2);title('robert���ӱ�Ե���');

%ͼ��ʴ����չʾ��ʴ���ͼ��
se=[1;1;1];
I3=imerode(I2,se);
figure(3),imshow(I3);title('��ʴ���ͼ��');


%����ṹԪ�أ��ó����ι���һ��se
se=strel('rectangle',[40,40]);
%��ͼ��ʵ�ֱ����㣬������Ҳ��ƽ��ͼ��������������뿪�����෴����һ���ں�խ��ȱ�ں�ϸ������ڣ�ȥ��С����������ϵķ�϶
I4=imclose(I3,se);

%�Ӷ�����ͼ�����Ƴ���������2000���ص����ӵ����
I5=bwareaopen(I4,2000);
I6=bwareaopen(I5,10000);
figure(4),imshow(I6);title('�Ӷ������Ƴ�С������ͼ��');
    %% Ѱ����ɫ��ͨ��
[L,number] = bwlabel(I6);
total = number;
%% ��ͨ��ɸѡ �� ɸѡ����ѡ��������
for i3 = 1 : number
    [r, c] = find(L == i3);
    x = length(r);
     
    % 3������ͨ������С��Ӿ��Σ���ɾ��������Ҫ�����ͨ��
    minbox = minBoundingBox([c'; r']); % ��С��Ӿ��ε��ĸ�����
    [phibox, Lbox, Hbox] = BoxFeature(minbox); % ��Ӿ��ε�����
    if phibox > 1 || Lbox < 2.68*Hbox || Lbox > 5*Hbox %��Ӿ��ε���б�ǶȺͳ����������������
        L = clean(L, r, c);
        total = total - 1;
        continue
    end
    if x < 0.5*Lbox*Hbox %��Ӿ����� ��ͨ�����̫С
        L = clean(L, r, c);
        total = total - 1;
        continue
    end
    
    % ����Ӿ��ε��ĸ�������� point4
    point4.top = point4.top + 1;
    point4.lie(point4.top, :) = minbox(1, :);
    point4.hang(point4.top, :) = minbox(2, :);
end
xx = round(point4.lie(1, :)); % ����������С��Ӿ��ε��ĸ���������
yy = round(point4.hang(1, :)); % ����������С��Ӿ��ε��ĸ���������
b1 = min(xx);
b2 = max(xx);
a1 = min(yy);
a2 = max(yy);
Ig = L(a1:a2, b1:b2);

H = rgb2hsi(I);     % HSI �ռ��ͼ��
minH = 160/360;     % H ��������Сֵ
maxH = 245/360;     % H ���������ֵ
threshS = 0.2;      % S ��������Сֵ
bw = findblue(H, minH, maxH,threshS);%�ж�ÿ�����ص��Ƿ�Ϊ��ɫ,���ص�Ϊ��ɫ�����ֵͼ��Ӧ��λ��Ϊ 1����֮Ϊ 0

bwIg = bw(a1:a2, b1:b2); % ��ͨͼ�еĳ�������

figure(5),imshow(bwIg);title('��ֵͼ�еĳ�������');

%���ҳ��Ƶ��ĸ����� ��45�ȵ�б��

% ���ϣ�
target = 0;
for i = 1 : a2-a1+1
    temp_sum = i+1;
    for j = 1:i
        k = temp_sum - j;
        if Ig(j,k) > 0
            p1 = [k,j]; % [��, ��]
            target = 1;
            break
        end
    end
    if target ==1
        break
    end
end

% ���ϣ�
target = 0;
for i = 1:a2-a1+1
    temp_sum = i+1;
    for j = 1:i
        k = temp_sum - j;
        k = b2 - b1 + 2 - k;
        if Ig(j,k) > 0
            p2 = [k,j]; % [��, ��]
            target = 1;
            break
        end
    end
    if target ==1
        break
    end
end

% ���£�
target = 0;
for i = 1:a2-a1+1
    temp_sum = i+1;
    for j = 1:i
        j1 = a2-a1+2 - j;
        k = temp_sum - j;
        if Ig(j1,k) > 0
            p3 = [k,j1]; % [��, ��]
            target = 1;
            break
        end
    end
    if target ==1
        break
    end
end

% ���£�
target = 0;
for i = 1:a2-a1+1
    temp_sum = i+1;
    for j = 1:i
        k = temp_sum - j;
        k = b2 - b1 + 2 - k;
        j1 = a2-a1+2 - j;
        if Ig(j1,k) > 0
            p4 = [k,j1]; % [��, ��]
            target = 1;
            break
        end
    end
    if target ==1
        break
    end
end
PP = [p1; p2; p3; p4]; %�ĸ����㣬����Ϊ�� ���� ���� ���� ����
plate_image = adjust(bwIg, PP); % ͸�ӻ������