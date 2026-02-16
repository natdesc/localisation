using JuMP, Gurobi

function localisation_simple(N,M,c,f)
    m = Model(Gurobi.Optimizer)
    set_silent(m)

    @variable(m,x[i = 1:N, j = 1:M] >= 0)
    @variable(m,y[j = 1:M], Bin)

    for i in 1:N
        @constraint(m, sum(x[i,j] for j in 1:M) == 1)
        
        for j in 1:M
            @constraint(m, x[i,j] <= y[j])
        end
    end

    @objective(m, Min,  sum(c[i,j] * x[i,j] for i in 1:N, j in 1:M) + 
                        sum(f[j] * y[j] for j in 1:M))
    
    optimize!(m)

    # display(value(x))
    # display(value(y))

    println("Valeur objectif du problème intégral :")
    display(objective_value(m))

    return value(x),value(y),objective_value(m)
end