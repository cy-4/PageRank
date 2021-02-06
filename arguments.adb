with Ada.Command_Line; use Ada.Command_Line;
with Ada.Text_IO; use Ada.Text_IO;

package body Arguments is

    procedure InitialiserArguments(alpha : out Float; estMatricePleine : out Boolean; nbIteration : out Integer) is
    begin
	alpha := 0.85;
	estMatricePleine := false;
	nbIteration := 150;
    end InitialiserArguments;

    function TrouverArgument(Arg : in String) return Integer is
    begin
	for i in 1..Argument_Count-1 loop
	    if Argument(i)=Arg then
		return i;
	    end if;
	end loop;
	return Argument_Count;
    end TrouverArgument;

    procedure TraiterArguments(alpha : out Float; estMatricePleine : out Boolean; nbIteration : out Integer; nomFichier : out Unbounded_String) is
	nbArgument : Natural;
	positionArg : Natural;
    begin
	InitialiserArguments(alpha, estMatricePleine, nbIteration);
	nbArgument := Argument_Count;
	if nbArgument = 0 then
	    raise E_NB_ARGUMENTS;
	else
	    nomFichier := To_Unbounded_String(Argument(nbArgument));
	    if Slice(nomFichier, Length(nomFichier)-3, Length(nomFichier)) /= ".net" then
		raise E_EXT_FIC;
	    else
		if nbArgument /= TrouverArgument("-P") then
		    estMatricePleine := true;
		end if;
		positionArg := TrouverArgument("-A");
		if nbArgument /= positionArg then
		    alpha := Float'Value(Argument(PositionArg + 1));
		    if alpha < 0.0 or alpha > 1.0 then
			raise E_ALPHA;
		    end if;
		end if;
		positionArg := TrouverArgument("-I");
		if nbArgument /= positionArg then
		    nbIteration := Integer'Value(Argument(PositionArg + 1));
		end if;
	    end if;
	end if;
    end TraiterArguments;
end Arguments;
