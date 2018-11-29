%% Scene

% Colours
load colours_mat colours

% General stuff
neutralmatrix = transformmatrix(); % Should never be changed, used for triangles
air = refractive(colours.black, colours.white, 1.001, struct('ind', 0), nonabsorber()); %%% CHECK generate_scene is 10x slower when putting [] as is_in, this is a workaround


scenename = 'zombie';

fprintf('\nScene name: %s\n', scenename);
fprintf('\nScene building\n');
tic

% Materials
difgrey = diffuse(colours.black, colours.grey1, 1);
zombiemat = diffuse_tex(colours.black, texture('.\assets\Zombie beast_texture5.jpg'), 1);

% Objects 
planegrey1 = triangle(difgrey, [-2, 4, -0.5; -2, -4, -0.5; 2, -4, -0.5], [], [], neutralmatrix);
planegrey2 = triangle(difgrey, [-2, 4, -0.5; 2, -4, -0.5; 2, 4, -0.5], [], [], neutralmatrix);

zombie = mesh(mesh_geometry('.\assets\Zombie_Beast4_test.obj'), zombiemat, transformmatrix());
zombie.transformation.rotatex(pi/2);
zombie.transformation.rotatez(-pi/16);
zombie.transformation.uniformscale(0.025);
zombie.transformation.translate([0, 2, -0.53]);

%%% CHECK
zombie.transformation.rotatezaxis(pi);
planegrey1.transformation.rotatezaxis(pi);
planegrey2.transformation.rotatezaxis(pi);
zombie.update;
planegrey1.update;
planegrey2.update;

%zombie.transformation.rotatez(pi/16);

ascene = scene(planegrey1, planegrey2);
ascene.addmesh(zombie);

toc

fprintf('\nScene updating\n');
tic
ascene.update;
toc

fprintf('\nAcceleration structure building\n');
tic
ascene.buildacc;
toc

%save scene.mat ascene

%% Camera
camera = generate_camera([1800, 1200], 'type', '3daperture', 'focalLength', 0.01, 'bg', 'beach');

camera.transformation.rotatez(pi);
%camera.transformation.translate([-1, -2, 0]);
%camera.transformation.rotatex(-pi/8);

camera.update;
camera.autofocus(ascene, [0.5 0.5]);
camera.update; % second time to kill blur