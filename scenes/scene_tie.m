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


scenename = 'tie';

fprintf('\nScene name: %s\n', scenename);
fprintf('\nScene building\n');
tic

% Materials
difgrey = diffuse(black, grey1, 1);
coating = reflective(black, white);
blackred = diffuse(black, [0.0471, 0, 0], 1);

hullblue1 = diffuse(black, [0.7176, 0.7804, 0.7922], 1);
hullblue = fresnelmix(hullblue1, coating, 1.5);

graymat1 = diffuse(black, [0.5725, 0.5725, 0.5725], 1);
graymat = fresnelmix(graymat1, coating, 1.5);

midgraymat1 = diffuse(black, [0.5412, 0.5412, 0.5412], 1);
midgraymat = fresnelmix(midgraymat1, coating, 1.5);

rib_graymat1 = diffuse(black, [0.3294, 0.3294, 0.3294], 1);
rib_graymat = fresnelmix(rib_graymat1, coating, 1.5);

drk_graymat1 = diffuse(black, [0.4745, 0.4745, 0.4745], 1);
drk_graymat = fresnelmix(drk_graymat1, coating, 1.5);

panl_blk1 = diffuse(black, [0.0078, 0.0078, 0.0078], 1);
panl_blk = fresnelmix(panl_blk1, coating, 1.5);

englowred = diffuse([0.9882, 0, 0], [0.9882, 0, 0], 1);

lasered = diffuse([0.6784, 0.3647, 0.4000], [0.6784, 0.3647, 0.4000], 1);

tiemats = struct('blackred', blackred, 'hullblue', hullblue, 'gray', graymat, 'mid_gray', midgraymat, ...
                'englored', englowred, 'drk_gray', drk_graymat, 'rib_gray', rib_graymat, 'panl_blk', panl_blk, 'lasered', lasered);

% Objects
planegrey3 = triangle(difgrey, [-2, 4, -0.5; -2, 0, -0.5; 2, 0, -0.5], [], [], neutralmatrix);
planegrey4 = triangle(difgrey, [-2, 4, -0.5; 2, 0, -0.5; 2, 4, -0.5], [], [], neutralmatrix);

tiemesh = mesh(mesh_geometry('.\assets\tie_fighter\TIE-fighter.obj'), tiemats, transformmatrix());
%tiemesh.transformation.rotatex(-pi/2);
%tiemesh.transformation.rotatez(pi/16);
tiemesh.transformation.uniformscale(0.005);
%tiemesh.transformation.translate([0, 3, -0.3]); 
tiemesh.update;

%ascene = scene(planegrey3, planegrey4);
ascene = scene();
ascene.addmesh(tiemesh);

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