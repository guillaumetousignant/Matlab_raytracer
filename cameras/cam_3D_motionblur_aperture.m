classdef cam_3D_motionblur_aperture < handle

properties
    camera
    camera_R
    focal_length
    focal_length_buffer
    aperture
    eye_dist

    fov
    subpix
    image
    image_R
    material % what is the camera in? must be refractive
    skybox
    transformation
    max_bounces
    direction
    origin
    gammaind
    up
    up_buffer

    directionlast
    originlast
    focal_lengthlast
    time
    uplast
end

methods
    function obj = cam_3D_motionblur_aperture(transform, up, fov, subpix, image, image_R, eye_dist, material, skybox, max_bounces, focal_length, aperture, time, gammaind)
        obj = obj@handle();      
        
        obj.camera = cam_motionblur_aperture(transform, up, fov, subpix, image, material, skybox, max_bounces, focal_length, aperture, time, gammaind);
        obj.camera_R = cam_motionblur_aperture(transform, up, fov, subpix, image_R, material, skybox, max_bounces, focal_length, aperture, time, gammaind);
        
        obj.fov = fov;        
        obj.subpix = subpix;
        obj.image = image;
        obj.image_R = image_R;
        obj.material = material;
        obj.skybox = skybox;
        obj.transformation = transform;
        obj.max_bounces = max_bounces;
        obj.origin = obj.transformation.multVec([0, 0, 0]);
        transform_norm = obj.transformation.transformDir;
        obj.direction = transform_norm.multDir([0, 1, 0]); %%% CHECK should use transformation only? (not transformation_norm)
        obj.focal_length = focal_length;
        obj.focal_length_buffer = focal_length;
        obj.focal_lengthlast = focal_length;
        obj.eye_dist = eye_dist;
        obj.time = time;
        obj.aperture = aperture;
        obj.gammaind = gammaind;
        obj.up = up;
        obj.up_buffer = up;
        obj.uplast = up;

        obj.directionlast = obj.direction;
        obj.originlast = obj.origin;

        horizontal = cross(obj.direction, up);

        obj.camera.origin = -eye_dist/2 * horizontal + obj.origin;
        obj.camera_R.origin = eye_dist/2 * horizontal + obj.origin;
        obj.camera.originlast = obj.camera.origin;
        obj.camera_R.originlast = obj.camera_R.origin;

        L_vec = focal_length * obj.direction + eye_dist/2 * horizontal;
        R_vec = focal_length * obj.direction - eye_dist/2 * horizontal;
        obj.camera.direction = L_vec/norm(L_vec);
        obj.camera_R.direction = R_vec/norm(R_vec);
        obj.camera.directionlast = obj.camera.direction;
        obj.camera_R.directionlast = obj.camera_R.direction;
    end

    function update(obj)
        obj.originlast = obj.origin;
        obj.directionlast = obj.direction;
        obj.focal_lengthlast = obj.focal_length;

        obj.origin = obj.transformation.multVec([0, 0, 0]);
        transform_norm = obj.transformation.transformDir;
        obj.direction = transform_norm.multDir([0, 1, 0]); %%% CHECK should use transformation only? (not transformation_norm)
        %obj.direction_sph = to_sph(obj.direction);
        obj.focal_length = obj.focal_length_buffer;

        obj.camera.focal_lengthlast = obj.camera.focal_length;
        obj.camera_R.focal_lengthlast = obj.camera.focal_length;
        obj.camera.focal_length = obj.focal_length;
        obj.camera_R.focal_length = obj.focal_length;  

        horizontal = cross(obj.direction, obj.up);

        obj.camera.originlast = obj.camera.origin;
        obj.camera_R.originlast = obj.camera_R.origin;
        obj.camera.origin = -obj.eye_dist/2 * horizontal + obj.origin;
        obj.camera_R.origin = obj.eye_dist/2 * horizontal + obj.origin;

        obj.camera.directionlast = obj.camera.direction;
        obj.camera_R.directionlast = obj.camera_R.direction;
        L_vec = obj.focal_length * obj.direction + obj.eye_dist/2 * horizontal;
        R_vec = obj.focal_length * obj.direction - obj.eye_dist/2 * horizontal;
        obj.camera.direction = L_vec/norm(L_vec);
        obj.camera_R.direction = R_vec/norm(R_vec);
    end

    function raytrace(obj, scene)
        obj.camera.raytrace(scene);
        obj.camera_R.raytrace(scene);
    end 

    function write(obj, filename)
        point = strfind(filename, '.');
        if ~isempty(point)
            point = point(end);
            filename_L = [filename(1:point-1), '_L', filename(point:end)];
            filename_R = [filename(1:point-1), '_R', filename(point:end)];
            filename_S = [filename(1:point-1), '_S', filename(point:end)];
        else
            filename_L = [filename, '_L.png'];
            filename_R = [filename, '_R.png'];
            filename_S = [filename, '_S.png'];
        end
        imwrite16(obj.image.img, filename_L, obj.gammaind);
        imwrite16(obj.image_R.img, filename_R, obj.gammaind);
        
        imwrite16(cat(3, obj.image.img(:, :, 1), obj.image_R.img(:, :, [2, 3])), filename_S, obj.gammaind);
    end

    function show(obj, fignumber)
        figure(fignumber);
        imshow(obj.image.img.^(1/obj.gammaind));
        figure(fignumber+1);
        imshow(obj.image_R.img.^(1/obj.gammaind));
    end

    function focus(obj, foc_dist)
        obj.focal_length_buffer = foc_dist;
    end

    function autofocus(obj, scene, position)
        % position is [x, y]
        ray_direction_sph = to_sph(obj.direction) + [0, (position(2)-0.5)*obj.fov(1), (position(1)-0.5)*-obj.fov(2)]; % 0, y, x

        focusray = ray(obj.origin, to_xyz(ray_direction_sph), [0, 0, 0], [1, 1, 1], obj.material);

        [~, t, ~] = scene.intersect(focusray);

        if t == inf
            t = 10000;
        end

        obj.focus(t);
    end

    function set_up(obj, new_up)
        obj.up_buffer = new_up;
    end
end
end