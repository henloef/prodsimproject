function [ A, I ] = area_properties( d )
% [A, I]=area_properties(d)
%--------------------------------------------------------------------
% PURPOSE
%  Returns the area and second moment of inertia of a circular section
%
% INPUT:  d = diameter mm
% OUTPUT: A : area mm^2
%         I : moment of intertia mm^4
%--------------------------------------------------------------------
r = d/2;
A = pi*r^2;
I = (pi/4)*r^4;

end

