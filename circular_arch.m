%buckling of deep cicular arch
%creates matrices Edof, dof, and node_coords 
function [Edof, node_coords, dof] = circular_arch() 
R = 1000; %mm radius
H = 400; %mm height
h = 10; %mm thickness
n_elements = 20; %number of beam elements
L = 1600; %mm distance between hinges
E = 2.1e5; %N/mm^2 elastic modulus
nu = 0; % poisson's ratio

theta_L = asin((R-H)/R); %rad theta when (x,y) = (L,0)
theta_0 = pi - theta_L; %rad theta when (x,y) = (0,0)

delta_theta = (theta_0 - theta_L)/n_elements; %difference in arc positions of each beam element

theta_list = zeros(21,1);

for i = 1:21
    theta_list(i) = theta_0 - delta_theta*(i-1); %list containing angles representing points along the arch
end

node_coords = zeros(length(theta_list), 2); %matrix containing all (x,y) coordinates of the beams
dof = zeros(length(theta_list), 3); %matrix containing all degrees of freedom
Edof = zeros(n_elements,7); % matrix containing first the beam number in column one, then the degrees of freedom in the two nodes of the beam

for i = 1:(n_elements)
    Edof(i,1) = i;
    Edof(i,2) = i*3-2;
    Edof(i,3) = i*3-1;
    Edof(i,4) = i*3;
    Edof(i,5) = (i+1)*3-2;
    Edof(i,6) = (i+1)*3-1;
    Edof(i,7) = (i+1)*3;
end

for i = 1:length(theta_list)
    node_coords(i,1) = R*cos(theta_list(i)) + 0.5*L;  %calculates x coordinate based on angle 
    node_coords(i,2) = R*sin(theta_list(i)) - (R-H); %calculates y coordinate
    dof(i,1) = i*3-2;
    dof(i,2) = i*3-1;
    dof(i,3) = i*3;   
end


    %skriver noe for å logge meg inn