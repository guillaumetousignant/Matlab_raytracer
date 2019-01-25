%% Scene

% Colours
load colours_mat colours

% General stuff
neutralmatrix = transformmatrix(); % Should never be changed, used for triangles
air = refractive(colours.black, colours.white, 1.001, struct('ind', 0), nonabsorber()); %%% CHECK generate_scene is 10x slower when putting [] as is_in, this is a workaround


scenename = 'flyer';

fprintf('\nScene name: %s\n', scenename);
fprintf('\nScene building\n');
tic

% Materials
difgrey = diffuse(colours.black, colours.grey1, 1);

coating = reflective(colours.black, colours.white);
eyemat1 = diffuse(colours.black, colours.black*0.9, 1);

skinmat = reflective_refractive_fuzz(colours.black, colours.white, 1.33, air, 2, 0.1, scatterer(colours.black, colours.watercolour, 0.25, 0.25, 0.5));
bonemat = diffuse(colours.black, colours.white, 0.25);
eyemat = fresnelmix(eyemat1, coating, 1.5);
lungmat = diffuse(colours.black, colours.pink, 1); % make metal?
intmat = diffuse(colours.black, colours.gemcolor, 1); % make metal?
heartmat = diffuse(colours.black, colours.red, 1); % make metal?

fliermats = struct('blinn1SG', skinmat, 'lambert2SG', bonemat, 'lambert3SG', eyemat, 'lambert4SG', lungmat, ...
                'phong1SG', intmat, 'phongE1SG', heartmat);


% Objects 
planegrey1 = triangle(difgrey, [-2, 4, -0.5; -2, -4, -0.5; 2, -4, -0.5], [], [], neutralmatrix);
planegrey2 = triangle(difgrey, [-2, 4, -0.5; 2, -4, -0.5; 2, 4, -0.5], [], [], neutralmatrix);

flyer = mesh(mesh_geometry('.\assets\Flyer0.obj'), fliermats, transformmatrix());
flyer.transformation.rotatex(pi/2);
flyer.transformation.rotatez(pi/8);
flyer.transformation.uniformscale(0.70);
flyer.transformation.translate([0.85, 2, -1.5]);

%%% CHECK
flyer.transformation.rotatezaxis(pi);
planegrey1.transformation.rotatezaxis(pi);
planegrey2.transformation.rotatezaxis(pi);
flyer.update;
planegrey1.update;
planegrey2.update;

%flyer.transformation.rotatez(pi/16);

ascene = scene();
ascene.addmesh(flyer);

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
camera = generate_camera([1800, 1200], 'type', 'cam', 'focalLength', 0.01, 'bg', 'beach', 'aperture', 0.025, 'maxbounces', 32);

camera.transformation.rotatez(pi);
%camera.transformation.translate([-1, -2, 0]);
%camera.transformation.rotatex(-pi/8);

camera.update;
camera.autofocus(ascene, [0.5 0.5]);
camera.update; % second time to kill blur