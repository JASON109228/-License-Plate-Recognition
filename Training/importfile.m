function importfile(fileToRead1)
%IMPORTFILE(FILETOREAD1)
%  ��ָ���ļ��е�������
%  FILETOREAD1:  Ҫ��ȡ���ļ�

%  �� MATLAB �� 18-Jul-2020 15:14:14 �Զ�����

% �����ļ�
newData1 = load('-mat', fileToRead1);

% �ڻ����������д���Щ�ֶδ����±�����
vars = fieldnames(newData1);
for i = 1:length(vars)
    assignin('base', vars{i}, newData1.(vars{i}));
end

