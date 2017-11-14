function [T, xc] = makeXTilde(x1,x2)
% [T, xc] = makeXTilde(x1,x2)
%--------------------------------------------------------------------
% PURPOSE
% Generate global stiffness matrix for a structure
% Generate tranformation matrx T, in order to transform elemental nodal
% coordinates from global to local. 
% Generate coordinates corresponding to element center.

% INPUT:  x1,x2 = nodal coordinate vectors in reference to global coordinate
%                 system.

% OUTPUT: T - Tranformation matrix, global to local.
%               where T = [i1_0; 12_0] =     | i1_0(1)   i1_0(2) |
%                                            | i2_0(1)   i2_0(2) |
%               Where i1_0 unit vector parallell to element, and i2_0 is
%               unit vector perpendicular to element
%         xc - Center of element cooridnates in reference to global coordinate system.
%
%         In order to make nodal coordinate vectors in reference to local coordinate system, xtilde:

%         xtilde1 = T*((x1-xc)');
%         xtilde2 = T*((x2-xc)');
%--------------------------------------------------------------------


i_par = -x1 +x2; %Find vector parallell to beam(We assume linear beam elements)

i1_0 = i_par./(sqrt(i_par(1)^2 + i_par(2)^2)); %make vector of length 1 parallell to beam

i2_0 = [-i1_0(2) i1_0(1)]; %Find unit vector perpendicular to beam

T = [i1_0; i2_0]; %T is the local coordinate system, consisting of unit vectors parallell and perpendicular to beam.
%T is on the form:

%   | i1_0(1)   i1_0(2) |
%   | i2_0(1)   i2_0(2) |

%Center node
xc = [(x1(1)+x2(1))/2, (x1(2)+x2(2))/2];
end







