function [ Coord ] = new_coord( Coord_0, a )
% [Coord]=new_coord( Coord_0, a )
%--------------------------------------------------------------------
% PURPOSE
% Find the new coordinates given a change a
%
% INPUT:  Coord_0 = original global coordinate matrix
%         a = total displacement in all dof
% OUTPUT: Coord = updated global coordinate matrix
%--------------------------------------------------------------------
Coord = zeros(size(Coord_0));
n_nodes = size(Coord_0,1);

dof = 1;
for i = 1:n_nodes
    Coord(i,:) = Coord_0(i,:) + a(dof:dof+1)';
    dof = dof+3;
end

end

