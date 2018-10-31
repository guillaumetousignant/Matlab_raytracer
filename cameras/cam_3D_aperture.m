classdef cam_3D_aperture < handle

properties
    camera_L
    camera_R
    focal_length
    eye_dist
    aperture

    fov
    pixel_span
    subpix
    resolution
    image_L
    image_R
    material % what is the camera in? must be refractive
    skybox
    transformation
    max_bounces
    direction
    origin
end

methods
    function obj = cam_3D_aperture(transform, fov, subpix, image_L, image_R, eye_dist, material, skybox, max_bounces, focal_length, aperture)
        obj = obj@handle();      
        
        obj.camera_L = cam_aperture(transform, fov, subpix, image_L, material, skybox, max_bounces, focal_length, aperture);
        obj.camera_R = cam_aperture(transform, fov, subpix, image_R, material, skybox, max_bounces, focal_length, aperture);
        
        obj.fov = fov;        
        obj.resolution = [(image_L.sizey + image_R.sizey)/2, (image_L.sizex + image_R.sizex)/2];
        obj.pixel_span = [fov(1)/obj.resolution(1), fov(2)/obj.resolution(2)];
        obj.subpix = subpix;
        obj.image_L = image_L;
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
        obj.aperture = aperture;

        obj.camera_L.origin = obj.transformation.multVec([-eye_dist/2, 0, 0]);
        obj.camera_R.origin = obj.transformation.multVec([eye_dist/2, 0, 0]);

        L_vec = [0, 1, 0] - [-eye_dist/2, 0, 0];
        R_vec = [0, 1, 0] - [eye_dist/2, 0, 0];
        obj.camera_L.direction = transform_norm.multDir(L_vec/norm(L_vec));
        obj.camera_R.direction = transform_norm.multDir(R_vec/norm(R_vec));
    end

    function update(obj)
        obj.origin = obj.transformation.multVec([0, 0, 0]);
        transform_norm = obj.transformation.transformDir;
        obj.direction = transform_norm.multDir([0, 1, 0]); %%% CHECK should use transformation only? (not transformation_norm)
        %obj.direction_sph = to_sph(obj.direction);

        obj.camera_L.origin = obj.transformation.multVec([-obj.eye_dist/2, 0, 0]);
        obj.camera_R.origin = obj.transformation.multVec([obj.eye_dist/2, 0, 0]);

        L_vec = [0, 1, 0] - [-obj.eye_dist/2, 0, 0];
        R_vec = [0, 1, 0] - [obj.eye_dist/2, 0, 0];
        obj.camera_L.direction = transform_norm.multDir(L_vec/norm(L_vec));
        obj.camera_R.direction = transform_norm.multDir(R_vec/norm(R_vec));
    end

    function raytrace(obj, scene)
        obj.camera_L.raytrace(scene);
        obj.camera_R.raytrace(scene);
    end  
end
end