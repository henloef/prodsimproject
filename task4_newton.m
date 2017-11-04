clc, clear

%% Properties
E = 2.1e5; %% N/mm^2
thickness = 10; % mm
width = 100; % mm
H = 400; % height mm
max_load = -30e3; % N
steps = 100;
dimensionless = 0;

load = [0:max_load/steps: max_load];
displacement = zeros(1,length(load));
residual = zeros(1,length(load));

%% Create geometry
[Edof, Coord,  Dof] = circular_arch();

%% Create stiffness matrix
[A, I] = area_properties(thickness, width);
ep = [E A I];
K = global_stiffness(Edof, Coord, ep);

%% Boundary conditions and load
bc = [1 0; 2 0; 61 0; 62 0];

Coord_base = Coord;
%% Solve
for i=1:steps
    f = load_vector(Edof, load(i));
    [a,q] = solveq(K, f, bc);
    residual(i+1)
    displacement(i+1) = max(abs(a));
    Coord = update_coord(Coord_base, a);
    K = global_stiffness(Edof, Coord, ep);
end
%% Plot deformed
[Ex, Ey] = coordxtr(Edof, Coord, Dof, 2);
plotpar = [2 2 1];
sfac = 1;
Ed = extract(Edof, a);
eldisp2(Ex, Ey, Ed, plotpar, sfac);

figure
plot(displacement, abs(load))
