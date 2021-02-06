
package body TH is

    procedure Initialiser(Sda: out T_TH) is
    begin
	--Initialiser le pointeur pour chaque pointeur du tableau
        for i in 1 .. Capacite loop
	    Initialiser(Sda(i));
	end loop;
    end Initialiser;


    function Est_Vide(Sda :in T_TH) return Boolean is
    begin
	--Retourner false, si un pointeur du tableau n'est pas vide,
	for i in 1 .. Capacite loop
	    if not Est_Vide(SdA(i)) then
		return(false);
	    end if;
      	end loop;
	return(True);
    end;


    function Taille (Sda : in T_TH) return Integer is
        Compteur: Integer;
    begin
	Compteur:=0;
	--Faire la sommme des tailles de chaques pointeur du tableau
	for i in 1 .. Capacite loop
	    Compteur:=Compteur+Taille(Sda(i));
        end loop;
        return Compteur;
    end Taille;


    procedure Enregistrer (Sda : in out T_TH; Cle : in T_Cle ; Donnee : in T_Donnee) is
	valeur_hachage: Integer;
    begin
        valeur_hachage:=funct_hachage(Cle)mod Capacite +1;
        Enregistrer(Sda(valeur_hachage),Cle,Donnee);
    end Enregistrer;


    function Cle_Presente (Sda : in T_TH ; Cle : in T_Cle) return Boolean is
	valeur_hachage: Integer;
    begin
	valeur_hachage:=funct_hachage(Cle)mod Capacite+1;
	return(Cle_Presente(Sda(valeur_hachage),Cle));
    end;


    function La_Donnee (Sda : in T_TH ; Cle : in T_Cle) return T_Donnee is
	valeur_hachage: Integer;
    begin
	valeur_hachage:=funct_hachage(Cle)mod Capacite+1;
	return(La_Donnee(sda(valeur_hachage),Cle));
    end La_Donnee;


    procedure Supprimer (Sda : in out T_TH ; Cle : in T_Cle) is
	valeur_hachage: Integer;
    begin
	valeur_hachage:=funct_hachage(Cle)mod Capacite+1;
	Supprimer(Sda(valeur_hachage),Cle);
    end Supprimer;


    procedure Vider (Sda : in out T_TH) is
    begin
	-- Vider chaque pointeur du tableau
	for i in 1 .. Capacite loop
	    Vider(Sda(i));
	end loop;
    end Vider;


    procedure Pour_Chaque (Sda : in T_TH) is
	procedure Pour_ChaqueNew is
	    new th_lca.Pour_Chaque(Traiter);
    begin
	--Appliquer Traiter à chaque case du tableau
	for i in 1 .. Capacite loop
	    Pour_ChaqueNew(Sda(i));
	end loop;
    end Pour_Chaque;

end TH;
