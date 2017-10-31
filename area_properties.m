function [ A, I ] = area_properties( t, w )
% [A, I]=area_properties(d)
%--------------------------------------------------------------------
% PURPOSE
%  Returns the area and second moment of inertia of a circular section
%
% INPUT:  t = thickness
%         w = width
% OUTPUT: A : area mm^2
%         I : moment of intertia mm^4
%--------------------------------------------------------------------

A = t*w;
I = (1/12)*w*t^3;

end

