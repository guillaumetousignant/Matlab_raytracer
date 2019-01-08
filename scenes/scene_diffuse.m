%% Scene

% Colours
load colours_mat colours

% General stuff
neutralmatrix = transformmatrix(); % Should never be changed, used for triangles
air = refractive(colours.black, colours.white, 1.001, struct('ind', 0), nonabsorber()); %%% CHECK generate_scene is 10x slower when putting [] as is_in, this is a workaround


scenename = 'diffuse';

fprintf('\nScene name: %s\n', scenename);
fprintf('\nScene building\n');
tic

% Materials
difgrey = diffuse(colours.black, colours.grey1, 1);
difgrey2 = diffuse(colours.black, colours.grey2, 1);

% Objects
planegrey1 = triangle(difgrey, [-1000, 1000, -1; -1000, -1000, -1; 1000, -1000, -1], [], [], neutralmatrix);
planegrey2 = triangle(difgrey, [-1000, 1000, -1; 1000, -1000, -1; 1000, 1000, -1], [], [], neutralmatrix);

spheregrey = sphere(difgrey2, transformmatrix());
spheregrey.transformation.translate([0, 4, 0]);

ascene = scene(spheregrey, planegrey1, planegrey2);

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
camera = generate_camera([300, 200], 'bg', 'grey', 'subpix', 1, 'type', 'cam'); 

%camera.transformation.rotatez(-pi/6);
%camera.transformation.translate([-1, -2, 0]);
%camera.transformation.rotatex(-pi/8);

camera.update;
camera.update; % second time to kill blur