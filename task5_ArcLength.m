clc, clear, close all

%% Properties
E = 2.1e5; %% N/mm^2
thickness = 10; % mm
width = 100; % mm
[A, I] = area_properties(thickness, width);
ep = [E A I];

%% Solver tuning variables
increments = 350;
max_iterations = 20;
max_residual = 0.01;
f_magnitude = -63;
delta_s = 40;

%% Create geometry
[Edof, Coord_0,  Dof] = circular_arch(20);
total_dof = size(Coord_0,1)*3;
bc = [1 0; 2 0; 61 0; 62 0];

%% Load
q = load_vector(Edof, f_magnitude); %This is the load vector, where the values corresponds to force magnitude, and placement in vector corresponds to node and direction.

%% Initial values

v_hat = zeros(total_dof,1);
lambda = 0;

[K, fi] = global_K_internal_force(Edof, Coord_0, v_hat, ep);
w_q0 = solveqOM(K,q,bc);
f = sqrt(1+(w_q0')*(w_q0)); 
delta_lambda = delta_s/f; 
v_0 = delta_lambda*w_q0;

umidNode = 20/2+1;
vertical_dof = umidNode*3-1;
horizontal_dof = vertical_dof-1;

[K, fi] = global_K_internal_force(Edof, Coord_0, v_hat, ep);

w_q = solveqOM(K,q,bc); % displacement "velocity"

%% Solve
for i = 1:increments
    f = sqrt(1+(w_q')*(w_q)); % Helper variable
      
    if((w_q'*v_0)>0 && i==1)
        delta_lambda = delta_s/f; 
    elseif((w_q'*v_0)>0)
        delta_lambda = delta_s/f; 
    else
        delta_lambda = -(delta_s/f);
    end
    
    v_0 = delta_lambda*w_q;
    
    %Updating force variable lambda, and global displacement.
    lambda = lambda + delta_lambda;
    v_hat = v_hat + v_0;
        
    iteration = 1;
    while iteration <= max_iterations       
        [K, fi] = global_K_internal_force(Edof, Coord_0, v_hat, ep);
        fi = remove_bc_from_fi(fi, bc);
        r = lambda*q - fi;

        w_q = solveqOM(K,q,bc);
        w_r = solveqOM(K,r,bc);

        del_lambda = -((w_q'*w_r)/(1+w_q'*w_q));
        
        %Making corrector step
        lambda = lambda + del_lambda;
        v_hat = v_hat + (w_r+del_lambda*w_q);
       
        % Check threshold for residual
        r_sum = sqrt(r'*r); %Root sum squared
        if r_sum < max_residual
            break
        end
        iteration = iteration + 1;
    end
    response_plot(i,1) = v_hat(vertical_dof)*-1;
    response_plot(i,2) = lambda*f_magnitude*-1;
    fprintf('%.0f%% done\n',i/increments*100)
end

%% Plots
title_prefix = 'Arc length,';

% Geometry
Coord = new_coord(Coord_0,v_hat);
[Ex, Ey] = coordxtr(Edof, Coord, Dof, 2);
plotpar = [2 2 1];
sfac = 1;
Ed = extract(Edof, v_hat);
eldisp2(Ex, Ey, Ed, plotpar, sfac);
title(strcat(title_prefix, ' geometry last increment'))

% Load displacement
figure
plot(response_plot(:,1),response_plot(:,2))
title(strcat(title_prefix, ' load/displacement'))
xlabel('displacement [mm]')
ylabel('load [N]')