classdef reccam_motionblur_aperture < reccam_motionblur

properties
    focal_length
    focal_lengthlast
    aperture
    focal_length_buffer
end

methods
    function obj = reccam_motionblur_aperture(transform, up, fov, subpix, image, material, skybox, max_bounces, focal_length, aperture, time, gammaind)
        obj = obj@reccam_motionblur(transform, up, fov, subpix, image, material, skybox, max_bounces, time, gammaind);        
        obj.time = time; 
        obj.focal_length = focal_length;
        obj.focal_length_buffer = focal_length;
        obj.focal_lengthlast = focal_length;
        obj.aperture = aperture;
    end
    
    function update(obj)
        obj.originlast = obj.origin;
        obj.origin = obj.transformation.multVec([0, 0, 0]);
        transform_norm = obj.transformation.transformDir;
        obj.directionlast = obj.direction;
        obj.direction = transform_norm.multDir([0, 1, 0]);
        obj.focal_lengthlast = obj.focal_length;
        obj.focal_length = obj.focal_length_buffer;
        obj.uplast = obj.up;
        obj.up = up_buffer;
    end

    function raytrace(obj, scene)
        
        tot_subpix = obj.subpix(1) * obj.subpix(2);
        fov_y = obj.fov(1);
        fov_x = obj.fov(2);
        res_y = obj.image.sizey;
        res_x = obj.image.sizex;
        subpix_y = obj.subpix(1);
        subpix_x = obj.subpix(2);
        is_in = obj.material;
        origin1 = obj.origin;
        origin2 = obj.originlast;
        direction1 = obj.direction;
        direction2 = obj.directionlast;
        time1 = obj.time(1);
        time2 = obj.time(2);
        apert = obj.aperture;
        focal1 = obj.focal_lengthlast;
        focal2 = obj.focal_length;
        up1 = obj.up;
        up2 = obj.uplast;

        horizontal1 = cross(direction1, up1); % maybe have those cached?
        horizontal2 = cross(direction2, up2);
        vertical1 = cross(horizontal1, direction1);
        vertical2 = cross(horizontal2, direction2);
        focuspoint1 = origin1 + focal1 * direction1;
        focuspoint2 = origin2 + focal2 * direction2;
        pixel_span_x1 = focal1 * tan(fov_x/2)*2/res_x; % maybe have those cached?
        pixel_span_x2 = focal2 * tan(fov_x/2)*2/res_x; % maybe have those cached?
        pixel_span_y1 = focal1 * tan(fov_y/2)*2/res_y;
        pixel_span_y2 = focal2 * tan(fov_y/2)*2/res_y;
        subpix_span_y1 = pixel_span_y1/subpix_y;
        subpix_span_x1 = pixel_span_x1/subpix_x;
        subpix_span_y2 = pixel_span_y2/subpix_y;
        subpix_span_x2 = pixel_span_x2/subpix_x;

        output = zeros(res_y, res_x, 3); %%% for parfor normal rendering
        
        parfor j = 1:res_y
            outline = zeros(1, res_x, 3);
            for i = 1:res_x
                col = [0, 0, 0];

                for k = 1:subpix_y
                    for l = 1:subpix_x
                        randtime = rand * (time2 - time1) + time1;
                        rand_theta = rand * 2 * pi;
                        rand_r = rand * apert;
                        jitter_x = rand;
                        jitter_y = rand;

                        focuspoint_int = focuspoint2 * randtime + focuspoint1 * (1 - randtime);
                        origin_int = origin2 * randtime + origin1 * (1 - randtime);
                        horizontal_int = horizontal2 * randtime + horizontal1 * (1 - randtime);
                        vertical_int = vertical2 * randtime + vertical1 * (1 - randtime);
                        
                        pixel_span_x_int = pixel_span_x2 * randtime + pixel_span_x1 * (1 - randtime);
                        pixel_span_y_int = pixel_span_y2 * randtime + pixel_span_y1 * (1 - randtime);
                        subpix_span_x_int = subpix_span_x2 * randtime + subpix_span_x1 * (1 - randtime);
                        subpix_span_y_int = subpix_span_y2 * randtime + subpix_span_y1 * (1 - randtime);

                        origin2_int = origin_int + cos(rand_theta) * rand_r * vertical_int + sin(rand_theta) * rand_r * horizontal_int;
                        
                        pix_point = -(j-res_y/2-0.5) * horizontal_int * pixel_span_y_int + (i-res_x/2-0.5) * vertical_int * pixel_span_x_int;
                        
                        ray_point = focuspoint_int + pix_point - horizontal_int * (k - subpix_y/2 - jitter_y)*subpix_span_y_int - vertical_int * (l - subpix_x/2 - jitter_x)*subpix_span_x_int;

                        ray_vec = ray_point - origin2_int;
                        ray_vec = ray_vec/norm(ray_vec);
                        aray = ray_motionblur(origin2_int, ray_vec, [0, 0, 0], [1, 1, 1], is_in, randtime);
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

        focusray = ray(obj.origin, ray_vec, [0, 0, 0], [1, 1, 1], obj.material);

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