function camera = generate_camera(resolution, varargin) 
% Varargin: Type
%           AR
%           FOV
%           FOViso
%           subPix
%           maxBounces
%           eyeDist
%           focalLength
%           aperture
%           timeVec
%           material
%           bg
%           gamma

%% Camera
%resolutions = [ 2560, 3840; ... % 1
%                2000, 3000; ... % 2
%                1280, 1920; ... % 3
%                1200, 1800; ... % 4
%                800, 1200; ...  % 5
%                600, 900; ...   % 6
%                400, 600; ...   % 7
%                200, 300; ...   % 8
%                100, 150; ...   % 9
%                50, 75; ...     % 10
%                40, 60; ...     % 11
%                20, 30; ...     % 12
%                10, 15; ...     % 13
%                8, 12];         % 14

%res = resolutions(4, :);
res = [resolution(2), resolution(1)];

cam_type = 'cam';
aspect_ratio = res(2) / res(1);
fov(2) = 80 * pi/180;
fov(1) = fov(2)/aspect_ratio;
fov_iso(2) = 4;
fov_iso(1) = fov_iso(2)/aspect_ratio;
subpix = [1, 1];
max_bounces = 8;
eye_dist = 0.065;
focal_length = 2;
aperture = 0.01;
time_vec = [0, 1];
gammaind = 1; % should be 2.2

air = refractive([0, 0, 0], [1, 1, 1], 1.001, struct('ind', 0), nonabsorber()); %%% CHECK remove this when merging with generate_scene

environment = 'day';

for i = 1:2:length(varargin)
    switch lower(varargin{i})
        case 'type'
            cam_type = varargin{i+1};
        case 'ar'
            aspect_ratio = varargin{i+1};
        case 'fov'
            if length(varargin{i+1}) == 1
                fov(2) = varargin{i+1} * pi/180;
                fov(1) = fov(2)/aspect_ratio;
            else
                fov = varargin{i+1} * pi/180;
            end
        case 'foviso'
            if length(varargin{i+1}) == 1
                fov_iso(2) = varargin{i+1};
                fov_iso(1) = fov_iso(2)/aspect_ratio;
            else
                fov_iso = varargin{i+1};
            end
        case 'subpix'
            if length(varargin{i+1}) == 1
                subpix = [1, 1] .* varargin{i+1};
            else
                subpix = varargin{i+1};
            end
        case 'maxbounces'
            max_bounces = varargin{i+1};
        case 'eyedist'
            eye_dist = varargin{i+1};
        case 'focallength'
            focal_length = varargin{i+1};
        case 'aperture'
            aperture = varargin{i+1};
        case 'timevec'
            time_vec = varargin{i+1};
        case 'material'
            air = varargin{i+1};
        case 'bg'   
            environment = varargin{i+1}; 
        case 'gamma'
            gammaind = varargin{i+1};
        otherwise
            warning('generate_camera:wrongInput', ['Wrong input "', varargin{i}, '" entered. Ignored.']);
    end
end

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
        moon.transformation.uniformscale(0.92); % will never intersect over 1 (and 1 is basically impossible) was 0.8
        moon.transformation.rotatez(-pi/4);
        moon.transformation.rotatex(pi/4);
        moon.update;

        askybox = skybox_flat_sun([0.05, 0.05, 0.05], moon);

    case 'beach'

        askybox = skybox_texture_sun(texture('.\assets\Ocean from horn.jpg'), [0.6209296, 1-0.2292542], [0.996, 0.941, 0.918] * 1.586010 * 8, 0.035);
    
    case 'grey'

        sun = directional_light([2.5, 2.5, 2] * 2, transformmatrix());
        sun.transformation.uniformscale(0.95); % will never intersect over 1 (and 1 is basically impossible)
        sun.transformation.rotatez(-pi/4);
        sun.transformation.rotatex(-3 * pi/8);
        sun.update;

        askybox = skybox_flat_sun([0.75, 0.75, 0.75], sun);
end

image = imgbuffer(res(2), res(1));

switch lower(cam_type)
    case 'cam'
        camera = cam(transformmatrix(), fov, subpix, image, air, askybox, max_bounces, gammaind);
    case 'aperture'
        camera = cam_aperture(transformmatrix(), fov, subpix, image, air, askybox, max_bounces, focal_length, aperture, gammaind);
    case 'motionblur'
        camera = cam_motionblur(transformmatrix(), fov, subpix, image, air, askybox, max_bounces, time_vec, gammaind); 
    case 'motionbluraperture'
        camera = cam_motionblur_aperture(transformmatrix(), fov, subpix, image, air, askybox, max_bounces, focal_length, aperture, time_vec, gammaind); 
    case '3d'
        image_R = imgbuffer(res(2), res(1));
        camera = cam_3D(transformmatrix(), fov, subpix, image, image_R, eye_dist, air, askybox, max_bounces, focal_length, gammaind);
    case '3daperture'
        image_R = imgbuffer(res(2), res(1));
        camera = cam_3D_aperture(transformmatrix(), fov, subpix, image, image_R, eye_dist, air, askybox, max_bounces, focal_length, aperture, gammaind);
    case '3dmotionblur'
        image_R = imgbuffer(res(2), res(1));
        camera = cam_3D_motionblur(transformmatrix(), fov, subpix, image, image_R, eye_dist, air, askybox, max_bounces, focal_length, time_vec, gammaind);
    case '3dmotionbluraperture'
        image_R = imgbuffer(res(2), res(1));
        camera = cam_3D_motionblur_aperture(transformmatrix(), fov, subpix, image, image_R, eye_dist, air, askybox, max_bounces, focal_length, aperture, time_vec, gammaind);
    case 'iso'
        camera = isocam(transformmatrix(), fov_iso, subpix, image, air, askybox, max_bounces, gammaind);
    case 'isoaperture'
        camera = isocam_aperture(transformmatrix(), fov_iso, subpix, image, air, askybox, max_bounces, focal_length, aperture, gammaind);
    case 'isomotionblur'
        camera = isocam_motionblur(transformmatrix(), fov_iso, subpix, image, air, askybox, max_bounces, time_vec, gammaind);
    case 'isomotionbluraperture'
        camera = isocam_motionblur_aperture(transformmatrix(), fov_iso, subpix, image, air, askybox, max_bounces, focal_length, aperture, time_vec, gammaind);
    case 'rec'
        camera = reccam(transformmatrix(), fov, subpix, image, air, askybox, max_bounces, gammaind);
    case 'recaperture'
        camera = reccam_aperture(transformmatrix(), fov, subpix, image, air, askybox, max_bounces, focal_length, aperture, gammaind);
    case 'recmotionblur'
        camera = reccam_motionblur(transformmatrix(), fov, subpix, image, air, askybox, max_bounces, time_vec, gammaind);
    case 'recmotionbluraperture'
        camera = reccam_motionblur_aperture(transformmatrix(), fov, subpix, image, air, askybox, max_bounces, focal_length, aperture, time_vec, gammaind);
end
end