include("generer_instance.jl")
include("localisation_simple.jl")
include("heuristique_arrondi.jl")

# --- Générer instance ---
L = 1000
N = 25
M = 10

D, clients, usines = generer_instance_hexagone(L, N, M)
plt = visualiser_instance(L, clients, usines)

# Pour afficher dans un notebook ou une fenêtre :
display(plt)

println("Matrice de distances D ($N x $M) :")
display(D)

f = [rand(5:10) for i = 1:M]
display(f)

# --- Résolution exacte ---

localisation_simple(N,M,D,f)

# Heuristique d'arrondi

x,y,v,obj = localisation_simple_relache(N,M,D,f)

function arrondi(les_indices)
    affecte = [false for i = 1:N]

    C = 0
    for i in les_indices

        if !(affecte[i])

            affecte[i] = true
            usines = []
            cluster = [i]

            # Construire le cluster C_k
            for j in 1:M
                if x[i,j] > 0.1
                    push!(usines,j)
                    for iprime in 1:N
                        if x[iprime,j] > 0.1 && !(affecte[iprime])
                            affecte[iprime] = true
                            push!(cluster,iprime)
                        end
                    end
                end
            end

            # Choisir le sit j_k à ouvrir
            best_usines = sortperm(f[usines])
            j_k = best_usines[1]

            # Calculer le coût du cluster C_k
            C = C + f[j_k]
            for iprime in cluster
                C = C + D[iprime,j_k]
            end
        end
    end

    return C
end

display(arrondi(sortperm(v)))