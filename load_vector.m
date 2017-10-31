function [ f ] = load_vector( Edof, magnitude)
% [f]=load_vector( Edof, magnitude)
%--------------------------------------------------------------------
% PURPOSE
%  Create load vector at middle node in vertical direction
%
% INPUT:  Edof = topology matrix
%         magnitude = the magnitude of the load [N]
% OUTPUT: f : force vector
%--------------------------------------------------------------------

total_dof = 21*3;
n_elements = 20;
middle_node = n_elements/2+1;
vertical_dof = middle_node*3-1;

f = zeros(total_dof, 1);
f(vertical_dof) = magnitude;