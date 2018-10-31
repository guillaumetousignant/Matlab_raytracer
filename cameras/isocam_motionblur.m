classdef isocam_motionblur < isocam

properties
    directionlast
    originlast
    time
end

methods
    function obj = isocam_motionblur(transform, fov, subpix, image, material, skybox, max_bounces, time)
        obj = obj@isocam(transform, fov, subpix, image, material, skybox, max_bounces);        
        obj.time = time; 
        obj.directionlast = obj.direction;
        obj.originlast = obj.origin;
    end

    function update(obj)
        obj.originlast = obj.origin;
        obj.origin = obj.transformation.multVec([0, 0, 0]);
        transform_norm = obj.transformation.transformDir;
        obj.directionlast = obj.direction;
        obj.direction = transform_norm.multDir([0, 1, 0]);
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
        time1 = obj.time(1);
        time2 = obj.time(2);

        horizontal1 = cross(direction1, [0, 0, 1]);
        horizontal2 = cross(direction2, [0, 0, 1]);
        vertical1 = cross(horizontal1, direction1);
        vertical2 = cross(horizontal2, direction2);

        output = zeros(res_y, res_x, 3); %%% for parfor normal rendering
        
        parfor j = 1:res_y
            outline = zeros(1, res_x, 3);
            for i = 1:res_x
                col = [0, 0, 0];

                for k = 1:subpix_y
                    for l = 1:subpix_x
                        randtime = rand * (time2 - time1) + time1;
                        
                        direction_int = direction2 * randtime + direction1 * (1 - randtime);
                        origin_int = origin2 * randtime + origin1 * (1 - randtime);
                        horizontal_int = horizontal2 * randtime + horizontal1 * (1 - randtime);
                        vertical_int = vertical2 * randtime + vertical1 * (1 - randtime);

                        pix_origin = -vertical_int * (j-res_y/2-0.5) * pixel_span_y - horizontal_int * (i-res_x/2-0.5)*-pixel_span_x;
                        ray_origin = pix_origin + origin_int - vertical_int * pixel_span_y*(k/subpix_y-0.5) - horizontal_int * -pixel_span_x*(l/subpix_x-0.5);

                        aray = ray_motionblur(ray_origin, direction_int, [0, 0, 0], [1, 1, 1], is_in, randtime);
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

    function show(obj, fignumber)
        figure(fignumber);
        imshow(obj.image.img);
    end
end
end