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


scenename = 'glace';

fprintf('\nScene name: %s\n', scenename);
fprintf('\nScene building\n');
tic

% Materials
bandemat = diffuse(black, grey1, 1);
diflight = diffuse(white * 5, white, 1);
glacemat = reflective_refractive_fuzz(black, white, 1.33, air, 1, 0.01, scatterer(black, white, 1, 1, 0.5)); % make mix
peinturemat = diffuse_tex(black, texture('.\assets\rink2.jpg'), 1);

glacemats = struct('lambert2SG', glacemat, 'lambert3SG', peinturemat, 'lambert4SG', bandemat);

% Objects
glacemesh = mesh(mesh_geometry('.\assets\Glace.obj'), glacemats, transformmatrix());
glacemesh.transformation.rotatex(pi/2);
%glacemesh.transformation.rotatez(pi/8);
glacemesh.transformation.uniformscale(0.1);
glacemesh.transformation.translate([0, 0, -1]); 
glacemesh.update;

light1 = sphere(diflight, transformmatrix());
light2 = sphere(diflight, transformmatrix());
light3 = sphere(diflight, transformmatrix());
light4 = sphere(diflight, transformmatrix());
light5 = sphere(diflight, transformmatrix());
light6 = sphere(diflight, transformmatrix());
light7 = sphere(diflight, transformmatrix());
light8 = sphere(diflight, transformmatrix());

light1.transformation.translate([0.2776, 0.2460, -0.5]);
light2.transformation.translate([0.2776, 0.7381, -0.5]);
light3.transformation.translate([0.2776, -0.2460, -0.5]);
light4.transformation.translate([0.2776, -0.7381, -0.5]);
light5.transformation.translate([-0.2776, 0.2460, -0.5]);
light6.transformation.translate([-0.2776, 0.7381, -0.5]);
light7.transformation.translate([-0.2776, -0.2460, -0.5]);
light8.transformation.translate([-0.2776, -0.7381, -0.5]);

light1.transformation.uniformscale(0.1);
light2.transformation.uniformscale(0.1);
light3.transformation.uniformscale(0.1);
light4.transformation.uniformscale(0.1);
light5.transformation.uniformscale(0.1);
light6.transformation.uniformscale(0.1);
light7.transformation.uniformscale(0.1);
light8.transformation.uniformscale(0.1);

ascene = scene(light1, light2, light3, light4, light5, light6, light7, light8);
ascene.addmesh(glacemesh); 

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