using JuMP, Gurobi

function localisation_simple_relache(N,M,c,f)
    m = Model(Gurobi.Optimizer)
    set_silent(m)

    @variable(m,x[i = 1:N, j = 1:M] >= 0)
    @variable(m,y[j = 1:M] >= 0)
    @constraint(m, cover[i = 1:N], sum(x[i,j] for j in 1:M) == 1)
    @constraint(m, open[i = 1:N, j = 1:M], x[i,j] <= y[j])

    @objective(m, Min,  sum(c[i,j] * x[i,j] for i in 1:N, j in 1:M) + 
                        sum(f[j] * y[j] for j in 1:M))
    
    optimize!(m)

    v = [-shadow_price(cover[i]) for i = 1:N]

    # display(value(x))
    # display(value(y))

    println("Valeur objectif du problème relâché :")
    display(objective_value(m))

    return value(x), value(y), v, objective_value(m)
end

function arrondi(les_indices)
    affecte = [false for i = 1:N]

    C = 0
    for i in les_indices

        if !(affecte[i])

            affecte[i] = true
            cluster = [i]
            best_usine = -1
            best_usine_cost = Inf

            # Construire le cluster C_k
            for j in 1:M
                if x[i,j] > 0.1
                    if f[j] < best_usine_cost
                        best_usine_cost = f[j]
                        best_usine = j
                    end
                    for iprime in les_indices
                        if x[iprime,j] > 0.1 && !(affecte[iprime])
                            affecte[iprime] = true
                            push!(cluster,iprime)
                        end
                    end
                end
            end

            # Calculer le coût du cluster C_k
            C = C + best_usine_cost
            for iprime in cluster
                C = C + D[iprime,best_usine]
                println("Client $iprime assigné au cluster $best_usine")
            end
        end
    end

    return C
end