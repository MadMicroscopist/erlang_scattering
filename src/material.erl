-module(material).
-export([choise/1]).
-include("electron.hrl").

choise(Name) ->
    case Name of
         "C" -> Material = #material{mat_name = Name, mat_atom_number = 6,                        %material atomic number
         mat_atom_weight = 12,                       %material atomic weight in a.u.m
         mat_density = 1.5,                          %material density in g/cm^3
         mat_MIP = 0.791};
        "Al" -> Material = #material{mat_name = Name, mat_atom_number = 13,                 %material atomic number
        mat_atom_weight = 27,                       %material atomic weight in a.u.m
        mat_density = 2.70,                          %material density in g/cm^3
        mat_MIP = 0.170};
        "Si" -> Material = #material{mat_name = Name, mat_atom_number = 14,                         %material atomic number
        mat_atom_weight = 28,                       %material atomic weight in a.u.m
        mat_density = 2.33,                          %material density in g/cm^3
        mat_MIP = 0.178};
        "Cu" -> Material = #material{mat_name = Name, mat_atom_number = 29,                        %material atomic number
        mat_atom_weight = 63.5,                       %material atomic weight in a.u.m
        mat_density = 8.96,                          %material density in g/cm^3
        mat_MIP = 0.332};
        "Pt" -> Material = #material{mat_name = Name, mat_atom_number = 78,                        %material atomic number
        mat_atom_weight = 195,                       %material atomic weight in a.u.m
        mat_density = 21.45,                          %material density in g/cm^3
        mat_MIP = 0.792};
        "Au" -> Material = #material{mat_name = Name, mat_atom_number = 79,                       %material atomic number
        mat_atom_weight = 197,                       %material atomic weight in a.u.m
        mat_density = 19.30,                          %material density in g/cm^3
        mat_MIP = 0.789};
        _Other -> {error, wrong_material}
    end.
