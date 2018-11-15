classdef cam_motionblur < cam

properties
    directionlast
    %direction_sphlast
    originlast
    time
end

methods
    function obj = cam_motionblur(transform, fov, subpix, image, material, skybox, max_bounces, time)
        obj = obj@cam(transform, fov, subpix, image, material, skybox, max_bounces);  
        obj.time = time; 
        obj.directionlast = obj.direction;
        %obj.direction_sphlast = obj.direction_sph;
        obj.originlast = obj.origin;
    end

    function update(obj)
        obj.originlast = obj.origin;
        obj.origin = obj.transformation.multVec([0, 0, 0]);
        transform_norm = obj.transformation.transformDir;
        obj.directionlast = obj.direction;
        obj.direction = transform_norm.multDir([0, 1, 0]); %%% CHECK should use transformation only? (not transformation_norm)
        %obj.direction_sphlast = obj.direction_sph;
        %obj.direction_sph = to_sph(obj.direction);
    end

    function raytrace(obj, scene)
        
        tot_subpix = obj.subpix(1) * obj.subpix(2);
        pixel_span_y = obj.fov(1)/obj.resolution(1);
        pixel_span_x = obj.fov(2)/obj.resolution(2);
        res_y = obj.resolution(1);
        res_x = obj.resolution(2);
        subpix_y = obj.subpix(1);
        subpix_x = obj.subpix(2);
        is_in = obj.material;
        origin1 = obj.originlast;
        origin2 = obj.origin;
        direction1 = obj.directionlast;
        direction2 = obj.direction;
        %direction_sph1 = obj.direction_sphlast;
        %direction_sph2 = obj.direction_sph;
        time1 = obj.time(1);
        time2 = obj.time(2);

        output = zeros(res_y, res_x, 3); %%% for parfor normal rendering
        
        parfor j = 1:res_y
            outline = zeros(1, res_x, 3);
            for i = 1:res_x
                col = [0, 0, 0];
                pix_vec_sph = [0, (j-res_y/2-0.5)*pixel_span_y, (i-res_x/2-0.5)*-pixel_span_x]; 

                for k = 1:subpix_y
                    for l = 1:subpix_x
                        randtime = rand * (time2 - time1) + time1;

                        direction_int = direction2 * randtime + direction1 * (1 - randtime);
                        direction_sph_int = to_sph(direction_int);
                        origin_int = origin2 * randtime + origin1 * (1 - randtime);
                        
                        ray_vec = to_xyz(pix_vec_sph + direction_sph_int + [0, pixel_span_y*(k/subpix_y-0.5), -pixel_span_x*(l/subpix_x-0.5)]);
                        
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

    function write(obj, filename)
        imwrite16(obj.image.img, filename);
    end

    function show(obj, fignumber)
        figure(fignumber);
        imshow(obj.image.img);
    end
end
end