function I = clean(L, m, n)
% I = clean(L, m, n) ɾ�� L �е��ɣ�m, n��ָ����ͨ������Ϊ0��
% m ����������
% n ����������

a = size(m);
for i = 1 : a
    L(m(i), n(i)) = 0;
end
I = L;
end