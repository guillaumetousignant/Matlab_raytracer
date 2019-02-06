classdef reccam_motionblur < reccam

properties
    directionlast
    originlast
    time
    uplast
end

methods
    function obj = reccam_motionblur(transform, filename, up, fov, subpix, image, medium_list, skybox, max_bounces, time, gammaind)
        obj = obj@reccam(transform, filename, up, fov, subpix, image, medium_list, skybox, max_bounces, gammaind);        
        obj.time = time; 
        obj.directionlast = obj.direction;
        obj.originlast = obj.origin;
        obj.uplast = obj.up;
    end

    function update(obj)
        obj.originlast = obj.origin;
        obj.origin = obj.transformation.multVec([0, 0, 0]);
        transform_norm = obj.transformation.transformDir;
        obj.directionlast = obj.direction;
        obj.direction = transform_norm.multDir([0, 1, 0]);
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
        is_in = obj.medium_list;
        origin1 = obj.originlast;
        origin2 = obj.origin;
        direction1 = obj.directionlast;
        direction2 = obj.direction;
        time1 = obj.time(1);
        time2 = obj.time(2);
        up1 = obj.uplast;
        up2 = obj.up;

        horizontal1 = cross(direction1, up1); % maybe have those cached?
        horizontal2 = cross(direction2, up2);
        vertical1 = cross(horizontal1, direction1);
        vertical2 = cross(horizontal2, direction2);
        focuspoint1 = origin1 + direction1;
        focuspoint2 = origin2 + direction2;
        pixel_span_x = tan(fov_x/2)*2/res_x; % maybe have those cached?
        pixel_span_y = tan(fov_y/2)*2/res_y;
        subpix_span_y = pixel_span_y/subpix_y;
        subpix_span_x = pixel_span_x/subpix_x;

        output = zeros(res_y, res_x, 3); %%% for parfor normal rendering
        
        parfor j = 1:res_y
            outline = zeros(1, res_x, 3);
            for i = 1:res_x
                col = [0, 0, 0];

                for k = 1:subpix_y
                    for l = 1:subpix_x
                        randtime = rand * (time2 - time1) + time1;
                        jitter_x = rand;
                        jitter_y = rand;

                        focuspoint_int = focuspoint2 * randtime + focuspoint1 * (1 - randtime);
                        origin_int = origin2 * randtime + origin1 * (1 - randtime);
                        horizontal_int = horizontal2 * randtime + horizontal1 * (1 - randtime);
                        vertical_int = vertical2 * randtime + vertical1 * (1 - randtime);
                        
                        pix_point = -(j-res_y/2-0.5) * horizontal_int * pixel_span_y + (i-res_x/2-0.5) * vertical_int * pixel_span_x;   
                        
                        ray_point = focuspoint_int + pix_point - horizontal_int * (k - subpix_y/2 - jitter_y)*subpix_span_y - vertical_int * (l - subpix_x/2 - jitter_x)*subpix_span_x;
                        ray_vec = ray_point - origin_int;
                        ray_vec = ray_vec/norm(ray_vec);
                        aray = ray_motionblur(origin_int, ray_vec, [0, 0, 0], [1, 1, 1], is_in, randtime);
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
end
end