classdef reccam_aperture < reccam

properties
    focal_length
    aperture
    focal_length_buffer
end

methods
    function obj = reccam_aperture(transform, filename, up, fov, subpix, image, medium_list, skybox, max_bounces, focal_length, aperture, gammaind)
        obj = obj@reccam(transform, filename, up, fov, subpix, image, medium_list, skybox, max_bounces, gammaind);        
        obj.focal_length = focal_length;
        obj.focal_length_buffer = focal_length;
        obj.aperture = aperture;
    end
    
    function update(obj)
        obj.origin = obj.transformation.multVec([0, 0, 0]);
        transform_norm = obj.transformation.transformDir;
        obj.direction = transform_norm.multDir([0, 1, 0]); %%% CHECK should use transformation only? (not transformation_norm)
        obj.focal_length = obj.focal_length_buffer;
        obj.up = obj.up_buffer;
    end

    function raytrace(obj, scene)
        
        tot_subpix = obj.subpix(1) * obj.subpix(2);
        fov_y = obj.fov(1);
        fov_x = obj.fov(2);
        res_y = obj.image.sizey;
        res_x = obj.image.sizex;
        subpix_y = obj.subpix(1);
        subpix_x = obj.subpix(2);
        is_in = obj.medium_list;
        origin1 = obj.origin;
        direction1 = obj.direction;
        apert = obj.aperture;
        focal = obj.focal_length;
        up_vec = obj.up;

        horizontal = cross(direction1, up_vec);
        vertical = cross(horizontal, direction1);
        focuspoint = origin1 + focal * direction1;
        pixel_span_x = horizontal * focal * tan(fov_x/2)*2/res_x;
        pixel_span_y = vertical * focal * tan(fov_y/2)*2/res_y;
        subpix_span_y = pixel_span_y/subpix_y;
        subpix_span_x = pixel_span_x/subpix_x;

        output = zeros(res_y, res_x, 3); %%% for parfor normal rendering
        
        parfor j = 1:res_y
            outline = zeros(1, res_x, 3);
            for i = 1:res_x
                col = [0, 0, 0];
                
                for k = 1:subpix_y
                    for l = 1:subpix_x
                        rand_theta = rand * 2 * pi;
                        rand_r = rand * apert;
                        jitter_x = rand;
                        jitter_y = rand;

                        pix_point = focuspoint - (j-res_y/2-0.5) * pixel_span_y + (i-res_x/2-0.5) * pixel_span_x;
                        origin2 = origin1 + cos(rand_theta) * rand_r * vertical + sin(rand_theta) * rand_r * horizontal;

                        ray_point = pix_point - (k - subpix_y/2 - jitter_y)*subpix_span_y - (l - subpix_x/2 - jitter_x)*subpix_span_x;    
                        ray_vec = ray_point - origin2;
                        ray_vec = ray_vec/norm(ray_vec);
                        aray = ray(origin2, ray_vec, [0, 0, 0], [1, 1, 1], is_in);
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
    
    function focus(obj, foc_dist)
        obj.focal_length_buffer = foc_dist;
    end

    function autofocus(obj, scene, position)
        % position is [x, y]
        fov_y = obj.fov(1);
        fov_x = obj.fov(2);

        horizontal = cross(obj.direction, obj.up);
        vertical = cross(horizontal, obj.direction);
        focuspoint = obj.origin + obj.focal_length * obj.direction;
        span_x = horizontal * obj.focal_length * tan(fov_x/2)*2; % was *2
        span_y = vertical * obj.focal_length * tan(fov_y/2)*2; % was *2

        ray_point = focuspoint - (position(2)-0.5) * span_y + (position(1)-0.5) * span_x; % y, x
        ray_vec = ray_point - obj.origin;
        ray_vec = ray_vec/norm(ray_vec);

        focusray = ray(obj.origin, ray_vec, [0, 0, 0], [1, 1, 1], obj.medium_list);

        [~, t, ~] = scene.intersect(focusray);

        if t == inf
            t = 10000;
        end

        obj.focus(t);
    end
end
end