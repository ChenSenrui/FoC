function out = toInt(arr)
% ������ת����
    out = 0;
    for i = 1: size(arr, 1)
        out = out + arr(i, 1) * 2 ^ (i - 1);
    end
end