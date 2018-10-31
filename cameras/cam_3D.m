classdef cam_3D < handle

properties
    camera_L
    camera_R
    focal_length
    eye_dist

    fov
    pixel_span
    subpix
    resolution
    image
    material % what is the camera in? must be refractive
    skybox
    transformation
    max_bounces
    direction
    origin
end

methods
    function obj = cam_3D(transform, fov, subpix, image_L, image_R, focal_length, eye_dist, material, skybox, max_bounces)
        obj = obj@handle();      
        
        obj.camera_L = cam(transform, fov, subpix, image_L, material, skybox, max_bounces);
        obj.camera_R = cam(transform, fov, subpix, image_R, material, skybox, max_bounces);

        obj.fov = fov;        
        obj.resolution = [image.sizey, image.sizex];
        obj.pixel_span = [fov(1)/obj.resolution(1), fov(2)/obj.resolution(2)];
        obj.subpix = subpix;
        obj.image = image;
        obj.material = material;
        obj.skybox = skybox;
        obj.transformation = transform;
        obj.max_bounces = max_bounces;
        obj.origin = obj.transformation.multVec([0, 0, 0]);
        transform_norm = obj.transformation.transformDir;
        obj.direction = transform_norm.multDir([0, 1, 0]); %%% CHECK should use transformation only? (not transformation_norm)
        obj.focal_length = focal_length;
        obj.eye_dist = eye_dist;

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
        
        tot_subpix = obj.subpix(1) * obj.subpix(2);
        pixel_span_y = obj.pixel_span(1);
        pixel_span_x = obj.pixel_span(2);
        res_y = obj.resolution(1);
        res_x = obj.resolution(2);
        subpix_y = obj.subpix(1);
        subpix_x = obj.subpix(2);
        is_in = obj.material;
        origin1 = obj.origin;
        direction_sph1 = to_sph(obj.direction);

        output = zeros(res_y, res_x, 3); %%% for parfor normal rendering
        
        parfor j = 1:res_y
            outline = zeros(1, res_x, 3);
            for i = 1:res_x
                col = [0, 0, 0];
                pix_vec_sph = direction_sph1 + [0, (j-res_y/2-0.5)*pixel_span_y, (i-res_x/2-0.5)*-pixel_span_x]; 

                for k = 1:subpix_y
                    for l = 1:subpix_x
                        ray_vec = to_xyz(pix_vec_sph + [0, pixel_span_y*(k/subpix_y-0.5), -pixel_span_x*(l/subpix_x-0.5)]);
                        
                        aray = ray(origin1, ray_vec, [0, 0, 0], [1, 1, 1], is_in);
                        aray.raycast(scene, obj);
                        col = col + aray.colour;
                    end
                end
        
                col = col/tot_subpix;
                outline(1, i, :) = col;
            end
            %obj.image.setline(outline, j);
            %obj.image.updateline(outline, j); % possibly not working as intended

            output(j, :, :) = outline; %%% for parfor normal rendering
            
            %%% REMOVE
            %fprintf([num2str(round(100*j/res_y)), '%% done!\n']);
        end
        obj.image.set(output); %%% for parfor normal rendering
    end  
end
end