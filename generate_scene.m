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


scenename = 'earth';

fprintf('\nScene name: %s\n', scenename);
fprintf('\nScene building\n');
tic
switch lower(scenename)
    case 'earth'

        % Materials
        difgreen = diffuse(black, green, 1);
        earthmat = diffuse_tex(black, texture('.\assets\earth_2048.png'), 1);
        
        % Objects
        earth = sphere_motionblur(earthmat, transformmatrix());
        %earth.transformation.uniformscale(0.4);
        earth.transformation.translate([0, 4, 0]);
        earth.update;

        ground = sphere(difgreen, transformmatrix());
        ground.transformation.uniformscale(100);
        ground.transformation.translate([0, 0, -101]);
        
%         cube = mesh_motionblur(mesh_geometry('.\assets\cube.obj'), earthmat, transformmatrix());
%         cube.transformation.uniformscale(0.4);
%         cube.transformation.rotatez(pi/8);
%         cube.transformation.translate([0.5, 2, 0.5]);
%         cube.update;

        ascene = scene(ground, earth);
        %ascene.addmesh(cube);

    case 'map'

        % Materials
        difgreen = diffuse(black, green, 1);
        earthmat = diffuse_tex(black, texture('.\assets\earth_2048.png'), 1);

        % Objects
        ground = sphere(difgreen, transformmatrix());
        ground.transformation.uniformscale(100);
        ground.transformation.translate([0, 0, -101]);

        triangleearth1 = triangle(earthmat, [-1, 4, 1; -1, 4, -1; 1, 4, -1], [0, -1, 0; 0, -1, 0; 0, -1, 0], [0, 1; 0, 0; 1, 0], neutralmatrix);
        triangleearth2 = triangle(earthmat, [-1, 4, 1; 1, 4, -1; 1, 4, 1], [0, -1, 0; 0, -1, 0; 0, -1, 0], [0, 1; 1, 0; 1, 1], neutralmatrix);

        ascene = scene(ground, triangleearth1, triangleearth2);

    case 'cube'

        % Materials
        difgrey = diffuse(black, grey1, 1);
        earthmat = diffuse_tex(black, texture('.\assets\earth_2048.png'), 1);

        % Objects
        planegrey3 = triangle(difgrey, [-2, 4, -0.5; -2, -4, -0.5; 2, -4, -0.5], [], [], neutralmatrix);
        planegrey4 = triangle(difgrey, [-2, 4, -0.5; 2, -4, -0.5; 2, 4, -0.5], [], [], neutralmatrix);

        cube = mesh_motionblur(mesh_geometry('.\assets\cube.obj'), earthmat, transformmatrix());
        cube.transformation.uniformscale(0.5);
        cube.transformation.rotatez(pi/8);
        cube.transformation.translate([0.5, 2, 0.2]);
        cube.update;

        ascene = scene(planegrey3, planegrey4);
        ascene.addmesh(cube);

    case 'default'

        % Materials
        difpurple = diffuse(black, purple, 1);
        diflight = diffuse(white * 2, white, 1);
        difgreen = diffuse(black, green, 1);
        ref1 = reflective(black, yellow);
        glass = reflective_refractive(black, white, 1.5, air, absorber(black, white, 100, 100));

        % Objects
        spherepurple = sphere(difpurple, transformmatrix());
        spherepurple.transformation.uniformscale(0.5);
        spherepurple.transformation.translate([1, 2, 0.5]);

        mirror = sphere(ref1, transformmatrix());
        mirror.transformation.uniformscale(1.5);
        mirror.transformation.translate([-1.5, 4, -0.8]);

        light = sphere(diflight, transformmatrix());
        light.transformation.uniformscale(0.75);
        light.transformation.translate([0, 3, 0.8]);

        sphereglass = sphere(glass, transformmatrix());
        sphereglass.transformation.uniformscale(0.5);
        sphereglass.transformation.translate([0.5, 2, 0.2]);

        ground = sphere(difgreen, transformmatrix());
        ground.transformation.uniformscale(100);
        ground.transformation.translate([0, 0, -101]);
        
        ascene = scene(spherepurple, mirror, light, ground, sphereglass);

    case 'default_fuzz'

        % Materials
        difpurple = diffuse(black, purple, 1);
        diflight = diffuse(white * 2, white, 1);
        difgreen = diffuse(black, green, 1);
        ref1_fuzz = reflective_fuzz(black, yellow, 1, 0.04);
        glass_fuzz = reflective_refractive_fuzz(black, white, 1.5, air, 1, 0.03, absorber(black, white, 100, 100));

        % Objects
        spherepurple = sphere(difpurple, transformmatrix());
        spherepurple.transformation.uniformscale(0.5);
        spherepurple.transformation.translate([1, 2, 0.5]);

        mirror_fuzz = sphere(ref1_fuzz, transformmatrix());
        mirror_fuzz.transformation.uniformscale(1.5);
        mirror_fuzz.transformation.translate([-1.5, 4, -0.8]);

        light = sphere(diflight, transformmatrix());
        light.transformation.uniformscale(0.75);
        light.transformation.translate([0, 3, 0.8]);

        sphereglass_fuzz = sphere(glass_fuzz, transformmatrix());
        sphereglass_fuzz.transformation.uniformscale(0.4);
        sphereglass_fuzz.transformation.translate([0.5, 2, 0.2]);

        ground = sphere(difgreen, transformmatrix());
        ground.transformation.uniformscale(100);
        ground.transformation.translate([0, 0, -101]);

        ascene = scene(spherepurple, mirror_fuzz, light, ground, sphereglass_fuzz);

    case 'default_refraction'

        % Materials
        diflight = diffuse(white * 2, white, 1);
        difgreen = diffuse(black, green, 1);
        glass = reflective_refractive(black, white, 1.5, air, absorber(black, white, 100, 100));

        % Objects
        light = sphere(diflight, transformmatrix());
        light.transformation.uniformscale(0.75);
        light.transformation.translate([0, 3, 0.8]);

        sphereglass2 = sphere(glass, transformmatrix());
        sphereglass2.transformation.uniformscale(0.5);
        sphereglass2.transformation.translate([1, 2, 0.5]);

        sphereglass3 = sphere(glass, transformmatrix());
        sphereglass3.transformation.uniformscale(1.5);
        sphereglass3.transformation.translate([-1.5, 4, -0.8]);

        ground = sphere(difgreen, transformmatrix());
        ground.transformation.uniformscale(100);
        ground.transformation.translate([0, 0, -101]);

        cube = mesh(mesh_geometry('.\assets\cube.obj'), glass, transformmatrix());
        cube.transformation.uniformscale(0.7);
        cube.transformation.rotatez(pi/8);
        cube.transformation.translate([0, 3, 0.2]);

        ascene = scene(sphereglass2, sphereglass3, light, ground);
        ascene.addmesh(cube);

    case 'room'

        % Materials
        difgrey = diffuse(black, grey1, 1);        
        %goomat = reflective_refractive_fuzz(black, white, 1.4, air, 1, 0.03, absorber(turquoise, white, 100, 1));
        goomat = reflective_refractive(black, white, 1.4, air, absorber(turquoise, white, 5, 100));

        % Objects
        goo = sphere(goomat, transformmatrix());
        goo.transformation.translate([0, 3, 0]);

        wallfront = sphere(difgrey, transformmatrix());
        wallfront.transformation.uniformscale(1000);
        wallfront.transformation.translate([0, -1000.5, 0]);
        wallback = sphere(difgrey, transformmatrix());
        wallback.transformation.uniformscale(1000);
        wallback.transformation.translate([0, 1005, 0]);
        walltop = sphere(difgrey, transformmatrix());
        walltop.transformation.uniformscale(1000);
        walltop.transformation.translate([0, 0, 1003]);
        wallbottom = sphere(difgrey, transformmatrix());
        wallbottom.transformation.uniformscale(1000);
        wallbottom.transformation.translate([0, 0, -1001]);
        wallleft = sphere(difgrey, transformmatrix());
        wallleft.transformation.uniformscale(1000);
        wallleft.transformation.translate([1002, 0, 0]);
        wallright = sphere(difgrey, transformmatrix());
        wallright.transformation.uniformscale(1000);
        wallright.transformation.translate([-1002, 0, 0]);

        ascene = scene(wallfront, wallback, walltop, wallbottom, wallleft, wallright, goo);

    case 'diffuse'

        % Materials
        difgrey = diffuse(black, grey1, 1);
        difgrey2 = diffuse(black, grey2, 1);

        % Objects
        planegrey1 = triangle(difgrey, [-1000, 1000, -1; -1000, -1000, -1; 1000, -1000, -1], [], [], neutralmatrix);
        planegrey2 = triangle(difgrey, [-1000, 1000, -1; 1000, -1000, -1; 1000, 1000, -1], [], [], neutralmatrix);

        spheregrey = sphere(difgrey2, transformmatrix());
        spheregrey.transformation.translate([0, 4, 0]);

        ascene = scene(spheregrey, planegrey1, planegrey2);

    case 'water'

        % Materials
        difpurple = diffuse(black, purple, 1);
        diflight = diffuse(white * 2, white, 1);
        difgreen = diffuse(black, green, 1);
        ref1 = reflective(black, yellow);
        glass = reflective_refractive(black, white, 1.5, air, absorber(black, white, 100, 100));
        watermat = reflective_refractive_fuzz(black, blue, 1.33, air, 1, 0.02, absorber(black, blue, 100, 100));

        % Objects
        spherepurple = sphere(difpurple, transformmatrix());
        spherepurple.transformation.uniformscale(0.5);
        spherepurple.transformation.translate([1, 2, 0.5]);

        mirror = sphere(ref1, transformmatrix());
        mirror.transformation.uniformscale(1.5);
        mirror.transformation.translate([-1.5, 4, -0.8]);

        light = sphere(diflight, transformmatrix());
        light.transformation.uniformscale(0.75);
        light.transformation.translate([0, 3, 0.8]);

        sphereglass = sphere(glass, transformmatrix());
        sphereglass.transformation.uniformscale(0.5);
        sphereglass.transformation.translate([0.5, 2, 0.2]);

        water = sphere(watermat, transformmatrix());
        water.transformation.uniformscale(100000);
        water.transformation.translate([0, 0, -100000.7]);

        ground = sphere(difgreen, transformmatrix());
        ground.transformation.uniformscale(100);
        ground.transformation.translate([0, 0, -101]);

        ascene = scene(spherepurple, mirror, light, ground, sphereglass, water);

    case 'acceleration'

        % Materials
        difgrey = diffuse(black, grey1, 1);
        difblue = diffuse(black, blue, 1);

        % Objects
        planegrey3 = triangle(difgrey, [-2, 4, -0.5; -2, 0, -0.5; 2, 0, -0.5], [], [], neutralmatrix);
        planegrey4 = triangle(difgrey, [-2, 4, -0.5; 2, 0, -0.5; 2, 4, -0.5], [], [], neutralmatrix);

        cube = mesh(mesh_geometry('.\assets\cube.obj'), difblue, transformmatrix());
        cube.transformation.uniformscale(0.7);
        cube.transformation.rotatez(pi/8);
        cube.transformation.translate([0, 3, 0.2]);

        ascene = scene(planegrey3, planegrey4);
        ascene.addmesh(cube);

    case 'airplane'

        % Materials
        difgrey = diffuse(black, grey1, 1);
        airplanemat = diffuse_tex(black, texture('.\assets\A380.png'), 1);

        % Objects
        planegrey3 = triangle(difgrey, [-2, 4, -0.5; -2, 0, -0.5; 2, 0, -0.5], [], [], neutralmatrix);
        planegrey4 = triangle(difgrey, [-2, 4, -0.5; 2, 0, -0.5; 2, 4, -0.5], [], [], neutralmatrix);

        airplane = mesh(mesh_geometry('.\assets\A380.obj'), airplanemat, transformmatrix());
        %airplane.transformation.rotatex(-pi/2);
        %airplane.transformation.rotatez(pi/16);
        %airplane.transformation.uniformscale(0.5);
        %airplane.transformation.translate([0, 3, -0.3]); 

        ascene = scene(planegrey3, planegrey4);
        ascene.addmesh(airplane);
    
    case 'teapot'

        % Materials
        difgrey = diffuse(black, grey1, 1);
        red_metal = reflective_fuzz(black, red, 2, 1);
        coating = reflective(black, white);
        teapotmat = fresnelmix(red_metal, coating, 1.5);
        glass = reflective_refractive(black, white, 1.5, air, absorber(black, white, 100, 100));

        % Objects
        planegrey3 = triangle(difgrey, [-2, 4, -0.5; -2, 0, -0.5; 2, 0, -0.5], [], [], neutralmatrix);
        planegrey4 = triangle(difgrey, [-2, 4, -0.5; 2, 0, -0.5; 2, 4, -0.5], [], [], neutralmatrix);

        teapot = mesh(mesh_geometry('.\assets\teapot2.obj'), glass, transformmatrix());
        teapot.transformation.rotatex(pi/2);
        %teapot.transformation.rotatez(pi/16 + pi/2);
        teapot.transformation.rotatez(-pi/2);
        teapot.transformation.uniformscale(0.5);
        teapot.transformation.translate([0, 3, 0]);
        
        teapot.update;
        teapot.transformation.rotatez(pi/4);

        ascene = scene(planegrey3, planegrey4);
        ascene.addmesh(teapot);

    case 'metal teapot'

        % Materials
        difgrey = diffuse(black, grey1, 1);
        metal_test = reflective_fuzz(black, grey2, 1000, 1);

        % Objects
        planegrey3 = triangle(difgrey, [-2, 4, -0.5; -2, 0, -0.5; 2, 0, -0.5], [], [], transformmatrix());
        planegrey4 = triangle(difgrey, [-2, 4, -0.5; 2, 0, -0.5; 2, 4, -0.5], [], [], transformmatrix());

        teapot = mesh(mesh_geometry('.\assets\teapot2.obj'), metal_test, transformmatrix());
        teapot.transformation.rotatex(-pi/2);
        teapot.transformation.rotatez(pi/16 + pi/2);
        teapot.transformation.uniformscale(0.5);
        teapot.transformation.translate([0, 3, 0]); 

        ascene = scene(planegrey3, planegrey4);
        ascene.addmesh(teapot);
    
    case 'glass teapot'

        % Materials
        difgrey = diffuse(black, grey1, 1);
        glass = reflective_refractive_fuzz(black, white, 1.5, black, white, 100, air, 2, 0.01);

        % Objects
        % Objects
        planegrey3 = triangle(difgrey, [-2, 6, -0.5; -2, 0, -0.5; 2, 0, -0.5], [], [], transformmatrix());
        planegrey3.transformation.rotatezaxis(pi);
        planegrey4 = triangle(difgrey, [-2, 6, -0.5; 2, 0, -0.5; 2, 6, -0.5], [], [], transformmatrix());
        planegrey4.transformation.rotatezaxis(pi)

        teapot = mesh('.\assets\teapot2.obj', glass, transformmatrix());
        teapot.transformation.rotatex(pi/2);
        teapot.transformation.rotatez(-pi/16 - pi/2);
        teapot.transformation.uniformscale(0.5);
        teapot.transformation.translate([0, 3, 0]); 
        teapot.transformation.rotatezaxis(pi);

        ascene = scene(planegrey3, planegrey4);
        ascene.addmesh(teapot);

    case 'sphere'

        % Materials
        difgrey = diffuse(black, grey1, 1);
        glass = reflective_refractive(black, white, 1.5, air, absorber(black, white, 100, 100));

        % Objects
        planegrey3 = triangle(difgrey, [-2, 4, -0.5; -2, 0, -0.5; 2, 0, -0.5], [], [], neutralmatrix);
        planegrey4 = triangle(difgrey, [-2, 4, -0.5; 2, 0, -0.5; 2, 4, -0.5], [], [], neutralmatrix);

        spheremesh = mesh(mesh_geometry('.\assets\bigsphere.obj'), glass, transformmatrix());
        %spheremesh.transformation.rotatex(-pi/2);
        %spheremesh.transformation.rotatez(pi/16);
        %spheremesh.transformation.uniformscale(0.5);
        %spheremesh.transformation.translate([0, 3, -0.3]); 

        ascene = scene(planegrey3, planegrey4);
        ascene.addmesh(spheremesh);

    case 'empty'

        % Materials
        difwhite = diffuse(black, white, 1);

        % Objects
        point = sphere(difwhite, transformmatrix());
        point.transformation.uniformscale(0.5);
        %point.transformation.translate([0, 2, 0]);

        ascene = scene(point);

    case 'scattering'

        % Materials
        difgrey = diffuse(black, grey1, 1);
        scattering_mat1 = reflective_refractive(black, white, 1.5, air, scatterer_exp(black, red, 0.05, 0.05, 0.01, 0.2, 1));
        scattering_mat2 = reflective_refractive(black, white, 1.5, air, scatterer_exp(black, red, 0.05, 0.05, 0.01, 0.5, 1));
        scattering_mat3 = reflective_refractive(black, white, 1.5, air, scatterer_exp(black, red, 0.05, 0.05, 0.01, 1, 1));
        scattering_mat4 = reflective_refractive(black, white, 1.5, air, scatterer_exp(black, red, 0.05, 0.05, 0.01, 2, 1));
        scattering_mat5 = reflective_refractive(black, white, 1.5, air, scatterer_exp(black, red, 0.05, 0.05, 0.01, 5, 1));

        % Objects
        planegrey1 = triangle(difgrey, [-2, 4, -0.25; -2, 0, -0.25; 2, 0, -0.25], [], [], transformmatrix());
        planegrey1.transformation.rotatezaxis(pi);
        planegrey2 = triangle(difgrey, [-2, 4, -0.25; 2, 0, -0.25; 2, 4, -0.25], [], [], transformmatrix());
        planegrey2.transformation.rotatezaxis(pi);

        angles = -30:15:30;

        scsphere1 = sphere(scattering_mat1, transformmatrix()); %%% CHECK added rotation.
        scsphere1.transformation.uniformscale(0.2);
        scsphere1.transformation.translate([2 * sind(angles(1)), 2 * cosd(angles(1)), 0]);
        scsphere1.transformation.rotatezaxis(pi);
        scsphere2 = sphere(scattering_mat2, transformmatrix());
        scsphere2.transformation.uniformscale(0.2);
        scsphere2.transformation.translate([2 * sind(angles(2)), 2 * cosd(angles(2)), 0]);
        scsphere2.transformation.rotatezaxis(pi);
        scsphere3 = sphere(scattering_mat3, transformmatrix());
        scsphere3.transformation.uniformscale(0.2);
        scsphere3.transformation.translate([2 * sind(angles(3)), 2 * cosd(angles(3)), 0]);
        scsphere3.transformation.rotatezaxis(pi);
        scsphere4 = sphere(scattering_mat4, transformmatrix());
        scsphere4.transformation.uniformscale(0.2);
        scsphere4.transformation.translate([2 * sind(angles(4)), 2 * cosd(angles(4)), 0]);
        scsphere4.transformation.rotatezaxis(pi);
        scsphere5 = sphere(scattering_mat5, transformmatrix());
        scsphere5.transformation.uniformscale(0.2);
        scsphere5.transformation.translate([2 * sind(angles(5)), 2 * cosd(angles(5)), 0]);
        scsphere5.transformation.rotatezaxis(pi);

        ascene = scene(scsphere1, scsphere2, scsphere3, scsphere4, scsphere5, planegrey1, planegrey2);
		
	case 'zombie'
	
		% Materials
        difgrey = diffuse(black, grey1, 1);
		%zombiemat = diffuse_tex(black, texture('.\assets\Zombie beast_texture5.jpg'), 1);
        zombiemat = reflective_refractive(black, white, 1.5, air, scatterer(black, green, 0.5, 0.5, 0.01));
	
		% Objects 
		planegrey1 = triangle(difgrey, [-2, 4, -0.5; -2, -4, -0.5; 2, -4, -0.5], [], [], neutralmatrix);
        planegrey2 = triangle(difgrey, [-2, 4, -0.5; 2, -4, -0.5; 2, 4, -0.5], [], [], neutralmatrix);
		
		zombie = mesh(mesh_geometry('.\assets\Zombie_Beast4_test.obj'), zombiemat, transformmatrix());
    	zombie.transformation.rotatex(pi/2);
    	zombie.transformation.rotatez(-pi/16);
    	zombie.transformation.uniformscale(0.025);
    	zombie.transformation.translate([0, 2, -0.53]);
        zombie.update;
	
        %zombie.transformation.rotatez(pi/16);
        
        ascene = scene(planegrey1, planegrey2);
        ascene.addmesh(zombie);
		
    case 'beach'
		
		% Materials
		sand = diffuse(black, [0.9, 0.85, 0.7], 0.5);
        water = reflective_refractive(black, white, 1.33, air, scatterer(black, watercolour, 0.5, 0.5, 2));
		sand = mesh(mesh_geometry('.\assets\sand.obj'), sand, transformmatrix());
		water = mesh(mesh_geometry('.\assets\water.obj'), water, sand.transformation);
        
		% Objects 
        sand.transformation.rotatex(pi/2);
        sand.transformation.rotatez(5 * pi/8);
		sand.transformation.translate([0, 1, -0.4]);
		 
		ascene = scene();
        ascene.addmesh(sand);
        ascene.addmesh(water);
    
    case 'dof'

        % Materials
        difgrey = diffuse(black, grey1, 1);
        difgrey2 = diffuse(black, grey2, 0.5);

        % Objects       
        point2 = sphere(difgrey2, transformmatrix());
        point2.transformation.uniformscale(0.2);
        point2.transformation.translate([-0.5, 1, 0]);
        point3 = sphere(difgrey2, transformmatrix());
        point3.transformation.uniformscale(0.2);
        point3.transformation.translate([0, 2, 0]);
        point4 = sphere(difgrey2, transformmatrix());
        point4.transformation.uniformscale(0.2);
        point4.transformation.translate([0.5, 3, 0]);
        point5 = sphere(difgrey2, transformmatrix());
        point5.transformation.uniformscale(0.2);
        point5.transformation.translate([1, 4, 0]);
        point6 = sphere(difgrey2, transformmatrix());
        point6.transformation.uniformscale(0.2);
        point6.transformation.translate([1.5, 5, 0]);

        planegrey1 = triangle(difgrey, [-2, 4, -0.5; -2, 0, -0.5; 2, 0, -0.5], [], [], neutralmatrix);
        planegrey2 = triangle(difgrey, [-2, 4, -0.5; 2, 0, -0.5; 2, 4, -0.5], [], [], neutralmatrix);

        ascene = scene(planegrey1, planegrey2, point2, point3, point4, point5, point6);
        
    case 'reflections'
        
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

    case 'refractions'
        
        % Materials
        difgrey = diffuse(black, grey1, 1);
        glass_fuzz1 = reflective_refractive_fuzz(black, white, 1.5, air, 1, 0, absorber(black, white, 100, 100));
        glass_fuzz2 = reflective_refractive_fuzz(black, white, 1.5, air, 1, 0.001, absorber(black, white, 100, 100));
        glass_fuzz3 = reflective_refractive_fuzz(black, white, 1.5, air, 1, 0.01, absorber(black, white, 100, 100));
        glass_fuzz4 = reflective_refractive_fuzz(black, white, 1.5, air, 1, 0.1, absorber(black, white, 100, 100));
        glass_fuzz5 = reflective_refractive_fuzz(black, white, 1.5, air, 1, 1, absorber(black, white, 100, 100));
        
        % Objects  
        angles = -30:15:30;
        point1 = sphere(glass_fuzz1, transformmatrix());
        point2 = sphere(glass_fuzz2, transformmatrix());
        point3 = sphere(glass_fuzz3, transformmatrix());
        point4 = sphere(glass_fuzz4, transformmatrix());
        point5 = sphere(glass_fuzz5, transformmatrix());

        point1.transformation.uniformscale(0.2);
        point2.transformation.uniformscale(0.2);
        point3.transformation.uniformscale(0.2);
        point4.transformation.uniformscale(0.2);
        point5.transformation.uniformscale(0.2);

        point1.transformation.translate([2 * sind(angles(1)), 2 * cosd(angles(1)), 0]);
        point2.transformation.translate([2 * sind(angles(2)), 2 * cosd(angles(2)), 0]);
        point3.transformation.translate([2 * sind(angles(3)), 2 * cosd(angles(3)), 0]);
        point4.transformation.translate([2 * sind(angles(4)), 2 * cosd(angles(4)), 0]);
        point5.transformation.translate([2 * sind(angles(5)), 2 * cosd(angles(5)), 0]);

        point1.transformation.rotatezaxis(pi);
        point2.transformation.rotatezaxis(pi);
        point3.transformation.rotatezaxis(pi);
        point4.transformation.rotatezaxis(pi);
        point5.transformation.rotatezaxis(pi);
        
        planegrey1 = triangle(difgrey, [-2, 4, -0.5; -2, 0, -0.5; 2, 0, -0.5], [], [], transformmatrix());
        planegrey2 = triangle(difgrey, [-2, 4, -0.5; 2, 0, -0.5; 2, 4, -0.5], [], [], transformmatrix());

        planegrey2.transformation.rotatezaxis(pi);
        planegrey1.transformation.rotatezaxis(pi);

        ascene = scene(planegrey1, planegrey2, point1, point2, point3, point4, point5);
		
	case 'ghost'

        % Materials
        difgrey = diffuse(black, grey1, 1);
        %air2 = refractive(black, white, 1, air, scatterer(black, white, 10000, 10000, 0.5));
        air2 = reflective_refractive_fuzz(black, white, 1, air, 1, 1, absorber(black, red, 10000, 1));
 
        % Objects 
        planegrey1 = triangle(difgrey, [-2, 4, -0.5; -2, 0, -0.5; 2, 0, -0.5], [], [], neutralmatrix);
        planegrey2 = triangle(difgrey, [-2, 4, -0.5; 2, 0, -0.5; 2, 4, -0.5], [], [], neutralmatrix);

        airsphere = sphere(air2, transformmatrix());
        airsphere.transformation.uniformscale(0.75);
        airsphere.transformation.translate([0 2 0]);
 
        ascene = scene(planegrey1, planegrey2, airsphere);
    
    case 'motionblur'

        % Materials
        difgrey = diffuse(black, grey1, 1);
        difgrey2 = diffuse(black, grey2, 1);

        % Objects 
        planegrey1 = triangle(difgrey, [-2, 4, -0.5; -2, 0, -0.5; 2, 0, -0.5], [], [], neutralmatrix);
        planegrey2 = triangle(difgrey, [-2, 4, -0.5; 2, 0, -0.5; 2, 4, -0.5], [], [], neutralmatrix);

        ball = sphere_motionblur(difgrey2, transformmatrix());
        ball.transformation.uniformscale(0.5);
        ball.transformation.translate([-0.2 2 0]);
        ball.update;
        ball.transformation.translate([0.4 0 0]);

        ascene = scene(planegrey1, planegrey2, ball);   
    
    case 'triangleblur'

        % Materials
        difgrey = diffuse(black, grey1, 1);
        difgrey2 = diffuse(black, grey2, 1);

        % Objects 
        planegrey1 = triangle(difgrey, [-2, 4, -0.5; -2, 0, -0.5; 2, 0, -0.5], [], [], neutralmatrix);
        planegrey2 = triangle(difgrey, [-2, 4, -0.5; 2, 0, -0.5; 2, 4, -0.5], [], [], neutralmatrix);

        triangle1 = triangle_motionblur(difgrey2, [-1, 2, -0.4; 1, 2, -0.4; -1, 2, 1.1], [], [], transformmatrix());
        %triangle1.transformation.translate([-0.2 0 0]);
        triangle1.update;
        triangle1.transformation.translate([0, 0, sin(pi/64) * 2]);

        ascene = scene(planegrey1, planegrey2, triangle1);

    case 'gem'

        % Materials
        difgrey2 = diffuse(black, grey2, 1);
        gemmat = reflective_refractive(black, white, 2.42, air, scatterer(black, gemcolor, 0.1, 0.1, 0.75));

        % Objects
        planegrey3 = triangle(difgrey2, [-2, 4, -0.5; -2, 0, -0.5; 2, 0, -0.5], [], [], neutralmatrix);
        planegrey4 = triangle(difgrey2, [-2, 4, -0.5; 2, 0, -0.5; 2, 4, -0.5], [], [], neutralmatrix);

        cube = mesh(mesh_geometry('.\assets\cube.obj'), gemmat, transformmatrix());
        cube.transformation.uniformscale(0.5);
        cube.transformation.rotatez(pi/6);
        cube.transformation.rotatex(pi/6);
        cube.transformation.translate([0.2, 2, -0.2]);

        ascene = scene(planegrey3, planegrey4);
        ascene.addmesh(cube);

    case 'tie'

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

    case 'fuzz_test'

        % Materials
        glass_fuzz = reflective_refractive_fuzz(black, white, 1.5, air, 1, 0, absorber(black, white, 100, 100));

        % Objects
        point = sphere(glass_fuzz, transformmatrix());
        point.transformation.translate([0, -2, 0]);
        point.transformation.uniformscale(0.5);

        ascene = scene(point);
    
    case 'portals'

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

    case 'portal room'

        % Materials
        difwhite = diffuse(black, white, 1);
        portalmat11 = portal(transformmatrix(), air);
        diffuseorange = diffuse(orange, white, 1);
        portalmat = fresnelmix_in(portalmat11, diffuseorange, 1.5);
        portalmat11.transformation.rotatez(pi);
        portalmat11.transformation.translate([0 0 10]);

        % Objects 
        cube = mesh(mesh_geometry('.\assets\cube.obj'), difwhite, transformmatrix());
        cube.transformation.uniformscale(2.5);

        portalsphere = sphere(portalmat, transformmatrix());
        portalsphere.transformation.uniformscale(1);
        portalsphere.transformation.translate([0 1 0]);

        %ascene = scene(planegrey1, planegrey2, portalsphere);
        ascene = scene(portalsphere);
        ascene.addmesh(cube);
    
    case 'portal'

        % Materials
        difgrey = diffuse(black, grey1, 1);
        portalmat = refractive(black, white, 1, air, portal_scatterer(transformmatrix(), 0.8, air));
        portalmat.scattering.transformation.translate([10 0 0]);
        portalmat.scattering.transformation.rotatez(pi);

        % Objects 
        planegrey1 = triangle(difgrey, [-2, 4, -0.5; -2, 0, -0.5; 2, 0, -0.5], [], [], neutralmatrix);
        planegrey2 = triangle(difgrey, [-2, 4, -0.5; 2, 0, -0.5; 2, 4, -0.5], [], [], neutralmatrix);

        portalsphere = sphere(portalmat, transformmatrix());
        portalsphere.transformation.uniformscale(0.75);
        portalsphere.transformation.translate([0 0 0]);

        %ascene = scene(planegrey1, planegrey2, portalsphere);
        ascene = scene(portalsphere);
        
    case 'glace'
        
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
end
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