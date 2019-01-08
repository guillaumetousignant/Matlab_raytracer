classdef cam_motionblur_aperture < cam_motionblur

properties
    focal_length
    focal_lengthlast
    aperture
    focal_length_buffer
end

methods
    function obj = cam_motionblur_aperture(transform, fov, subpix, image, material, skybox, max_bounces, focal_length, aperture, time, gammaind)
        obj = obj@cam_motionblur(transform, fov, subpix, image, material, skybox, max_bounces, time, gammaind);  
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
        obj.direction = transform_norm.multDir([0, 1, 0]); %%% CHECK should use transformation only? (not transformation_norm)
        %obj.direction_sphlast = obj.direction_sph;
        %obj.direction_sph = to_sph(obj.direction);
        obj.focal_lengthlast = obj.focal_length;
        obj.focal_length = obj.focal_length_buffer;
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
        origin1 = obj.originlast;
        origin2 = obj.origin;
        direction1 = obj.directionlast;
        direction2 = obj.direction;
        %direction_sph1 = to_sph(direction1);
        %direction_sph2 = to_sph(direction2);
        time1 = obj.time(1);
        time2 = obj.time(2);
        apert = obj.aperture;
        focal1 = obj.focal_lengthlast;
        focal2 = obj.focal_length;

        horizontal1 = cross(direction1, [0, 0, 1]);
        horizontal2 = cross(direction2, [0, 0, 1]);
        vertical1 = cross(horizontal1, direction1);
        vertical2 = cross(horizontal2, direction2);

        output = zeros(res_y, res_x, 3); %%% for parfor normal rendering
        
        parfor j = 1:res_y
            outline = zeros(1, res_x, 3);
            for i = 1:res_x
                col = [0, 0, 0];
                pix_vec_sph = [0, (j-res_y/2-0.5)*pixel_span_y, (i-res_x/2-0.5)*-pixel_span_x];  

                for k = 1:subpix_y
                    for l = 1:subpix_x
                        randtime = rand * (time2 - time1) + time1;
                        rand_theta = rand * 2 * pi;
                        rand_r = rand * apert;
                        jitter_x = rand;
                        jitter_y = rand;

                        direction_int = direction2 * randtime + direction1 * (1 - randtime);
                        direction_sph_int = to_sph(direction_int);
                        
                        focal_int = focal2 * randtime + focal1 * (1 - randtime);

                        origin_int = origin2 * randtime + origin1 * (1 - randtime);
                        horizontal = horizontal2 * randtime + horizontal1 * (1 - randtime);
                        vertical = vertical2 * randtime + vertical1 * (1 - randtime);

                        subpix_vec_sph = pix_vec_sph + direction_sph_int + [0, (k - subpix_y/2 - jitter_y)*subpix_span_y, (l - subpix_x/2 - jitter_x)*-subpix_span_x];

                        origin2_int = origin_int + cos(rand_theta) * rand_r * vertical + sin(rand_theta) * rand_r * horizontal;
                        ray_vec = origin_int + to_xyz(subpix_vec_sph) * focal_int - origin2_int;
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
        ray_direction_sph = to_sph(obj.direction) + [0, (position(2)-0.5)*obj.fov(1), (position(1)-0.5)*-obj.fov(2)]; % 0, y, x

        focusray = ray(obj.origin, to_xyz(ray_direction_sph), [0, 0, 0], [1, 1, 1], obj.material);

        [~, t, ~] = scene.intersect(focusray);

        if t == inf
            t = 10000;
        end

        obj.focus(t);
    end
end
end