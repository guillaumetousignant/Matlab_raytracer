%% Scene

% Colours
load colours_mat colours

% General stuff
neutralmatrix = transformmatrix(); % Should never be changed, used for triangles
air = refractive(colours.black, colours.white, 1.001, 0, nonabsorber()); %%% CHECK generate_scene is 10x slower when putting [] as is_in, this is a workaround


scenename = 'overlap';
filename = next_filename(['.', filesep, 'images', filesep, scenename, '.png']);

fprintf('\nScene name: %s\n', scenename);
fprintf('\nScene building\n');
tic

% Materials
difgrey = diffuse(colours.black, colours.grey1, 1);
glass = refractive(colours.black, colours.white, 1.5, 30, absorber(colours.black, colours.red, 1000, 2));
glass2 = refractive(colours.black, colours.white, 1.5, 20, absorber(colours.black, colours.watercolour, 1000, 2));

% Objects
planegrey1 = triangle(difgrey, [-1000, 1000, -1; -1000, -1000, -1; 1000, -1000, -1], [], [], neutralmatrix);
planegrey2 = triangle(difgrey, [-1000, 1000, -1; 1000, -1000, -1; 1000, 1000, -1], [], [], neutralmatrix);

sphere1 = sphere(glass, transformmatrix());
sphere1.transformation.translate([-0.66, 3, 0]);
sphere2 = sphere(glass2, transformmatrix());
sphere2.transformation.translate([0.66, 3, 0]);

ascene = scene(sphere1, sphere2, planegrey1, planegrey2);

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
upvector = [1, 0, 1];
upvector = upvector/norm(upvector);
camera = generate_camera([1800, 1200], 'bg', 'beach', 'type', 'cam', 'file', filename, 'material', air); 

%camera.transformation.rotatez(-pi/6);
%camera.transformation.translate([-1, -2, 0]);
%camera.transformation.rotatex(-pi/16);

camera.update;
camera.update; % second time to kill blur

camera.accumulate(ascene);