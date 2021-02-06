with Ada.Unchecked_Deallocation;


package body LCA is

    procedure Free is
            new Ada.Unchecked_Deallocation (Object => T_Cellule, Name => T_LCA);


    procedure Initialiser(Sda: out T_LCA) is
    begin
        Sda:=Null;
    end Initialiser;


    function Est_Vide (Sda : T_LCA) return Boolean is
    begin
        if Sda=Null then
            --Si Sda est Null, Sda est alors vide
            return True;
        else
            return False;
        end if;
    end;


    function Taille (Sda : in T_LCA) return Integer is
        Compteur: Integer;
        Curseur: T_LCA;
    begin
        Compteur:=0;
        Curseur:=Sda;
        --Tant que le curseur n'est pas null on ajoute 1 au compteur
        while Curseur/=Null loop
            Curseur:=Curseur.all.Suivant;
            Compteur:=Compteur+1;
        end loop;
        return compteur;
    end Taille;


    procedure Enregistrer (Sda : in out T_LCA ; Cle : in T_Cle ; Donnee : in T_Donnee) is
    begin
        if Sda=Null then --Le cas ou on arrive à la fin de la Sda ou si la Sda est vide
            Sda:= New T_Cellule'(Donnee,Cle,Null);
        else -- On va dans toute les celulles verifier si une cle correspond à la cle demandee
            if Sda.all.Cle=Cle then
                Sda.all.Donnee:=Donnee;
            else
                Enregistrer(Sda.All.Suivant,Cle,Donnee);
            end if;
        end if;
    end Enregistrer;


    function Cle_Presente (Sda : in T_LCA ; Cle : in T_Cle) return Boolean is
    begin

        if Sda=Null then -- Cas ou la Sda est vide ou si la cle n'est pas présente
            return(False);
        else --On checher dans les cases si une cle correspond
            if Sda.all.Cle=Cle then
                return(True);
            else
                return(Cle_Presente(Sda.All.Suivant,Cle));
            end if;
        end if;
    end;


    function La_Donnee (Sda : in T_LCA ; Cle : in T_Cle) return T_Donnee is
    begin
        if Sda=Null then -- Cas ou il n'y a pas le cle demande ou si la liste est vide
            raise Cle_Absente_Exception;
        else --On parcourt les cases
            if Sda.all.Cle=Cle then
                return(Sda.all.Donnee);
            else
                return(La_Donnee(Sda.All.Suivant,Cle));
            end if;
        end if;

    end La_Donnee;


    procedure Supprimer (Sda : in out T_LCA ; Cle : in T_Cle) is
        Sdanew: T_LCA;
    begin
        if Sda=Null then -- Cas ou il n'y a pas le cle demande ou si la liste est vide
            raise Cle_Absente_Exception;
        else
            --On parcourt les cases à la recherche d'une cle qui correspond
            if Sda.all.Cle=Cle then
                --Sdanew est une case pour liberer la case qu'on veut supprimer
                Sdanew:=Sda;
                Sda:=Sda.all.Suivant;
                Free(Sdanew);
            else
                Supprimer(Sda.All.Suivant,Cle);
            end if;
        end if;

    end Supprimer;


    procedure Vider (Sda : in out T_LCA) is
    begin
        if Sda=Null then --Si le pointeur est nul, rien à faire
            null;
        else
            --On libere recursivement les cases
            Vider(Sda.All.Suivant);
            Free(Sda);
        end if;
    end Vider;


    procedure Pour_Chaque (Sda : in T_LCA) is
    begin
        if Sda=Null then --Rien à traiter dans ce cas
            Null;
        else
            --On traite les element puis on passe à la case suivante
            Traiter(Sda.all.Cle,Sda.all.Donnee);
            Pour_Chaque(Sda.all.Suivant);
        end if;
    end Pour_Chaque;

end LCA;
