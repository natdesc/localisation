function primal_dual(N,M,D,f)
    # Initialiser les solutions primales et duales
    v = [0 for i = 1:N]
    w = [0 for i = 1:N, j = 1:M]
    x = [0 for i = 1:N, j = 1:M]
    y = [0 for j = 1:M]

    affecte = [0 for i = 1:N]

    # Phase 1 : itérer tant qu'il reste des clients non affectés
    while sum(affecte[i] for i = 1:N) < N

        # Vérifier si le budget v d'un client a atteint le coût d'un site ouvert
        for i = 1:N
            for j = 1:M
                if y[j] == 1 && v[i] == D[i,j]
                    x[i,j] = 1
                    affecte[i] = 1
                end
            end
        end

        # Vérifier s'il y a assez de surplus w pour ouvrir un site
        for j = 1:M
            if sum(w[i,j] for i = 1:N) == f[j]
                y[j] = 1
                for i = 1:N
                    if affecte[i] == 0 && v[i] >= D[i,j]
                        x[i,j] = 1
                        affecte[i] = 1
                    end
                end
            end
        end

        # Augmenter le budget v des sommets non affectés, màj leurs surplus w
        for i = 1:N
            if affecte[i] == 0
                v[i] += 1
                for j = 1:M
                    w[i,j] = max(0,v[i]-D[i,j])
                end
            end
        end
    end

    # Phase 2
    # 1. Définir les "Arêtes Tendues" (Tight Edges)
    # Un client i est "témoin" d'une usine j si son budget couvre exactement la distance.
    est_tendu(i, j) = v[i] >= D[i, j]

    # 2. Construire le graphe de conflit entre usines temporaires
    # Deux usines j1 et j2 sont en conflit s'il existe un client i 
    # tel que (i, j1) et (i, j2) sont des arêtes tendues.
    usines_temp = filter(j -> y[j] == 1, 1:M)
    conflits = Dict(j => Int[] for j in 1:M)
    for j1 in usines_temp, j2 in usines_temp
        if j1 < j2
            # Existe-t-il un client i commun ?
            for i in 1:N
                if est_tendu(i, j1) && est_tendu(i, j2)
                    push!(conflits[j1], j2)
                    push!(conflits[j2], j1)
                    break 
                end
            end
        end
    end

    # 3. Trouver un Ensemble Indépendant Maximal (MIS)
    # On sélectionne les usines de manière gloutonne pour éviter les conflits.
    y_final = [0 for j in 1:M]
    a_traiter = copy(usines_temp)
    
    while !isempty(a_traiter)
        # On prend la première usine disponible
        j_star = popfirst!(a_traiter)
        y_final[j_star] = 1
        
        # On supprime toutes les usines en conflit avec j_star de la liste d'attente
        filter!(j -> !(j in conflits[j_star]), a_traiter)
    end

    # 4. Assignation finale des clients
    # Chaque client est assigné à l'usine la plus proche parmi celles sélectionnées.
    x_final = [0 for i = 1:N, j = 1:M]
    usines_finales = filter(j -> y_final[j] == 1, 1:M)
    for i in 1:N
        dist_min, usine_choisie = findmin([D[i, j] for j in usines_finales])
        x_final[i,usines_finales[usine_choisie]] = 1
    end

    # Calculer la valeur objectif

    obj = sum(D[i,j] * x_final[i,j] for i in 1:N, j in 1:M) + 
                        sum(f[j] * y_final[j] for j in 1:M)
    println("Valeur obtenue par l'algorithme primal-dual :")
    display(obj)

    return x_final,y_final,obj
end