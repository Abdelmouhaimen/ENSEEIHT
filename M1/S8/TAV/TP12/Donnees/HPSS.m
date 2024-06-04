function [F_h, F_p] = HPSS(S)
n1 =17;
n2 = 17;
F_h = medfilt2(S,[1,n1]);
F_p = medfilt2(S,[n2,1]);

end

