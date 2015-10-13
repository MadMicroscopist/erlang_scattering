-record(electron,
            {
            el_flag = primary,                          %electron state: primary, bse, se
            el_energy = 10.0e1,                             %electron instant energy in keV
            el_z_coor = 0,                              %electron z coordinate in cm
            el_xy_coor ={0, 0},                         %electron x and y coordinates in cm
            el_r_matrix = {1, 0, 0, 0, 1, 0, 0, 0, 1}   %electron rotational matrix
            }).
-record(material,
            {
            mat_name = "C",                             %material name
            mat_atom_number = 6,                        %material atomic number
            mat_atom_weight = 12,                       %material atomic weight in a.u.m
            mat_density = 1.5,                          %material density in g/cm^3
            mat_MIP = 0.178                            %material mean ionization potential in keV
            }).
