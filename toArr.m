% ������Ҳ���������� �������Լ�д����
function code = toArr(in, k)
% ����ת������
    code = zeros(k, 1);
    for kk = 1: k
        code(kk, 1) = bitand(bitshift(in, 1 - kk), 1);
    end
end