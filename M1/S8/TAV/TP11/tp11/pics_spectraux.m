function [pics_t, pics_f] = pics_spectraux(S, eta_t, eta_f, epsilon)


    se = strel('rectangle', [eta_f, eta_t]);

    S_dilated = imdilate(S, se);


    pics_maxima = (S == S_dilated) & (S > epsilon);


    [pics_f, pics_t] = find(pics_maxima);



end

