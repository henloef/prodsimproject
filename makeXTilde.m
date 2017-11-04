function [T, xc] = makeXTilde(x1_0,x2_0)

%%Startet on by OM
%%Local coordinate unit vectors(BOX 2.2 PHd)

%Make node vectors from global origo. Node 1 is leftmost node, node 2 is
%right most node.



i_par = -x1_0 +x2_0; %Find vector parallell to beam(We assume linear beam elements)

i1_0 = i_par./(sqrt(i_par(1)^2 + i_par(2)^2)); %make vector of length 1 parallell to beam

i2_0 = [-i1_0(2) i1_0(1)]; %Find unit vector perpendicular to beam

T = [i1_0; i2_0]; %T is the local coordinate system, consisting of unit vectors parallell and perpendicular to beam.
%T is on the form:

%   | i1_0(1)   i1_0(2) |
%   | i2_0(1)   i2_0(2) |

%Center node
xc = [(x1_0(1)+x2_0(1))/2, (x1_0(2)+x2_0(2))/2];
end







