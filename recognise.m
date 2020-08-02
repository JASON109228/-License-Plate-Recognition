function ch = recognise(Theta1, Theta2, X, lib)

% �����Ѿ�ѵ���õ�������Ĳ���Theta1��Theta2����X����ʶ��


m = size(X, 1);

h1 = sigmoid([ones(m, 1) X] * Theta1');
h2 = sigmoid([ones(m, 1) h1] * Theta2');
[~, p] = max(h2, [], 2);

ch = lib(p);
end
