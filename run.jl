using JuMP, Gurobi

include("generer_instance.jl")
include("localisation_simple.jl")
include("heuristique_arrondi.jl")
include("primal_dual.jl")

function run_carre(instance_name,L,N,M,same::Bool = false)
    mkpath("$instance_name")
    logfile = open("$instance_name/logfile.txt","w")

    # --- Générer instance ---
    D, clients, usines = generer_instance_carre(L, N, M, false)

    println("Matrice de distances D ($N x $M) :")
    display(D)

    f = [rand(25:50) for i = 1:M]
    println("Coûts d'ouverture f :")
    display(f)

    println(logfile,"L = $L")
    println(logfile,"N = $N")
    println(logfile,"M = $M")
    println(logfile,"D = $D")
    println(logfile,"f = $f")

    # --- Résolution exacte ---

    x,y,obj = localisation_simple(N,M,D,f)

    plt = visualiser_instance_carre(clients, usines, x, y)
    title!(plt,"Méthode : exacte\nValeur : $obj")
    savefig(plt,"$instance_name/resultat_exact.png")

    println(logfile,"")
    println(logfile,"Résultats par la méthode exacte :")
    println(logfile,"Valeur objectif : $obj")
    println(logfile,"x = $x")
    println(logfile,"y = $y")

    # Heuristique d'arrondi

    x,y,v,obj = localisation_simple_relache(N,M,D,f)

    plt = visualiser_instance_carre(clients, usines, x, y)
    title!(plt,"Méthode : relache\nValeur : $obj")
    savefig(plt,"$instance_name/resultat_relache.png")
    println(logfile,"")
    println(logfile,"Résultats par le problème relâché :")
    println(logfile,"Valeur objectif : $obj")
    println(logfile,"x = $x")
    println(logfile,"y = $y")

    x_arr,y_arr,obj = arrondi(N,M,D,f,x,y,v)

    plt = visualiser_instance_carre(clients, usines, x_arr, y_arr)
    title!(plt,"Méthode : arrondi\nValeur : $obj")
    savefig(plt,"$instance_name/resultat_arrondi.png")
    println(logfile,"")
    println(logfile,"Résultats par la méthode d'arrondi :")
    println(logfile,"Valeur objectif : $obj")
    println(logfile,"x = $x_arr")
    println(logfile,"y = $y_arr")

    # Méthode primale duale

    x,y,obj = primal_dual(N,M,D,f)

    plt = visualiser_instance_carre(clients, usines, x, y)
    title!(plt,"Méthode : primaldual\nValeur : $obj")
    savefig(plt,"$instance_name/resultat_primaldual.png")
    println(logfile,"")
    println(logfile,"Résultats par la méthode primale-duale :")
    println(logfile,"Valeur objectif : $obj")
    println(logfile,"x = $x")
    println(logfile,"y = $y")
    close(logfile)
end

function run_hexagone(instance_name,L,N,M,same::Bool = false)
    mkpath("$instance_name")
    logfile = open("$instance_name/logfile.txt","w")

    # --- Générer instance ---
    D, clients, usines = generer_instance_hexagone(L, N, M, false)

    println("Matrice de distances D ($N x $M) :")
    display(D)

    f = [rand(25:50) for i = 1:M]
    println("Coûts d'ouverture f :")
    display(f)

    println(logfile,"L = $L")
    println(logfile,"N = $N")
    println(logfile,"M = $M")
    println(logfile,"D = $D")
    println(logfile,"f = $f")

    # --- Résolution exacte ---

    x,y,obj = localisation_simple(N,M,D,f)

    plt = visualiser_instance_hexagone(clients, usines, x, y)
    title!(plt,"Méthode : exacte\nValeur : $obj")
    savefig(plt,"$instance_name/resultat_exact.png")

    println(logfile,"")
    println(logfile,"Résultats par la méthode exacte :")
    println(logfile,"Valeur objectif : $obj")
    println(logfile,"x = $x")
    println(logfile,"y = $y")

    # Heuristique d'arrondi

    x,y,v,obj = localisation_simple_relache(N,M,D,f)

    plt = visualiser_instance_hexagone(clients, usines, x, y)
    title!(plt,"Méthode : relache\nValeur : $obj")
    savefig(plt,"$instance_name/resultat_relache.png")
    println(logfile,"")
    println(logfile,"Résultats par le problème relâché :")
    println(logfile,"Valeur objectif : $obj")
    println(logfile,"x = $x")
    println(logfile,"y = $y")

    x_arr,y_arr,obj = arrondi(N,M,D,f,x,y,v)

    plt = visualiser_instance_hexagone(clients, usines, x_arr, y_arr)
    title!(plt,"Méthode : arrondi\nValeur : $obj")
    savefig(plt,"$instance_name/resultat_arrondi.png")
    println(logfile,"")
    println(logfile,"Résultats par la méthode d'arrondi :")
    println(logfile,"Valeur objectif : $obj")
    println(logfile,"x = $x_arr")
    println(logfile,"y = $y_arr")

    # Méthode primale duale

    x,y,obj = primal_dual(N,M,D,f)

    plt = visualiser_instance_hexagone(clients, usines, x, y)
    title!(plt,"Méthode : primaldual\nValeur : $obj")
    savefig(plt,"$instance_name/resultat_primaldual.png")
    println(logfile,"")
    println(logfile,"Résultats par la méthode primale-duale :")
    println(logfile,"Valeur objectif : $obj")
    println(logfile,"x = $x")
    println(logfile,"y = $y")
    close(logfile)
end

for K in 1:10
    run_carre("inst_$K",20*K,20,10,false)
end

for K in 11:20
    run_hexagone("inst_$K",10*(K-10),20,10,false)
end

