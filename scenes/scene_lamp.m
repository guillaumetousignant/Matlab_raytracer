%% Scene

% Colours
load colours_mat colours

% General stuff
neutralmatrix = transformmatrix(); % Should never be changed, used for triangles
air = refractive(colours.black, colours.white, 1.001, struct('ind', 0), nonabsorber()); %%% CHECK generate_scene is 10x slower when putting [] as is_in, this is a workaround
air2 = refractive(colours.black, colours.white, 1.001, air, scatterer(colours.black, colours.white, 1000, 1000, 2)); 


scenename = 'lamp';

fprintf('\nScene name: %s\n', scenename);
fprintf('\nScene building\n');
tic

% Materials
difgrey = diffuse(colours.black, colours.grey1, 1);
metal1 = reflective_fuzz(colours.black, colours.grey1, 5, 1);
coating = reflective(colours.black, colours.white);
metal = fresnelmix(metal1, coating, 1.5);
diflight = diffuse(colours.white * 256, colours.white, 1);

lamp_mats = struct('initialShadingGroup', diflight, 'phong1SG', metal);

% Objects 
planegrey1 = triangle(difgrey, [-2, 4, -0.5; -2, -4, -0.5; 2, -4, -0.5], [], [], neutralmatrix);
planegrey2 = triangle(difgrey, [-2, 4, -0.5; 2, -4, -0.5; 2, 4, -0.5], [], [], neutralmatrix);

sphereair = sphere(air2, transformmatrix());
sphereair.transformation.translate([0, 0, 0]);
sphereair.transformation.uniformscale(5);

lamp = mesh(mesh_geometry('.\assets\lamp.obj'), lamp_mats, transformmatrix());
lamp.transformation.rotatex(pi/2);
lamp.transformation.rotatez(-pi/2.5);
lamp.transformation.uniformscale(0.025);
lamp.transformation.translate([0.5, 2, -0.5]);

%%% CHECK
lamp.transformation.rotatezaxis(pi);
planegrey1.transformation.rotatezaxis(pi);
planegrey2.transformation.rotatezaxis(pi);
lamp.update;
planegrey1.update;
planegrey2.update;

%zombie.transformation.rotatez(pi/16);

ascene = scene(planegrey1, planegrey2, sphereair);
ascene.addmesh(lamp);

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
camera = generate_camera([1800, 1200], 'type', 'aperture', 'focalLength', 2, 'bg', 'night', 'aperture', 0.01, 'material', air2); % bg night

camera.transformation.rotatez(pi);
%camera.transformation.translate([-1, -2, 0]);
%camera.transformation.rotatex(-pi/8);

camera.update;
%camera.autofocus(ascene, [0.5 0.5]);
camera.update; % second time to kill blur