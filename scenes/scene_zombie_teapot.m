%% Scene

% Colours
load colours_mat colours

% General stuff
neutralmatrix = transformmatrix(); % Should never be changed, used for triangles
air = refractive(colours.black, colours.white, 1.001, 0, nonabsorber()); %%% CHECK generate_scene is 10x slower when putting [] as is_in, this is a workaround


scenename = 'zombie';
filename = next_filename(['.', filesep, 'images', filesep, scenename, '.png']);

fprintf('\nScene name: %s\n', scenename);
fprintf('\nScene building\n');
tic

% Materials
difgrey = diffuse(colours.black, colours.grey1, 1);
red_metal = reflective_fuzz(colours.black, colours.red, 2, 1);
green_goo = reflective_refractive(colours.black, colours.white, 1.33, 10, scatterer_exp(colours.black, colours.green, 0.05, 0.05, 0.05, 1, 1)); % 0.01 scattering distance is good
coating = reflective(colours.black, colours.white);
zombiemat = fresnelmix(red_metal, coating, 1.5);
glass = reflective_refractive(colours.black, colours.white, 1.5, air, nonabsorber());
diflight = diffuse(colours.white * 8, colours.white, 1);

% Objects
planegrey3 = triangle(difgrey, [-2, 4, -0.5; -2, 0, -0.5; 2, 0, -0.5], [], [], neutralmatrix);
planegrey4 = triangle(difgrey, [-2, 4, -0.5; 2, 0, -0.5; 2, 4, -0.5], [], [], neutralmatrix);

light = sphere(diflight, transformmatrix());
light.transformation.uniformscale(0.25);
light.transformation.translate([0, 2, 0.5]);

zombie = mesh(mesh_geometry('.\assets\Zombie_Beast4_test.obj'), green_goo, transformmatrix());
zombie.transformation.rotatex(pi/2);
zombie.transformation.rotatez(-pi/16);
zombie.transformation.uniformscale(0.025);
zombie.transformation.translate([0, 1.5, -0.53]);

zombie.update;

ascene = scene(planegrey3, planegrey4, light);
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
camera = generate_camera([1800, 1200], 'bg', 'night', 'subpix', 1, 'type', 'aperture', 'focallength', 1.5, 'maxbounces', 32, 'material', {air, air}, 'file', filename); 

%camera.transformation.rotatez(-pi/6);
%camera.transformation.translate([-1, -2, 0]);
%camera.transformation.rotatex(-pi/8);

camera.update;
camera.update; % second time to kill blur

camera.accumulate(ascene);