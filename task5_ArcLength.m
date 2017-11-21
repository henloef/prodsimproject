clc, clear, close all

%% Properties
E = 2.1e5; %% N/mm^2
thickness = 10; % mm
width = 100; % mm
[A, I] = area_properties(thickness, width);
ep = [E A I];
max_load = -100; % N
tolerance = 1.e-9; 

increments = 310;
max_iterations = 20;
max_residual = 0.01;

%% Placeholders for plots
r_plot = zeros(increments,max_iterations);
u_plot = zeros(increments,1);

%% Create geometry
[Edof, Coord_0,  Dof] = circular_arch(20);
total_dof = size(Coord_0,1)*3;
bc = [1 0; 2 0; 61 0; 62 0];

%% Initial solver values
v_hat = zeros(total_dof,1);
lambda = 0;

%% Solver tuning variables
f_magnitude = -66; %This is the total force applied, which through lambda will be increased until the total f_magnitude is applied to the structure.
delta_s = 40;
q = load_vector(Edof, f_magnitude); %This is the load vector, where the values corresponds to force magnitude, and placement in vector corresponds to node and direction.

%% Initiate v_0
[K, fi] = global_K_internal_force(Edof, Coord_0, v_hat, ep);
w_q0 = solveqOM(K,q,bc);
f = sqrt(1+(w_q0')*(w_q0)); 
delta_lambda = delta_s/f; 
v_0 = delta_lambda*w_q0;

umidNode = 20/2+1;
vertical_dof = umidNode*3-1;
horizontal_dof = vertical_dof-1;


%% Setup video
save_video = 0;
if save_video   
    vid = VideoWriter('../response.avi');
    open(vid);
end
    

for i = 1:increments
    if i == 10
        q(horizontal_dof) = 10;
    else
        q(horizontal_dof) = 0;
    end
    [K, fi] = global_K_internal_force(Edof, Coord_0, v_hat, ep);
        %K denotes the stiffness in the particular global displacement v_hat.    
    
    w_q = solveqOM(K,q,bc);     
        %w_q is here the displacement "velocity" with repsect to lambda. 
        %Horizontal vector consisting of velocities of all
        %translations and rotations.
    
    f = sqrt(1+(w_q')*(w_q));    
        %Just a simplification variable for the
        %relation between delta_s and delta_lambda
      
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
%     lambda_delta_lambda_del_lambdax1000 = [lambda delta_lambda del_lambda*1000]
    
    if save_video
        % Animate
        Coord = new_coord(Coord_0,v_hat);
        [Ex, Ey] = coordxtr(Edof, Coord, Dof, 2);
        h = figure;    
        set(h, 'Visible', 'off');

        subplot(1,2,1)
        plot(Ex,Ey)
        title('Geometry')
        axis([0 1600 -400 800])
    %     pbaspect([1.4 1 1])

        subplot(1,2,2)
        plot(response_plot(1:i,1),response_plot(1:i,2)) 

        t2 = title('Force / displacement response');
    %     titlePos  = get(t2, 'position');
    %     titlePos(2) = 1000;
        set( t2 , 'position' , [400 2.3e5 0]);

        xlabel('displacement [mm]')
        ylabel('load [N]')
        axis([0 800 -1e5 2e5])
    %     pbaspect([1.4 1 1])

        frame = getframe(gcf);
        writeVideo(vid,frame);
    end
    fprintf('%f percentage done\n',i/increments*100)
end

% Plot deformed
% Coord = new_coord(Coord_0,v_hat);
% [Ex, Ey] = coordxtr(Edof, Coord, Dof, 2);
% plotpar = [2 2 1];
% sfac = 1;
% Ed = extract(Edof, v_hat);
% eldisp2(Ex, Ey, Ed, plotpar, sfac);
% figure
% axes('Position',[0 0 1 1])
% movie(M,5)
% movie2avi(M,'../response.avi','Compression','Cinepak');
if save_video
    close(vid);
end

figure
plot(response_plot(:,1),response_plot(:,2))
title('Arc length, Load/displacement')
xlabel('displacement [mm]')
ylabel('load [N]')
