function paires = appariement(pics_t, pics_f, n_v, delta_t, delta_f)

    paires = [];

    n = length(pics_t);

    for i=1:n
        n_v_count = 0;
        for j=2:n
            if n_v_count<n_v
                if (abs(pics_f(i) - pics_f(j))<=delta_f) && ((pics_t(j) - pics_t(i))<=delta_t) && ((pics_t(j) - pics_t(i))>0)
                    paires = [paires ; pics_f(i) pics_f(j) pics_t(i) pics_t(j)];
                    n_v_count = n_v_count +1;
                end
            else
                break;
            end
        end
    end



end

