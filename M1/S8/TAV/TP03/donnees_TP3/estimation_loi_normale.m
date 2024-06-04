function [moyenne,variance] = estimation_loi_normale(echantillons)
    moyenne = mean(echantillons);
    variance = mean((echantillons - moyenne).^2);
end

