function [ Coord ] = update_coord( Coord, a )
% [Coord]=update_coord( Coord, a )
%--------------------------------------------------------------------
% PURPOSE
% Update the coordinates after a displacement
%
% INPUT:  Coord = global coordinate matrix
%         a = displacement from starting position
% OUTPUT: Coord = updated global coordinate matrix
%--------------------------------------------------------------------
n_nodes = size(Coord, 1);
dof_per_node = length(a)/n_nodes;

dof = 1;
for i=1:n_nodes
    Coord(i,1) = Coord(i,1) + a(dof);
    Coord(i,2) = Coord(i,2) + a(dof+1);
    dof = dof + dof_per_node;
end

