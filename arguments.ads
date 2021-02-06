with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

package Arguments is
    E_NB_ARGUMENTS : exception;
    E_EXT_FIC : exception;
    E_ALPHA : exception;

    --  Initialiser les paramètres par défaut
    procedure InitialiserArguments(alpha : out Float; estMatricePleine : out Boolean; nbIteration : out Integer);

    -- Renvoie la position d'un argument de la ligne de commande, si absent renvoie le nombre d'arguments de cette commande
    function TrouverArgument(Arg : in String) return Integer;

    -- Traite les arguments de la ligne de commande
    procedure TraiterArguments(alpha : out Float; estMatricePleine : out Boolean; nbIteration : out Integer; nomFichier : out Unbounded_String)
    with Post => alpha <= 1.0;
end Arguments;
