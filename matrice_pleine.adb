with Ada.Text_IO; use Ada.Text_IO;
with Ada.Float_Text_IO; use Ada.Float_Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;


package body Matrice_pleine is

    procedure matrice_pleine(Nb_iteration: in Integer;N: in Integer; Alpha: in Float; Fichier: in String;PI: out T_tableau_float) is

	PI_ancien : T_tableau_float;
	G : T_matrice;
	PagePointee : Integer;
	PageSource : Integer;
	Piref :T_tableau_integer;
	CoeffGoogle : Constant Float := (1.0 - Alpha) / float(N);
	File : Ada.Text_IO.File_Type;
	somme : Float;
	i : Integer;
    BEGIN
	-- Initialisation des vecteurs et de la matrice
	Piref := (1..N => 0);
	PI := (1..N => 1.0 / float(N));
	G := (1..N => (1..N => 0.0));

	-- Ouverture du fichier et lecture de la taille du réseau
	Open(File, In_File, Fichier);
	Get(File, i);

	-- Lecture du fichier entier
	while not end_of_File(File) loop
	    -- On récupère la page source et la page qu'elle pointe
	    Get(File, PageSource);
	    Get(File, PagePointee);
	    -- Si le couple n'a pas de valeur associée (on évite les doublbons)
	    if G(PageSource + 1, PagePointee + 1) = 0.0 then
		G(PageSource + 1, PagePointee + 1) := 1.0;
		-- On incrémente le nombre de pages pointées par la page courante
		Piref(PageSource + 1) := Piref(PageSource + 1) + 1;
	    else
		null;
	    end if;
	end loop;
	close(File);


	-- Calcul de la matrice Google
	for i in 1..N loop
	    for j in 1..N loop
		-- La page i ne référence aucune page
		if Piref(i) = 0 then
		    G(i,j) := (1.0 / float(N)) * Alpha + CoeffGoogle;
		--La page i ne référence pas la page j
		elsif G(i,j) = 0.0 then
		    G(i,j) := CoeffGoogle;
		--La page i référence la page j
		else
		    G(i,j) := (1.0 / Float(Piref(i))) * Alpha + CoeffGoogle;
		end if;
	    end loop;
	end loop;

	-- Calcul du vecteur PI
	for k in 1..Nb_iteration loop
	    PI_ancien := PI;
	    for i in 1..N loop
		somme := 0.0;
		for j in 1..N loop
		    somme := somme+PI_ancien(j)* G(j,i);
		end loop;
		PI(i) := somme;
	    end loop;
	end loop;

    end matrice_pleine;
end Matrice_pleine;
