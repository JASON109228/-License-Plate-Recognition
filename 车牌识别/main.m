clc
clear
for img_no =4:4
    src_dir = 'N ';
    img_ext = '.JPG';
    
    % Read and display the car image
    filename = strcat(src_dir,num2str(img_no),img_ext);
    car_im= imread(filename);
%   car_im = baoguang(car);
    figure(1), imshow(car_im),title('ԭʼͼ��') % ��ʾ������ͼ��
    
    % License plate location
%     plate_im = LicPlateLoc(car_im);
    H = rgb2hsi(car_im);     % HSI �ռ��ͼ��
    minH = 160/360;     % H ��������Сֵ
    maxH = 245/360;     % H ���������ֵ
    threshS = 0.2;      % S ��������Сֵ
    bw = findblue(H, minH, maxH,threshS);
    b=sum(sum(bw==1));
    ratio=b/numel(bw);
    if(ratio>0.10)
        plate_im = findplate1(car_im);  
        
    else
        plate_im = LicPlateLoc(car_im);       
    end
    if plate_im == -1
        characters ={'���ƶ�λʧ��'};
        disp('���ƶ�λʧ��');
        continue
    else
        figure(6), imshow(plate_im),title('��λ�������ͼƬ'); % ��ʾ���ƶ�λ���
    end  
    
    % License plate character segmentation
    character_im = LicPlateSeg(plate_im);
  
    if size(character_im, 2) == 1
        characters={'���Ʒָ�ʧ��'};
        disp('���Ʒָ�ʧ��');
        continue
    else 
        figure(10), % ��ʾ�ַ��ָ���
        subplot(1,7,1), imshow(character_im{1});title('�ַ�1')
        subplot(1,7,2), imshow(character_im{2});title('�ַ�2')
        subplot(1,7,3), imshow(character_im{3});title('�ַ�3')
        subplot(1,7,4), imshow(character_im{4});title('�ַ�4')
        subplot(1,7,5), imshow(character_im{5});title('�ַ�5')
        subplot(1,7,6), imshow(character_im{6});title('�ַ�6')
        subplot(1,7,7), imshow(character_im{7});title('�ַ�7')
    end
%     
    % License plate character recognition
    characters = LicPlateRec(character_im);
    jieguo(img_no)={characters};
    disp(characters)
end
% write_total_tu={};
% for img_no = 1:30
%     write_total_tu =[write_total_tu,jieguo(img_no)];
% end
% write_total_tu = [write_total_tu]';
% xlswrite('shuju.xlsx',write_total_tu,'Sheet2','A2:A31')