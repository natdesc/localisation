using LinearAlgebra
using Random
using Plots

"""
Génère une instance de problème de localisation sur une grille triangulaire (hexagonale).
- L : Nombre de points sur un côté de l'hexagone
- N : Nombre de clients
- M : Nombre d'usines
"""
function generer_instance_hexagone(L::Int, N::Int, M::Int)
    # 1. Générer tous les points valides de la grille dans l'hexagone
    # Pour un hexagone de côté L, les coordonnées varient de -(L-1) à L-1
    range_val = L - 1

    clients = []
    usines = []

    for _ in 1:N
        q = rand(-range_val:range_val)
        r = rand(max(-range_val, -q - range_val):min(range_val, -q + range_val))
        s = -q-r
        push!(clients, (q,r,s))
    end
    
    for _ in 1:M
        q = rand(-range_val:range_val)
        r = rand(max(-range_val, -q - range_val):min(range_val, -q + range_val))
        s = -q-r
        push!(usines, (q,r,s))
    end
        

    # 3. Calcul de la matrice de distances D[i, j]
    # La distance de Manhattan sur une grille hexagonale/triangulaire est :
    # d = (|q1-q2| + |r1-r2| + |s1-s2|) / 2
    D = zeros(Int, N, M)
    
    for i in 1:N
        for j in 1:M
            c = clients[i]
            u = usines[j]
            D[i, j] = div(abs(c[1] - u[1]) + abs(c[2] - u[2]) + abs(c[3] - u[3]), 2)
        end
    end

    return D, clients, usines
end

# --- Fonctions de conversion ---
function cube_to_cartesian(q, r, s)
    x = 1.5 * q
    y = sqrt(3) * (r + q / 2)
    return x, y
end

"""
Génère une instance sur une grille carrée
"""
function generer_instance_carre(L::Int, N::Int, M::Int, same::Bool = false)
    # 1. Générer tous les points valides de la grille dans le carré
    clients = []
    usines = []
    
    if same
        for _ in 1:N
            x = rand(0:L-1)
            y = rand(0:L-1)
            push!(clients, (x,y))
            push!(usines, (x,y))
        end
    else
        for _ in 1:N
            x = rand(0:L-1)
            y = rand(0:L-1)
            push!(clients, (x,y))
        end
        
        for _ in 1:M
            x = rand(0:L-1)
            y = rand(0:L-1)
            push!(usines, (x,y))
        end
    end

    # 3. Calcul de la matrice de distances D[i, j]
    D = zeros(Int, N, M)
    
    for i in 1:N
        for j in 1:M
            c = clients[i]
            u = usines[j]
            D[i, j] = abs(c[1] - u[1]) + abs(c[2] - u[2])
        end
    end

    return D, clients, usines
end

"""
Affiche la grille hexagonale, les clients et les usines.
"""
function visualiser_instance_hexagone(clients, usines)
    # 1. Générer TOUS les points de la grille pour le fond

    # 2. Extraire les positions des clients
    cx = [cube_to_cartesian(c...)[1] for c in clients]
    cy = [cube_to_cartesian(c...)[2] for c in clients]

    # 3. Extraire les positions des usines
    ux = [cube_to_cartesian(u...)[1] for u in usines]
    uy = [cube_to_cartesian(u...)[2] for u in usines]

    # --- Création du tracé ---
    p = scatter()

    scatter!(p, cx, cy, 
        label="Clients (N=$(length(clients)))", color=:blue, markersize=6, marker=:circle)

    scatter!(p, ux, uy, 
        label="Usines (M=$(length(usines)))", color=:red, markersize=8, marker=:rect)

    return p
end

function visualiser_instance_carre(clients,usines,x,y)
    # 2. Extraire les positions des clients
    cx = [c[1] for c in clients]
    cy = [c[2] for c in clients]

    # 3. Extraire les positions des usines
    ux_open = []
    uy_open = []
    ux_closed = []
    uy_closed = []

    for j in 1:length(usines)
        if y[j] > 0.5
            push!(ux_open,usines[j][1])
            push!(uy_open,usines[j][2])
        else
            push!(ux_closed,usines[j][1])
            push!(uy_closed,usines[j][2])
        end
    end

    # --- Création du tracé ---
    p = scatter()

    scatter!(p, cx, cy, 
        label="Clients (N=$(length(clients)))", color=:blue, markersize=6, marker=:circle)

    scatter!(p, ux_open, uy_open, 
        label="Usines ouvertes", color=:red, markersize=8, marker=:rect)
    
    scatter!(p, ux_closed, uy_closed, 
        label="Usines fermées", color=:grey, markersize=8, marker=:rect)

    for i in 1:length(clients)
        for j in 1:length(usines)
            if x[i,j] > 0.5
                plot!(p, [clients[i][1], usines[j][1]], [clients[i][2], usines[j][2]],
                color=:green, label=false)
            end
        end
    end

    return p
end