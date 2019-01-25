%% Scene

% Colours
load colours_mat colours

% General stuff
neutralmatrix = transformmatrix(); % Should never be changed, used for triangles
air = refractive(colours.black, colours.white, 1.001, struct('ind', 0), nonabsorber()); %%% CHECK generate_scene is 10x slower when putting [] as is_in, this is a workaround


scenename = 'teapot';

fprintf('\nScene name: %s\n', scenename);
fprintf('\nScene building\n');
tic

% Materials
difgrey = diffuse(colours.black, colours.grey1, 1);
red_metal = reflective_fuzz(colours.black, colours.red, 2, 1);
coating = reflective(colours.black, colours.white);
teapotmat = fresnelmix(red_metal, coating, 1.5);
glass = reflective_refractive(colours.black, colours.white, 1.5, air, absorber(colours.black, colours.white, 100, 100));

% Objects
planegrey3 = triangle(difgrey, [-2, 4, -0.5; -2, 0, -0.5; 2, 0, -0.5], [], [], neutralmatrix);
planegrey4 = triangle(difgrey, [-2, 4, -0.5; 2, 0, -0.5; 2, 4, -0.5], [], [], neutralmatrix);

teapot = mesh(mesh_geometry('.\assets\teapot2.obj'), teapotmat, transformmatrix());
teapot.transformation.rotatex(pi/2);
%teapot.transformation.rotatez(pi/16 + pi/2);
teapot.transformation.rotatez(-7 * pi/8);
teapot.transformation.uniformscale(0.5);
teapot.transformation.translate([0, 3, 0]);

teapot.update;
teapot.transformation.rotatez(pi/4);

ascene = scene(planegrey3, planegrey4);
ascene.addmesh(teapot);

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
camera = generate_camera([1800, 1200], 'bg', 'grey', 'subpix', 1, 'type', 'aperture', 'focallength', 3); 

%camera.transformation.rotatez(-pi/6);
%camera.transformation.translate([-1, -2, 0]);
%camera.transformation.rotatex(-pi/8);

camera.update;
camera.update; % second time to kill blur