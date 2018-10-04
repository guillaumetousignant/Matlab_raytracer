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


scenename = 'reflections';

fprintf('\nScene name: %s\n', scenename);
fprintf('\nScene building\n');
tic

% Materials
difgrey = diffuse(black, grey1, 1);
coating = reflective(black, white);
metal_test11 = reflective_fuzz(black, grey2, 1, 0);
metal_test12 = reflective_fuzz(black, grey2, 1, 0.01);
metal_test13 = reflective_fuzz(black, grey2, 1, 0.05);
metal_test14 = reflective_fuzz(black, grey2, 1, 0.1);
metal_test15 = reflective_fuzz(black, grey2, 1, 1);
metal_test1 = fresnelmix(metal_test11, coating, 1.5);
metal_test2 = fresnelmix(metal_test12, coating, 1.5);
metal_test3 = fresnelmix(metal_test13, coating, 1.5);
metal_test4 = fresnelmix(metal_test14, coating, 1.5);
metal_test5 = fresnelmix(metal_test15, coating, 1.5);

% Objects  
angles = -30:15:30;
point1 = sphere(metal_test1, transformmatrix());
point1.transformation.uniformscale(0.2);
point1.transformation.translate([2 * sind(angles(1)), 2 * cosd(angles(1)), 0]);
point2 = sphere(metal_test2, transformmatrix());
point2.transformation.uniformscale(0.2);
point2.transformation.translate([2 * sind(angles(2)), 2 * cosd(angles(2)), 0]);
point3 = sphere(metal_test3, transformmatrix());
point3.transformation.uniformscale(0.2);
point3.transformation.translate([2 * sind(angles(3)), 2 * cosd(angles(3)), 0]);
point4 = sphere(metal_test4, transformmatrix());
point4.transformation.uniformscale(0.2);
point4.transformation.translate([2 * sind(angles(4)), 2 * cosd(angles(4)), 0]);
point5 = sphere(metal_test5, transformmatrix());
point5.transformation.uniformscale(0.2);
point5.transformation.translate([2 * sind(angles(5)), 2 * cosd(angles(5)), 0]);


planegrey1 = triangle(difgrey, [-2, 4, -0.5; -2, 0, -0.5; 2, 0, -0.5], [], [], neutralmatrix);
planegrey2 = triangle(difgrey, [-2, 4, -0.5; 2, 0, -0.5; 2, 4, -0.5], [], [], neutralmatrix);

ascene = scene(planegrey1, planegrey2, point1, point2, point3, point4, point5);

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