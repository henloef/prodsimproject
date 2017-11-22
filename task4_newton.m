clc, clear, close all

%% Properties
E = 2.1e5; %% N/mm^2
thickness = 10; % mm
width = 100; % mm
[A, I] = area_properties(thickness, width);
ep = [E A I];

%% Increments and iterations
increments = 50;
max_iterations = 20;
max_residual = 0.01;

%% Load
max_load = -26.7e3; % N
f_magnitude = 0 : max_load/(increments-1) : max_load;

%% Placeholders for plots
u_plot = zeros(increments,1);

%% Create geometry
[Edof, Coord_0,  Dof] = circular_arch(20);
total_dof = size(Coord_0,1)*3;
bc = [1 0; 2 0; 61 0; 62 0];

%% Solve
a = zeros(total_dof,1);
iteration = 1;
for i=1:increments
    f = load_vector(Edof, f_magnitude(i));
    while iteration <= max_iterations
        [K, fi] = global_K_internal_force(Edof, Coord_0, a, ep);
        fi = remove_bc_from_fi(fi, bc);
        r = f - fi; 
        [d_a, q_dummy] = solveq(K, r, bc);
        a = a + d_a;
        
        % Check threshold for residual
        r_sum = sqrt(r'*r); %Root sum squared
        if r_sum < max_residual
            break
        end
        iteration = iteration + 1;
    end
    u_plot(i) = max(abs(a));
    iteration = 1;
end

%% Plots
title_prefix = 'Newton iteration,';

% Geometry
Coord = new_coord(Coord_0,a);
[Ex, Ey] = coordxtr(Edof, Coord, Dof, 2);
plotpar = [2 2 1];
sfac = 1;
Ed = extract(Edof, a);
eldisp2(Ex, Ey, Ed, plotpar, sfac);
title(strcat(title_prefix, ' geometry last increment'))

% Load displacement
figure; hold on
plot([0 50.95],[0 abs(max_load)])
plot(u_plot,abs(f_magnitude))
legend('Direct stiffness method', 'Newton iteration')
title(strcat(title_prefix, ' load/displacement'))
xlabel('displacement [mm]')
ylabel('load [N]')
grid on