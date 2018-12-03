function out = viterbiGeneral(in, poly,  hard, notail, batch, dim)
    if nargin < 5
        notail = 0;
    end
    % һ����ƽ��batch����
    % dim ά��
    % in��m*(l - 1)���������� Ч��1/m
    % polym*(k + 1)�Ķ���ʽ
    % ����״̬����2^k

    m = size(poly, 1);
    l = size(in, 2) + 1;
    k = size(poly, 2) - 1;
    % ������ʼ״̬���ܹ���̬�滮������aΪl * 2^k
    a = zeros(l, 2 ^ k);
    % pre�����¼ÿ��״̬�������ǰ��
    pre = zeros(l, 2 ^ k);
    % ��ʼ����������
    for i = 1: 2^k
        for j = 1: l
            a(j, i) = inf;
        end
    end
    % ���˳�ʼ��
    a(1, 1) = 0;
    
    
    % ѭ����������
    for i = 2: l
        
        %һά�Ͷ�ά�Ľӿں������Ƿ���ĳ����ƽ��Ӧ���������ƽ�ľ��룬Ԥ����֮
        for ii = 1: m
            %if dim == 1
            %    [~, preDis(ii, :)] = decide1D(batch, in(ii, i - 1), sigma, false);
            %else
                preDis(ii, :) = judge2d([real(in(ii, i - 1)), imag(in(ii, i - 1))], batch, false);
            %end
        end
            
        for j = 1: 2^k
            jBinary = toArr(j - 1, k);
            % jBinary ��jת���ɶ���������
            candidate = [];
            
            % p������ö����ǰ��ȥ��batchλ
            
            
            for p = 0: 2 ^ batch - 1
                pBinary = toArr(p, batch);
                supposed = [];
                % supposed����p�ļٶ���Ӧ������Ľ��
                for ii = 1: m
                    res = conv([pBinary', jBinary'], poly(ii, :));
                    supposed = [supposed, toInt(mod(res(k + 1: k + batch), 2)')];
                end
                %��ʵ�ʽ��in������룬hardָ���Ƿ�Ӳ�о�
                pBjB = [pBinary; jBinary];
                tmp = a(i - 1, toInt(pBjB(1: k)) + 1);
                for ii = 1: m
                    if ~hard
                        %���о���ֱ�ӵ���Ԥ��ľ���
                        tmp = tmp + preDis(ii, supposed(ii) + 1);
                    else
                        if dim == 1
                            [near, ~] = decide1D(batch, in(ii, i - 1), sigma, false);
                        else
                            near = judge2d([real(in(ii, i - 1)), imag(in(ii, i - 1))], batch,true);
                        end
                        near = toArr(near, batch);
                        tmp = tmp + sum(abs(near - toArr(supposed(ii), batch)));
                    end
                end

                candidate = [candidate, tmp];
            end
            % �Ӻ�ѡ�еó����ŵ�
            [a(i, j), pre(i, j)] = min(candidate);
        end
    end
    out = zeros(1, (l - 1) * batch);
    
    cur = zeros(k, 1);
    tailcur = 0;
    if notail == 1
        [~, cur] = min(a(l, :));
        tailcur = toArr(cur - 1, k);
        cur = tailcur;
        % ������β����Ҫ����β��
    end
    
    for i = l: -1: 2
        %ͨ��pre��ǰ���ݵõ��������
        out(1, i * batch - 2 * batch + 1: i * batch - batch) = toArr(pre(i, toInt(cur) + 1) - 1, batch)';
        pBjB = [toArr(pre(i, toInt(cur) + 1) - 1, batch); cur];
        cur = pBjB(1: k);
    end
    out = out(k + 1: (l - 1) * batch);
    if notail == 1
        out = [out, tailcur'];
    end
end