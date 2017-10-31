function [ K ] = global_stiffness( Edof, Coord, ep )
% [K]=global_stiffness( Edof, Coord, ep )
%--------------------------------------------------------------------
% PURPOSE
%  Returns the area and second moment of inertia of a circular section
%
% INPUT:  Edof = topology matrix
%         Coord = global coordinate matrix
%         ep = [E A I] modulus of elasticity, area, moment of inertia
% OUTPUT: K : global stiffness matrix
%--------------------------------------------------------------------

total_dof = numel(Edof);
n_elements = total_dof/3-1;

K = zeros(total_dof);

for i=1:n_elements
    % Elements stiffness matrix
    Ke = beam2e(Coord(i,1), Coord(i,2), ep);
    % Add to global stiffness matrix
    K = assem(Edof(i,:), K, Ke);
end

