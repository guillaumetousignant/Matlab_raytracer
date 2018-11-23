classdef cam_3D_motionblur < handle

properties
    camera
    camera_R
    focal_length
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

    directionlast
    originlast
    time
end

methods
    function obj = cam_3D_motionblur(transform, fov, subpix, image, image_R, eye_dist, material, skybox, max_bounces, focal_length, time)
        obj = obj@handle();      
        
        obj.camera = cam_motionblur(transform, fov, subpix, image, material, skybox, max_bounces, time);
        obj.camera_R = cam_motionblur(transform, fov, subpix, image_R, material, skybox, max_bounces, time);
        
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
        obj.eye_dist = eye_dist;
        obj.time = time;
        obj.directionlast = obj.direction;
        obj.originlast = obj.origin;

        obj.camera.origin = obj.transformation.multVec([-eye_dist/2, 0, 0]);
        obj.camera_R.origin = obj.transformation.multVec([eye_dist/2, 0, 0]);
        obj.camera.originlast = obj.camera.origin;
        obj.camera_R.originlast = obj.camera_R.origin;

        L_vec = [0, focal_length, 0] - [-eye_dist/2, 0, 0];
        R_vec = [0, focal_length, 0] - [eye_dist/2, 0, 0];
        obj.camera.direction = transform_norm.multDir(L_vec/norm(L_vec));
        obj.camera_R.direction = transform_norm.multDir(R_vec/norm(R_vec));
        obj.camera.directionlast = obj.camera.direction;
        obj.camera_R.directionlast = obj.camera_R.direction;
    end

    function update(obj)
        obj.originlast = obj.origin;
        obj.directionlast = obj.direction;

        obj.origin = obj.transformation.multVec([0, 0, 0]);
        transform_norm = obj.transformation.transformDir;
        obj.direction = transform_norm.multDir([0, 1, 0]); %%% CHECK should use transformation only? (not transformation_norm)
        %obj.direction_sph = to_sph(obj.direction);

        obj.camera.originlast = obj.camera.origin;
        obj.camera_R.originlast = obj.camera_R.origin;
        obj.camera.origin = obj.transformation.multVec([-obj.eye_dist/2, 0, 0]);
        obj.camera_R.origin = obj.transformation.multVec([obj.eye_dist/2, 0, 0]);

        obj.camera.directionlast = obj.camera.direction;
        obj.camera_R.directionlast = obj.camera_R.direction;
        L_vec = [0, obj.focal_length, 0] - [-obj.eye_dist/2, 0, 0];
        R_vec = [0, obj.focal_length, 0] - [obj.eye_dist/2, 0, 0];
        obj.camera.direction = transform_norm.multDir(L_vec/norm(L_vec));
        obj.camera_R.direction = transform_norm.multDir(R_vec/norm(R_vec));
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
        imwrite16(obj.image.img, filename_L);
        imwrite16(obj.image_R.img, filename_R);
        
        imwrite16(cat(3, obj.image.img(:, :, 1), obj.image_R.img(:, :, [2, 3])), filename_S);
    end

    function show(obj, fignumber)
        figure(fignumber);
        imshow(obj.image.img);
        figure(fignumber+1);
        imshow(obj.image_R.img);
    end
end
end