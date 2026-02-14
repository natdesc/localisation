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
    display(value(y))

    display(objective_value(m))

    return value(x), value(y), v, objective_value(m)
end