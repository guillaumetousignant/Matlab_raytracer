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
wood_colour = [0.8549, 0.7882, 0.5882];

% General stuff
neutralmatrix = transformmatrix(); % Should never be changed, used for triangles
air = refractive(black, white, 1.001, struct('ind', 0), nonabsorber()); %%% CHECK generate_scene is 10x slower when putting [] as is_in, this is a workaround


scenename = 'spa';

fprintf('\nScene name: %s\n', scenename);
fprintf('\nScene building\n');
tic

% Materials
coating = reflective(black, white);

wood_mat = diffuse(black, wood_colour, 0);

metal1 = reflective_fuzz(black, grey2, 2, 1);
metal = fresnelmix(metal1, coating, 1.5);

light1_mat = diffuse(white * 2, white, 1);
light2_mat = diffuse(yellow * 2, yellow, 1);

tile_mat1 = diffuse(black, gemcolor, 1);
tile_mat = fresnelmix(tile_mat1, coating, 1.5);

spa_mats = struct('lambert4SG', light1_mat, 'lambert5SG', light2_mat, ...
                'blinn2SG', metal, 'blinn1SG', tile_mat, 'lambert3SG', wood_mat);

% Objects
roommesh = mesh(mesh_geometry('.\assets\Room.obj'), spa_mats, transformmatrix());
%tiemesh.transformation.rotatex(-pi/2);
%tiemesh.transformation.rotatez(pi/16);
roommesh.transformation.uniformscale(0.005);
%tiemesh.transformation.translate([0, 3, -0.3]); 
roommesh.update;

ascene = scene();
ascene.addmesh(roommesh);

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