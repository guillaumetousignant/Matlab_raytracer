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


scenename = 'map';

fprintf('\nScene name: %s\n', scenename);
fprintf('\nScene building\n');
tic

% Materials
difgreen = diffuse(black, green, 1);
earthmat = diffuse_tex(black, texture('.\assets\earth_2048.png'), 1);

% Objects
ground = sphere(difgreen, transformmatrix());
ground.transformation.uniformscale(100);
ground.transformation.translate([0, 0, -101]);

triangleearth1 = triangle(earthmat, [-1, 4, 1; -1, 4, -1; 1, 4, -1], [0, -1, 0; 0, -1, 0; 0, -1, 0], [0, 1; 0, 0; 1, 0], neutralmatrix);
triangleearth2 = triangle(earthmat, [-1, 4, 1; 1, 4, -1; 1, 4, 1], [0, -1, 0; 0, -1, 0; 0, -1, 0], [0, 1; 1, 0; 1, 1], neutralmatrix);

ascene = scene(ground, triangleearth1, triangleearth2);

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