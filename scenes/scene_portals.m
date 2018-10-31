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


scenename = 'portals';

fprintf('\nScene name: %s\n', scenename);
fprintf('\nScene building\n');
tic

% Materials
difgrey = diffuse(black, grey1, 1);
portalmat11 = portal(transformmatrix(), air);
portalmat21 = portal(transformmatrix(), air);
portalmat11.transformation.rotatez(pi);
portalmat11.transformation.translate([0 -3 0]);
portalmat21.transformation.translate([0 3 0]);
portalmat21.transformation.rotatez(pi);
diffuseorange = diffuse(orange, white, 1);
diffuseteal = diffuse(teal, white, 1);
portalmat = fresnelmix_in(portalmat11, diffuseorange, 1.5);
portalmat2 = fresnelmix_in(portalmat21, diffuseteal, 1.5);

% Objects 
planegrey1 = triangle(difgrey, [-2, 4, -0.5; -2, 0, -0.5; 2, 0, -0.5], [], [], neutralmatrix);
planegrey2 = triangle(difgrey, [-2, 4, -0.5; 2, 0, -0.5; 2, 4, -0.5], [], [], neutralmatrix);

portalsphere = sphere(portalmat, transformmatrix());
portalsphere.transformation.uniformscale(0.75);
portalsphere.transformation.translate([0 0 0]);

portalsphere2 = sphere(portalmat2, transformmatrix());
portalsphere2.transformation.uniformscale(0.77);
portalsphere2.transformation.translate([0 -3 0]);

%ascene = scene(planegrey1, planegrey2, portalsphere);
ascene = scene(portalsphere, portalsphere2);

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