classdef cam_motionblur_aperture < cam_motionblur

properties
    focal_length
    aperture
end

methods
    function obj = cam_motionblur_aperture(transform, fov, subpix, image, material, skybox, max_bounces, focal_length, aperture, time)
        obj = obj@cam_motionblur(transform, fov, subpix, image, material, skybox, max_bounces, time);  
        obj.focal_length = focal_length;
        obj.aperture = aperture;
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
        origin1 = obj.originlast;
        origin2 = obj.origin;
        direction1 = obj.directionlast;
        direction2 = obj.direction;
        %direction_sph1 = to_sph(direction1);
        %direction_sph2 = to_sph(direction2);
        time1 = obj.time(1);
        time2 = obj.time(2);
        apert = obj.aperture;
        focal = obj.focal_length;

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

                        direction_int = direction2 * randtime + direction1 * (1 - randtime);
                        direction_sph_int = to_sph(direction_int);

                        origin_int = origin2 * randtime + origin1 * (1 - randtime);
                        horizontal = horizontal2 * randtime + horizontal1 * (1 - randtime);
                        vertical = vertical2 * randtime + vertical1 * (1 - randtime);

                        subpix_vec_sph = pix_vec_sph + direction_sph_int + [0, pixel_span_y*(k/subpix_y-0.5), -pixel_span_x*(l/subpix_x-0.5)];

                        origin2_int = origin_int + cos(rand_theta) * rand_r * vertical + sin(rand_theta) * rand_r * horizontal;
                        ray_vec = origin_int + to_xyz(subpix_vec_sph) * focal - origin2_int;
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
        imwrite16(obj.image.img, filename);
    end
end
end