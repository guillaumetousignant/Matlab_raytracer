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


scenename = 'scattering';

fprintf('\nScene name: %s\n', scenename);
fprintf('\nScene building\n');
tic

% Materials
difgrey = diffuse(black, grey1, 1);
scattering_mat1 = reflective_refractive(black, white, 1.5, air, scatterer_exp(black, red, 0.05, 0.05, 0.01, 0.2, 1));
scattering_mat2 = reflective_refractive(black, white, 1.5, air, scatterer_exp(black, red, 0.05, 0.05, 0.01, 0.5, 1));
scattering_mat3 = reflective_refractive(black, white, 1.5, air, scatterer_exp(black, red, 0.05, 0.05, 0.01, 1, 1));
scattering_mat4 = reflective_refractive(black, white, 1.5, air, scatterer_exp(black, red, 0.05, 0.05, 0.01, 2, 1));
scattering_mat5 = reflective_refractive(black, white, 1.5, air, scatterer_exp(black, red, 0.05, 0.05, 0.01, 5, 1));

% Objects
planegrey1 = triangle(difgrey, [-2, 4, -0.25; -2, 0, -0.25; 2, 0, -0.25], [], [], transformmatrix());
planegrey1.transformation.rotatezaxis(pi);
planegrey2 = triangle(difgrey, [-2, 4, -0.25; 2, 0, -0.25; 2, 4, -0.25], [], [], transformmatrix());
planegrey2.transformation.rotatezaxis(pi);

angles = -30:15:30;

scsphere1 = sphere(scattering_mat1, transformmatrix()); %%% CHECK added rotation.
scsphere1.transformation.uniformscale(0.2);
scsphere1.transformation.translate([2 * sind(angles(1)), 2 * cosd(angles(1)), 0]);
scsphere1.transformation.rotatezaxis(pi);
scsphere2 = sphere(scattering_mat2, transformmatrix());
scsphere2.transformation.uniformscale(0.2);
scsphere2.transformation.translate([2 * sind(angles(2)), 2 * cosd(angles(2)), 0]);
scsphere2.transformation.rotatezaxis(pi);
scsphere3 = sphere(scattering_mat3, transformmatrix());
scsphere3.transformation.uniformscale(0.2);
scsphere3.transformation.translate([2 * sind(angles(3)), 2 * cosd(angles(3)), 0]);
scsphere3.transformation.rotatezaxis(pi);
scsphere4 = sphere(scattering_mat4, transformmatrix());
scsphere4.transformation.uniformscale(0.2);
scsphere4.transformation.translate([2 * sind(angles(4)), 2 * cosd(angles(4)), 0]);
scsphere4.transformation.rotatezaxis(pi);
scsphere5 = sphere(scattering_mat5, transformmatrix());
scsphere5.transformation.uniformscale(0.2);
scsphere5.transformation.translate([2 * sind(angles(5)), 2 * cosd(angles(5)), 0]);
scsphere5.transformation.rotatezaxis(pi);

ascene = scene(scsphere1, scsphere2, scsphere3, scsphere4, scsphere5, planegrey1, planegrey2);

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