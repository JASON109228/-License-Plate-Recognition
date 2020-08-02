function characters = LicPlateRec(character_image)


characters = '';
lib1 = '���򼽽����ɼ��ڻ�����������³ԥ�����������崨���Ʋ��¸�������';
% lib1 = '�ش����ʸӹ��ڻ������������³����������������������ԥ������';
lib2 = '1234567890ABCDEFGHJKLMNPQRSTUVWXYZ';

temp_char = character_image{1};
temp_char = temp_char(:)';
load('HAN_Theta1.mat');
load('HAN_Theta2.mat');
characters = strcat(characters, recognise(HAN_Theta1,HAN_Theta2, temp_char, lib1));

load('theta1.mat');
load('theta2.mat');
for i = 2:7
    temp_char = character_image{i};
    temp_char = temp_char(:)';
    characters = strcat(characters, recognise(Theta1, Theta2, temp_char, lib2));
end
end
