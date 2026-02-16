using JuMP, Gurobi

include("generer_instance.jl")
include("localisation_simple.jl")
include("heuristique_arrondi.jl")
include("primal_dual.jl")

# --- Générer instance ---
L = 100
N = 25
M = 10

D, clients, usines = generer_instance_carre(L, N, M, false)

println("Matrice de distances D ($N x $M) :")
display(D)

f = [rand(50:100) for i = 1:M]
println("Coûts d'ouverture f :")
display(f)

# --- Résolution exacte ---

x,y,obj = localisation_simple(N,M,D,f)

plt = visualiser_instance_carre(clients, usines, x, y)
title!(plt,"Méthode : exacte\nValeur : $obj")
savefig(plt,"resultat_exact.png")

# Heuristique d'arrondi

x,y,v,obj = localisation_simple_relache(N,M,D,f)

plt = visualiser_instance_carre(clients, usines, x, y)
title!(plt,"Méthode : relache\nValeur : $obj")
savefig(plt,"resultat_relache.png")

x,y,obj = arrondi(sortperm(v))

plt = visualiser_instance_carre(clients, usines, x, y)
title!(plt,"Méthode : arrondi\nValeur : $obj")
savefig(plt,"resultat_arrondi.png")

display(plt)

x,y,obj = primal_dual(N,M,D,f)

plt = visualiser_instance_carre(clients, usines, x, y)
title!(plt,"Méthode : primaldual\nValeur : $obj")
savefig(plt,"resultat_primaldual.png")