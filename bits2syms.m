function [out,key] = bits2syms(stream, bits, isEncrypt, encodeParam)
    % [out,key] = bits2syms(stream, bits, isEncrypt, encodeParam)
    % stream: ������ش�
    % bits: ÿ��ƽ����ı�����:
    % bits = 1 ->BPSK, bits = 2 ->4QAM, bits = 3 ->8PSK, bits = 4 - > 16QAM
    % isEncrypt: 1 -> ����, 0 -> ������
    % encodeParam: �������: 1 -> �����, 2 -> 1/2Ч��, 3 -> 1/3Ч��
    if isEncrypt
        if round(length(stream) / 240) ~= length(stream) / 240
            disp('length of stream must be a multiple of 240')
            out = 0;
            key = 0;
            return 
        end
        init();
        [kx, ky, key] = genKey();
        stream = encode(stream, kx, ky);
    else 
        key = 0;
    end
    para = struct('m', encodeParam, 'batch', bits, 'dim', 2);
    out0 = channel(stream, 0, para);
    out = zeros(1, size(out0,1)*size(out0,2));
    k = 1;
    for i=1:length(out0)
        for j=1:size(out0, 1)
            out(k) = out0(j,i);
            k = k + 1;
        end
    end            
end