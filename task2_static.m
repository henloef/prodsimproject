[Edof, Coord,  Dof] = circular_arch();   
[Ex, Ey] = coordxtr(Edof, Coord, Dof, 2);
eldraw2(Ex,Ey)

[A, I] = area_properties(10, 100);
E = 2.1e5;
ep = [E A I];
K = global_stiffness(Edof, Coord, ep);

total_dof = numel(Edof);
n_elements = total_dof/3-1;
middle_node = n_elements/2+1;
vertical_dof = 