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


scenename = 'dof';

fprintf('\nScene name: %s\n', scenename);
fprintf('\nScene building\n');
tic

% Materials
difgrey = diffuse(black, grey1, 1);
difgrey2 = diffuse(black, grey2, 0.5);

% Objects       
point2 = sphere(difgrey2, transformmatrix());
point2.transformation.uniformscale(0.2);
point2.transformation.translate([-0.5, 1, 0]);
point3 = sphere(difgrey2, transformmatrix());
point3.transformation.uniformscale(0.2);
point3.transformation.translate([0, 2, 0]);
point4 = sphere(difgrey2, transformmatrix());
point4.transformation.uniformscale(0.2);
point4.transformation.translate([0.5, 3, 0]);
point5 = sphere(difgrey2, transformmatrix());
point5.transformation.uniformscale(0.2);
point5.transformation.translate([1, 4, 0]);
point6 = sphere(difgrey2, transformmatrix());
point6.transformation.uniformscale(0.2);
point6.transformation.translate([1.5, 5, 0]);

planegrey1 = triangle(difgrey, [-2, 4, -0.5; -2, 0, -0.5; 2, 0, -0.5], [], [], neutralmatrix);
planegrey2 = triangle(difgrey, [-2, 4, -0.5; 2, 0, -0.5; 2, 4, -0.5], [], [], neutralmatrix);

ascene = scene(planegrey1, planegrey2, point2, point3, point4, point5, point6);

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