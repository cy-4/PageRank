with Ada.Text_IO; use Ada.Text_IO;
with Arguments; use Arguments;
with Ada.Strings; use Ada.Strings;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Float_Text_IO; use Ada.Float_Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with Matrice_pleine;
with TH;
with Ada.IO_Exceptions;

procedure PageRank is
    Alpha : Float;
    estMatricePleine : Boolean;
    nbIteration : Integer;
    nomFichier : Unbounded_String;
    Taille_reseau : Integer;
    File: File_Type;
begin
    -- On traite les arguments de la ligne de commande
    TraiterArguments(Alpha, estMatricePleine, nbIteration, nomFichier);

    -- Obtenir taille du réseau
    Open(File, In_File, To_String(nomFichier));
    Get(File,Taille_reseau);
    close(File);

    -- On utilise la taille du réseau pour instantier la matrice (pleine)
    declare
        package Matrice_pleineN is
		new Matrice_pleine(N => Taille_reseau);
	use Matrice_pleineN;

	pi : T_tableau_float;
	piIndice : T_tableau_integer;
	piCopie : T_tableau_float;
	indiceDuMax : Integer;
	fichier: File_Type;
        N: Integer;
        valeur: Float;
    begin
	if estMatricePleine then
	    -- Calcul avec la matrice pleine
            Matrice_pleineN.matrice_pleine(nbIteration,Taille_reseau, Alpha, To_String(nomFichier), pi);
	else
	    -- Calcul avec la matrice creuse
	    -- On a un problème non résolu si on implémente la matrice creuse dans un module
            N := Taille_reseau;

	    declare
                function hachage( Cle: in Unbounded_String ) return Integer is
                    hach : Unbounded_String;
                    i : Integer;
                begin
                    i := 1;
                    hach := Null_Unbounded_String;
		    -- La clé est de la forme PageSource+1 & "_" & PagePointee+1
                    while Element(Cle,i) /= '_' loop
			-- On récupère le numéro de la page source caractère par caractère
                        hach := hach & Element(Cle,i);
                        i := i + 1;
                    end loop;
		    -- On retourne le numéro de la page source
                    return(Integer'Value(To_String(hach)) - 1);
                end hachage;

                package TH_Integer_Float is
                        new TH (T_Cle => Unbounded_String, T_Donnee => Float,Capacite => N,funct_hachage=> hachage);
                use TH_Integer_Float;

                type T_matrice is array(1..N,1..N) of Float;
                type T_tableau_integer is array(1..N) of Integer;

                G : T_TH;
                File : Ada.Text_IO.File_Type;
                CoeffGoogle : Constant Float := (1.0-Alpha)/float(N);
                i : Integer;
                PagePointee : Integer;
                PageSource : Integer;
                cle : unbounded_string;
                cle_verif : unbounded_string;
                PI_ancien : T_tableau_float;
                somme : Float;


            begin
		-- Initialisation du vecteur et de la matrice
                PI := (1..N => 1.0 / float(N));
                Initialiser(G);

		-- Ouverture du fichier et lecture de la taille du réseau
                Open(File, In_File, To_String(nomFichier));
                Get(File,i);

		-- Lecture du fichier entier
                while not end_of_File(File) loop
		    -- On récupère la page source et la page qu'elle pointe
		    Get(File,PageSource);
		    Get(File,PagePointee);

		    -- On génère la clé en fonction de ces valeurs
		    cle := trim(To_Unbounded_String(Integer'Image(PageSource+1)), Both) & '_' & trim(To_Unbounded_String(Integer'Image((PagePointee+1))), Both);

		    -- On enregistre le couple clé-valeur (valeur provisoire égale à 1.0)
		    -- Si la clé est déjà présente (doublons) la valeur est écrasée
		    Enregistrer(G,cle,1.0);
		end loop;
                close(File);


	        -- Calcul de la matrice Google
                for k in 1..nbIteration loop

		    -- On stocke le vecteur PI pour faire les calculs avec les valeurs au rang i-1 (et non avec les valeurs calculées au rang i)
                    PI_ancien := PI;

		    -- Calcul matriciel
                    for i in 1..N loop
                        somme := 0.0;
                        for j in 1..N loop

			    -- La page j-1 référence au moins une page
                            if TH_Integer_Float.th_lca.Taille(G(j)) /= 0 then

				-- On créé une clé
				cle_verif := trim(To_Unbounded_String(Integer'Image(j)), Both) & '_' & trim(To_Unbounded_String(Integer'Image((i))), Both);

				-- On regarde si la page j-1 référence la page i-1
				if Cle_Presente(G,cle_verif) then
                                    valeur := (1.0 / float(TH_Integer_Float.th_lca.Taille(G(j)))) * Alpha + CoeffGoogle;
                                else
                                    valeur := CoeffGoogle;
                                end if;

			    -- La page j-1 ne référence aucune page
			    else
                                valeur := (1.0 / float(N)) * Alpha + CoeffGoogle;
                            end if;
                            somme := somme + PI_ancien(j) * valeur;
                        end loop;
                        PI(i) := somme;
                    end loop;
                end loop;

		-- On vide la matrice pour libérer la mémoire
                Vider(G);
            end;
	end if;


	-- Trier les pages
	-- On a un problème non résolu si on implémente le tri dans un module

	-- On fait une copie du vecteur pour pouvoir le trier
	piCopie := pi;
	for i in 1..Taille_reseau loop
	    indiceDuMax := i;

	    -- On récupère l'indice de la valeur maximum
	    for j in 1..Taille_reseau loop
		if piCopie(indiceDuMax) < piCopie(j) then
		    indiceDuMax := j;
		end if;
	    end loop;

	    -- On range les indices dans l'ordre décroissant des valeurs
	    piIndice(i) := indiceDuMax - 1;

	    -- On change la valeur maximale
	    piCopie(indiceDuMax) := 0.0;
	end loop;


	-- Ecrire les résultats
	-- On a un problème non résolu si on implémente l'écriture des résultats dans un module

	-- On créé le fichier PageRank.ord et on écrit les indices dans l'ordre
	Create(fichier, Out_File, "PageRank.ord");
	for i in 1..Taille_reseau loop
	    Put_Line(fichier, Integer'Image(piIndice(i)));
	end loop;
	Close(fichier);

	-- On créé le fichier Poids.p et on écrit ...
	Create(fichier, Out_File, "Poids.p");
	-- ... la taille du réseau ...
	Put(fichier, Integer'Image(Taille_reseau));
	-- ... le coefficient alpha utilisé ...
	Put(fichier, Float'Image(Alpha));
	-- ... le nombre d'itération utilisé ...
	Put_Line(fichier, Integer'Image(nbIteration));
	for i in 1..Taille_reseau loop
	    -- ... et le poids de chaque page
	    Put_Line(fichier, Float'Image(pi(piIndice(i) + 1)));
	end loop;
	Close(fichier);
    end;

exception
    when E_NB_ARGUMENTS => Put_Line("Il faut indiquer un fichier");
    when E_EXT_FIC => Put_Line("Le fichier doit être de type .net");
    when E_ALPHA => Put_Line("La valeur d'alpha doit être comprise entre 0 et 1");
    when ADA.IO_EXCEPTIONS.DATA_ERROR => Put_Line("Une des valeurs n'est pas un entier");
end PageRank;
