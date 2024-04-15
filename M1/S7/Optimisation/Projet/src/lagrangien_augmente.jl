using LinearAlgebra
include("../src/newton.jl")
include("../src/regions_de_confiance.jl")

function lagrangien_augmente(f::Function, gradf::Function, hessf::Function, 
        c::Function, gradc::Function, hessc::Function, x0::Vector{<:Real}; 
        max_iter::Integer=1000, tol_abs::Real=1e-10, tol_rel::Real=1e-8,
        λ0::Real=2, μ0::Real=10, τ::Real=2, algo_noc::String="rc-gct")

    x_sol = x0
    f_sol = f(x_sol)
    flag = -1
    nb_iters = 0
    μs = [μ0]
    λs = [λ0]

    beta            = 0.9
    η_constante     = 0.1258925 
    alpha           = 0.1 
    epsilon0        = 1 / μ0 
    η0              =(η_constante)/(μ0 ^ alpha)

    μk = μ0
    λk = λ0
    epsilonk = epsilon0
    ηk = η0

    while true


        La(x) = f(x) + λk' * c(x) + (μk/2) * (norm(c(x)))^2
        gradLa(x) = gradf(x) + λk' * gradc(x) + μk * gradc(x) * c(x)
        hessLa(x) = hessf(x) + λk' * hessc(x) + μk * hessc(x) * c(x) + μk * gradc(x) * (gradc(x))'

        if algo_noc == "newton"
            x_sol, _, _, _, _ = newton(La, gradLa, hessLa, x_sol)
        elseif algo_noc == "rc-cauchy"
            x_sol, _, _, _, _ = regions_de_confiance(La, gradLa, hessLa, x_sol, algo_pas="cauchy")
        elseif algo_noc == "rc-gct"
            x_sol, _, _, _, _ = regions_de_confiance(La, gradLa, hessLa, x_sol, algo_pas="gct")
        else
            error("Algorithme non valide")
        end

        if norm(gradf(x_sol) + λk'*gradc(x_sol)) <= max(epsilonk, tol_rel * norm(gradf(x0) + λ0'*gradc(x0)),tol_abs) && norm(c(x_sol)) <= max(tol_abs, tol_rel * norm(c(x0)))
            flag = 0
            break
          elseif nb_iters == max_iter
            flag = 1
            break
          end
  
          if norm(c(x_sol)) <= ηk 
            λk =  λk + μk * c(x_sol)
            μk=μk
            epsilonk = epsilonk / μk
            ηk = ηk / (μk ^ beta)
            
          else
            λk =  λk
            μk = τ*μk
            epsilonk = epsilon0 / μk
            ηk = η_constante / (μk ^ alpha)
          end

        nb_iters += 1
        μs = vcat(μs, [μk])
        λs = vcat(λs, [λk])
    end

    return x_sol, f_sol, flag, nb_iters, μs, λs
end
