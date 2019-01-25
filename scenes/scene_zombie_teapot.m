%% Scene

% Colours
yellow = [0.98, 1, 0.9];
purple = [0.98, 0.7, 0.85];
green = [0.8, 0.95, 0.6];
white = [1, 1, 1];
black = [0, 0, 0];
grey1 = [0.5, 0.5, 0.5];
grey2 = [0.75, 0.75, 0.75];
blue = [0.1, 0.4, 0.8];
turquoise = [0.6, 0.95, 0.8];
watercolour = [0.6, 0.9, 1];
red = [0.9568627450980392, 0.2784313725490196, 0.2784313725490196];
gemcolor = [0 0.9 1];
orange = [1, 0.6039, 0];
teal = [0.1529, 0.6549, 0.8471];

% General stuff
neutralmatrix = transformmatrix(); % Should never be changed, used for triangles
air = refractive(black, white, 1.001, struct('ind', 0), nonabsorber()); %%% CHECK generate_scene is 10x slower when putting [] as is_in, this is a workaround


scenename = 'teapot';

fprintf('\nScene name: %s\n', scenename);
fprintf('\nScene building\n');
tic

% Materials
difgrey = diffuse(black, grey1, 1);
red_metal = reflective_fuzz(black, red, 2, 1);
green_goo = reflective_refractive(black, white, 1.5, air, scatterer_exp(black, green, 0.05, 0.05, 0.01, 1, 1));
coating = reflective(black, white);
zombiemat = fresnelmix(red_metal, coating, 1.5);
glass = reflective_refractive(black, white, 1.5, air, nonabsorber());

% Objects
planegrey3 = triangle(difgrey, [-2, 4, -0.5; -2, 0, -0.5; 2, 0, -0.5], [], [], neutralmatrix);
planegrey4 = triangle(difgrey, [-2, 4, -0.5; 2, 0, -0.5; 2, 4, -0.5], [], [], neutralmatrix);

zombie = mesh(mesh_geometry('.\assets\Zombie_Beast4_test.obj'), green_goo, transformmatrix());
zombie.transformation.rotatex(pi/2);
zombie.transformation.rotatez(-pi/16);
zombie.transformation.uniformscale(0.025);
zombie.transformation.translate([0, 1.5, -0.53]);

zombie.update;

ascene = scene(planegrey3, planegrey4);
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
camera = generate_camera([1800, 1200], 'bg', 'day', 'subpix', 1, 'type', 'aperture', 'focallength', 1.5, 'maxbounces', 32); 

%camera.transformation.rotatez(-pi/6);
%camera.transformation.translate([-1, -2, 0]);
%camera.transformation.rotatex(-pi/8);

camera.update;
camera.update; % second time to kill blur