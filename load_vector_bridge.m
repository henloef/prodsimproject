function [ f ] = load_vector_bridge( Edof, magnitude)
% [f]=load_vector( Edof, magnitude)
%--------------------------------------------------------------------
% PURPOSE
%  Create load vector for beam element with fixed end
%
% INPUT:  Edof = topology matrix
%         magnitude = the magnitude of the load [N]
% OUTPUT: f : force vector
%--------------------------------------------------------------------
dof_y_middle = size(Edof,1)/2*3+2;
n_elements = size(Edof, 1);
total_dof = (n_elements + 1)*3;
f = zeros(total_dof, 1);
f(dof_y_middle) = magnitude;