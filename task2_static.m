clc, clear

%% Properties
E = 2.1e5; %% N/mm^2
thickness = 10; % mm
width = 100; % mm
H = 400; % height mm
max_load = 100; % N
steps = 100;
dimensionless = 0;

%% Create geometry
[Edof, Coord,  Dof] = circular_arch();

%% Create stiffness matrix
[A, I] = area_properties(thickness, width);
ep = [E A I];
K = global_stiffness(Edof, Coord, ep);

%% Boundary conditions and load
bc = [1 0; 2 0; 61 0; 62 0];
f = load_vector(Edof, max_load);

%% Solve
[a,r] = solveq(K, f, bc);
max_disp = max(abs(a))
% Abaqus gir 0.3849 for 200N

%% Plot deformed
[Ex, Ey] = coordxtr(Edof, Coord, Dof, 2);
plotpar = [2 2 1];
sfac = 1;
Ed = extract(Edof, a);
eldisp2(Ex, Ey, Ed, plotpar, sfac);

