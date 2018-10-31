%% Camera
resolutions = [ 2560, 3840; ... % 1
                2000, 3000; ... % 2
                1280, 1920; ... % 3
                1200, 1800; ... % 4
                800, 1200; ...  % 5
                600, 900; ...   % 6
                400, 600; ...   % 7
                200, 300; ...   % 8
                100, 150; ...   % 9
                50, 75; ...     % 10
                40, 60; ...     % 11
                20, 30; ...     % 12
                10, 15; ...     % 13
                8, 12];         % 14

res = resolutions(9, :);

aspect_ratio = res(2) / res(1);
fov(2) = 80 * pi /180; % was 80
fov(1) = fov(2)/aspect_ratio;
fov_iso(2) = 4;
fov_iso(1) = fov_iso(2)/aspect_ratio;
subpix = [1, 1] .* 2; % 2
max_bounces = 8; % was 8
eye_dist = 0.065;
focal_length = 2;
aperture = 0.01;
time_vec = [0, 1];

air = refractive([0, 0, 0], [1, 1, 1], 1.001, struct('ind', 0), nonabsorber()); %%% CHECK remove this when merging with generate_scene

environment = 'day';

switch lower(environment)
    case 'day'

        sun = directional_light([2.5, 2.5, 2] * 2, transformmatrix());
        sun.transformation.uniformscale(0.95); % will never intersect over 1 (and 1 is basically impossible)
        sun.transformation.rotatez(-pi/4);
        sun.transformation.rotatex(-3 * pi/8);
        sun.update;

        askybox = skybox_flat_sun([0.8040, 0.8825, 0.9765], sun);

    case 'night'

        moon = directional_light([0.9, 0.9, 1] * 5, transformmatrix());
        moon.transformation.uniformscale(0.95); % will never intersect over 1 (and 1 is basically impossible) was 0.8
        moon.transformation.rotatez(-pi/4);
        moon.transformation.rotatex(pi/4);
        moon.update;

        askybox = skybox_flat_sun([0.05, 0.05, 0.05], moon);

    case 'beach'

        askybox = skybox_texture_sun(texture('.\assets\Ocean from horn.jpg'), [0.6209296, 1-0.2292542], [0.996, 0.941, 0.918] * 1.586010 * 8, 0.035);
end

%image = imgbuffer(res(2), res(1));
image = imgbuffer(res(2), res(1));
image_R = imgbuffer(res(2), res(1));

%camera = cam_aperture(transformmatrix(), fov, subpix, image, air, askybox, max_bounces, 3, 0.01);
%camera = cam_motionblur_aperture(transformmatrix(), fov, subpix, image, air, askybox, max_bounces, 4, 0.01, [0, 1]); % was 0.25 0.75
%camera = isocam(transformmatrix(), fov_iso, subpix, image, air, askybox, max_bounces);
%camera = reccam(transformmatrix(), fov, subpix, image, air, askybox, max_bounces);

camera = cam_3D_motionblur_aperture(transformmatrix(), fov, subpix, image, image_R, eye_dist, air, askybox, max_bounces, focal_length, aperture, time_vec);

%save camera.mat camera