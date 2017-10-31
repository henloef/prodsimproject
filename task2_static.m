[Edof, Coord,  Dof] = circular_arch();   
[Ex, Ey] = coordxtr(Edof, Coord, Dof, 2);
eldraw2(Ex,Ey)
