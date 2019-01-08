%% Scene

% Colours
load colours_mat colours

% General stuff
air = refractive(colours.black, colours.white, 1.001, struct('ind', 0), nonabsorber()); %%% CHECK generate_scene is 10x slower when putting [] as is_in, this is a workaround


scenename = 'piper';

fprintf('\nScene name: %s\n', scenename);
fprintf('\nScene building\n');
tic

% Materials
%difgrey = diffuse(colours.black, colours.grey1, 1);
coating = reflective(colours.black, colours.white);
plane_mat1 = diffuse_tex(colours.black, texture('.\assets\piper_pa18_obj\piper_diffuse.jpg'), 1);
plane_mat = fresnelmix(plane_mat1, coating, 1.5);

% Objects 
%planegrey1 = triangle(difgrey, [-2, 4, -0.5; -2, -4, -0.5; 2, -4, -0.5], [], [], neutralmatrix);
%planegrey2 = triangle(difgrey, [-2, 4, -0.5; 2, -4, -0.5; 2, 4, -0.5], [], [], neutralmatrix);

plane = mesh(mesh_geometry('.\assets\piper_pa18_obj\piper_pa18.obj'), plane_mat, transformmatrix());
plane.transformation.rotatex(pi/2);
plane.transformation.rotatez(pi/8);
plane.transformation.uniformscale(0.2);
plane.transformation.translate([0, 1.75, -0.25]);

%%% CHECK
plane.transformation.rotatezaxis(pi);
plane.update;

%plane.transformation.rotatez(pi/16);

ascene = scene();
ascene.addmesh(plane);

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
camera = generate_camera([1800, 1200], 'type', 'aperture', 'focalLength', 1.5);

camera.transformation.rotatez(pi);
camera.transformation.translate([0, 0, 0]);
camera.transformation.rotatex(0);

camera.update;
camera.update; % second time to kill blur
