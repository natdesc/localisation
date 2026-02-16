include("generer_instance.jl")
include("localisation_simple.jl")
include("heuristique_arrondi.jl")

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
savefig(plt,"resultat_exact.png")

# Heuristique d'arrondi

x,y,v,obj = localisation_simple_relache(N,M,D,f)

display(arrondi(sortperm(v)))

plt = visualiser_instance_carre(clients, usines, x, y)
savefig(plt,"resultat_arrondi.png")

display(plt)