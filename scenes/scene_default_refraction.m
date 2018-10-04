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


scenename = 'default_refraction';

fprintf('\nScene name: %s\n', scenename);
fprintf('\nScene building\n');
tic

% Materials
diflight = diffuse(white * 2, white, 1);
difgreen = diffuse(black, green, 1);
glass = reflective_refractive(black, white, 1.5, air, absorber(black, white, 100, 100));

% Objects
light = sphere(diflight, transformmatrix());
light.transformation.uniformscale(0.75);
light.transformation.translate([0, 3, 0.8]);

sphereglass2 = sphere(glass, transformmatrix());
sphereglass2.transformation.uniformscale(0.5);
sphereglass2.transformation.translate([1, 2, 0.5]);

sphereglass3 = sphere(glass, transformmatrix());
sphereglass3.transformation.uniformscale(1.5);
sphereglass3.transformation.translate([-1.5, 4, -0.8]);

ground = sphere(difgreen, transformmatrix());
ground.transformation.uniformscale(100);
ground.transformation.translate([0, 0, -101]);

cube = mesh(mesh_geometry('.\assets\cube.obj'), glass, transformmatrix());
cube.transformation.uniformscale(0.7);
cube.transformation.rotatez(pi/8);
cube.transformation.translate([0, 3, 0.2]);

ascene = scene(sphereglass2, sphereglass3, light, ground);
ascene.addmesh(cube);

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

%camera.transformation.rotatez(-pi/6);
%camera.transformation.translate([-1, -2, 0]);
%camera.transformation.rotatex(-pi/8);

camera.update;
camera.update; % second time to kill blur