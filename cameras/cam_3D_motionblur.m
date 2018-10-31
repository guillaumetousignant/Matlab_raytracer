classdef cam_3D_motionblur < handle

properties
    camera
    camera_R
    focal_length
    eye_dist

    fov
    pixel_span
    subpix
    resolution
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
        obj.resolution = [(image.sizey + image_R.sizey)/2, (image.sizex + image_R.sizex)/2];
        obj.pixel_span = [fov(1)/obj.resolution(1), fov(2)/obj.resolution(2)];
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

        L_vec = [0, 1, 0] - [-eye_dist/2, 0, 0];
        R_vec = [0, 1, 0] - [eye_dist/2, 0, 0];
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
        L_vec = [0, 1, 0] - [-obj.eye_dist/2, 0, 0];
        R_vec = [0, 1, 0] - [obj.eye_dist/2, 0, 0];
        obj.camera.direction = transform_norm.multDir(L_vec/norm(L_vec));
        obj.camera_R.direction = transform_norm.multDir(R_vec/norm(R_vec));
    end

    function raytrace(obj, scene)
        obj.camera.raytrace(scene);
        obj.camera_R.raytrace(scene);
    end  
end
end