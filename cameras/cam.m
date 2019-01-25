classdef cam < handle

properties
    fov
    subpix
    image
    material % what is the camera in? must be refractive
    skybox
    transformation
    max_bounces
    direction
    %direction_sph
    origin
    gammaind
    up
    up_buffer
end

methods
    function obj = cam(transform, up, fov, subpix, image, material, skybox, max_bounces, gammaind)
        obj = obj@handle();        
        obj.fov = fov;        
        obj.subpix = subpix;
        obj.image = image;
        obj.material = material;
        obj.skybox = skybox;
        obj.transformation = transform;
        obj.max_bounces = max_bounces;
        obj.origin = obj.transformation.multVec([0, 0, 0]);
        transform_norm = obj.transformation.transformDir;
        obj.direction = transform_norm.multDir([0, 1, 0]); %%% CHECK should use transformation only? (not transformation_norm)
        %obj.direction_sph = to_sph(obj.direction);
        obj.gammaind = gammaind;
        obj.up = up;
        obj.up_buffer = up;
    end

    function update(obj)
        obj.origin = obj.transformation.multVec([0, 0, 0]);
        transform_norm = obj.transformation.transformDir;
        obj.direction = transform_norm.multDir([0, 1, 0]); %%% CHECK should use transformation only? (not transformation_norm)
        %obj.direction_sph = to_sph(obj.direction);
        obj.up = obj.up_buffer;
    end

    function raytrace(obj, scene)
        
        tot_subpix = obj.subpix(1) * obj.subpix(2);
        res_y = obj.image.sizey;
        res_x = obj.image.sizex;
        pixel_span_y = obj.fov(1)/res_y;
        pixel_span_x = obj.fov(2)/res_x;
        subpix_y = obj.subpix(1);
        subpix_x = obj.subpix(2);
        subpix_span_y = pixel_span_y/subpix_y;
        subpix_span_x = pixel_span_x/subpix_x;
        is_in = obj.material;
        origin1 = obj.origin;
        direction_sph1 = to_sph(obj.direction);
        %direction1 = obj.direction; %%% CHECK for roll
        up_dir obj.up;

        output = zeros(res_y, res_x, 3); %%% for parfor normal rendering
        
        parfor j = 1:res_y
            outline = zeros(1, res_x, 3);
            for i = 1:res_x
                col = [0, 0, 0];
                pix_vec_sph = direction_sph1 + [0, (j - res_y/2 - 0.5)*pixel_span_y, (i - res_x/2 - 0.5)*-pixel_span_x]; % pixel_span_x should be +?? Maybe not because spherical, don't remember.

                for k = 1:subpix_y
                    for l = 1:subpix_x
                        jitter_x = rand;
                        jitter_y = rand;
                        
                        ray_vec = to_xyz(pix_vec_sph + [0, (k - subpix_y/2 - jitter_y)*subpix_span_y, (l - subpix_x/2 - jitter_x)*-subpix_span_x]);
                    
                        %%% CHECK begin
                        %roll_angle = 15;
                        %rot_mat = [ cosd(roll_angle) + direction1(1)^2 * (1 - cosd(roll_angle)), direction1(1)*direction1(2)*(1 - cosd(roll_angle)) - direction1(3)*sind(roll_angle), direction1(1)*direction1(3)*(1 - cosd(roll_angle)) + direction1(2)*sind(roll_angle); ...
                        %            direction1(1)*direction1(2)*(1 - cosd(roll_angle)) + direction1(3)*sind(roll_angle), cosd(roll_angle) + direction1(2)^2 * (1 - cosd(roll_angle)), direction1(2)*direction1(3)*(1 - cosd(roll_angle)) - direction1(1)*sind(roll_angle); ...
                        %            direction1(1)*direction1(3)*(1 - cosd(roll_angle)) - direction1(2)*sind(roll_angle), direction1(2)*direction1(3)*(1 - cosd(roll_angle)) + direction1(1)*sind(roll_angle), cosd(roll_angle) + direction1(3)^2 * (1 - cosd(roll_angle))]; %%% CHECK fix broadcast thing
                        %rot_mat = inv(rot_mat)';
                        %
                        %ray_vec = ray_vec * rot_mat;
                        %%% CHECK end
                        
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
        %obj.image.set(output); %%% for parfor normal rendering
        obj.image.update(output);
    end 
    
    function write(obj, filename)
        imwrite16(obj.image.img, filename, obj.gammaind);
    end

    function show(obj, fignumber)
        figure(fignumber);
        imshow(obj.image.img.^(1/obj.gammaind));
    end
    
    function focus(obj, foc_dist)
        
    end

    function autofocus(obj, scene, position)
        
    end

    function set_up(obj, new_up)
        obj.up_buffer = new_up;
    end
end
end