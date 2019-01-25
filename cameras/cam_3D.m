classdef cam_3D < handle

properties
    camera
    camera_R
    focal_length
    focal_length_buffer
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
end

methods
    function obj = cam_3D(transform, up, fov, subpix, image, image_R, eye_dist, material, skybox, max_bounces, focal_length, gammaind)
        obj = obj@handle();      
        
        obj.camera = cam(transform, up, fov, subpix, image, material, skybox, max_bounces, gammaind);
        obj.camera_R = cam(transform, up, fov, subpix, image_R, material, skybox, max_bounces, gammaind);

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
        obj.eye_dist = eye_dist;
        obj.gammaind = gammaind;
        obj.up = up;
        obj.up_buffer = up;

        horizontal = cross(obj.direction, up);

        obj.camera.origin = obj.transformation.multVec(-eye_dist/2 * horizontal);
        obj.camera_R.origin = obj.transformation.multVec(eye_dist/2 * horizontal);

        L_vec = focal_length * obj.direction + eye_dist/2 * horizontal;
        R_vec = focal_length * obj.direction - eye_dist/2 * horizontal;
        obj.camera.direction = L_vec/norm(L_vec);
        obj.camera_R.direction = R_vec/norm(R_vec);
    end

    function update(obj)
        obj.origin = obj.transformation.multVec([0, 0, 0]);
        transform_norm = obj.transformation.transformDir;
        obj.direction = transform_norm.multDir([0, 1, 0]); %%% CHECK should use transformation only? (not transformation_norm)
        %obj.direction_sph = to_sph(obj.direction);
        obj.focal_length = obj.focal_length_buffer;
        obj.up = obj.up_buffer;
        
        obj.camera.focal_length = obj.focal_length;
        obj.camera_R.focal_length = obj.focal_length;
        obj.camera.up = obj.up;
        obj.camera_R.up = obj.up;

        horizontal = cross(obj.direction, obj.up);

        obj.camera.origin = obj.transformation.multVec(-obj.eye_dist/2 * horizontal);
        obj.camera_R.origin = obj.transformation.multVec(obj.eye_dist/2 * horizontal);

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