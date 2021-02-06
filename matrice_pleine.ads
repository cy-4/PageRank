generic
     N: Integer;

package Matrice_pleine is

    type T_tableau_float is array(1..N) of Float;
    type T_matrice is array(1..N,1..N) of Float;
    type T_tableau_integer is array(1..N) of Integer;

    --Permet de Calculer le poids de chaque page à l'aide d'une matrice G pleine
    --Parametre: Nb_iteration in Integer
    --           N In Integer
    --           Alpha in Float
    --           Fichier in String
    --           Pi: out T_tableau_float
    --
    procedure matrice_pleine(Nb_iteration: in Integer;N:In Integer;Alpha: in Float; Fichier: in String;Pi: out T_tableau_float);

end Matrice_pleine;
