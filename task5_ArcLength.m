clc, clear, close all

%% Properties
E = 2.1e5; %% N/mm^2
thickness = 10; % mm
width = 100; % mm
H = 400; % height mm
max_load = -100; % N
% tolerance = 1.e-9; 

increments = 100;
max_iterations = 10;
max_residual = 10;
iteration = 1;


%% Create geometry
[Edof, Coord_0,  Dof] = circular_arch();
total_dof = size(Coord_0,1)*3;

%% Section and material properties
[A, I] = area_properties(thickness, width);
ep = [E A I];

%% Boundary conditions
bc = [1 0; 2 0; 61 0; 62 0];

%% Solve
for i=1:increments
    %r(a',lam') = f_int(a_0 + da) - (lam_0 - dlam)q = 0
    %r(a'', lam'') = f_int(a_0 + da_0 + dla_0) - (lam_0 - dlam - dllam)q =
    %0

end
%% Plot deformed
Coord = new_coord(Coord_0,a);
[Ex, Ey] = coordxtr(Edof, Coord, Dof, 2);
plotpar = [2 2 1];
sfac = 1;
Ed = extract(Edof, a);
eldisp2(Ex, Ey, Ed, plotpar, sfac);