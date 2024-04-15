using LinearAlgebra
"""
Approximation de la solution du problème 

    min qₖ(s) = s'gₖ + 1/2 s' Hₖ s, sous la contrainte ‖s‖ ≤ Δₖ

# Syntaxe

    s = gct(g, H, Δ; kwargs...)

# Entrées

    - g : (Vector{<:Real}) le vecteur gₖ
    - H : (Matrix{<:Real}) la matrice Hₖ
    - Δ : (Real) le scalaire Δₖ
    - kwargs  : les options sous formes d'arguments "keywords", c'est-à-dire des arguments nommés
        • max_iter : le nombre maximal d'iterations (optionnel, par défaut 100)
        • tol_abs  : la tolérence absolue (optionnel, par défaut 1e-10)
        • tol_rel  : la tolérence relative (optionnel, par défaut 1e-8)

# Sorties

    - s : (Vector{<:Real}) une approximation de la solution du problème

# Exemple d'appel

    g = [0; 0]
    H = [7 0 ; 0 2]
    Δ = 1
    s = gct(g, H, Δ)

"""
function gct(g::Vector{<:Real}, H::Matrix{<:Real}, Δ::Real; 
    max_iter::Integer = 100, 
    tol_abs::Real = 1e-10, 
    tol_rel::Real = 1e-8)

    j = 0
    g0 = g
    gj = g0
    pj = -g
    sj = zeros(length(g))

    while (j<=max_iter) && norm(gj) > max(norm(g0)*tol_rel, tol_abs)
        kj = pj' * H * pj
        if kj <= 0
            a = (norm(pj)^2)
            b = (sj'*pj+pj'*sj)
            c = (norm(sj)^2-Δ^2)
            delta_equa = b^2 - 4 * a * c
            sigma1 = (-b+sqrt(delta_equa))/(2*a)
            sigma2 = (-b-sqrt(delta_equa))/(2*a)

            q(y) = g'*y+(1/2)*y'*H*y
            if q(sj + sigma1 * pj)<q(sj + sigma2 * pj)
                sigma = sigma1
            else
                sigma = sigma2
            end 
            sj = sj + sigma * pj
            break
        end
        alphaj = (gj' * gj) / kj
        if norm(sj+alphaj*pj)>=Δ
            a = (norm(pj)^2)
            b = (sj'*pj+pj'*sj)
            c = (norm(sj)^2-Δ^2)
            delta_equa = b^2 - 4 * a * c
            sigma1 = (-b+sqrt(delta_equa))/(2*a)
            sigma2 = (-b-sqrt(delta_equa))/(2*a)

            if sigma1>0
                sigma = sigma1
            elseif sigma2>0
                sigma = sigma2
            end 
            sj = sj + sigma * pj
            break
        end
        sj = sj + alphaj * pj
        gj1 = gj + alphaj * H * pj
        beta = (gj1' * gj1) / (gj' * gj)
        pj = -gj1 + beta * pj
        j = j + 1
        gj = gj1
    end


   return sj
end
