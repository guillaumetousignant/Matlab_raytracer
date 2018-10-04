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


scenename = 'room';

fprintf('\nScene name: %s\n', scenename);
fprintf('\nScene building\n');
tic

% Materials
difgrey = diffuse(black, grey1, 1);        
%goomat = reflective_refractive_fuzz(black, white, 1.4, air, 1, 0.03, absorber(turquoise, white, 100, 1));
goomat = reflective_refractive(black, white, 1.4, air, absorber(turquoise, white, 5, 100));

% Objects
goo = sphere(goomat, transformmatrix());
goo.transformation.translate([0, 3, 0]);

wallfront = sphere(difgrey, transformmatrix());
wallfront.transformation.uniformscale(1000);
wallfront.transformation.translate([0, -1000.5, 0]);
wallback = sphere(difgrey, transformmatrix());
wallback.transformation.uniformscale(1000);
wallback.transformation.translate([0, 1005, 0]);
walltop = sphere(difgrey, transformmatrix());
walltop.transformation.uniformscale(1000);
walltop.transformation.translate([0, 0, 1003]);
wallbottom = sphere(difgrey, transformmatrix());
wallbottom.transformation.uniformscale(1000);
wallbottom.transformation.translate([0, 0, -1001]);
wallleft = sphere(difgrey, transformmatrix());
wallleft.transformation.uniformscale(1000);
wallleft.transformation.translate([1002, 0, 0]);
wallright = sphere(difgrey, transformmatrix());
wallright.transformation.uniformscale(1000);
wallright.transformation.translate([-1002, 0, 0]);

ascene = scene(wallfront, wallback, walltop, wallbottom, wallleft, wallright, goo);

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