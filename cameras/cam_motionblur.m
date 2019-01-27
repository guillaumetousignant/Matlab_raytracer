classdef cam_motionblur < cam

properties
    directionlast
    %direction_sphlast
    originlast
    time
    uplast
end

methods
    function obj = cam_motionblur(transform, filename, up, fov, subpix, image, material, skybox, max_bounces, time, gammaind)
        obj = obj@cam(transform, filename, up, fov, subpix, image, material, skybox, max_bounces, gammaind);  
        obj.time = time; 
        obj.directionlast = obj.direction;
        %obj.direction_sphlast = obj.direction_sph;
        obj.originlast = obj.origin;
        obj.uplast = obj.up;
    end

    function update(obj)
        obj.originlast = obj.origin;
        obj.origin = obj.transformation.multVec([0, 0, 0]);
        transform_norm = obj.transformation.transformDir;
        obj.directionlast = obj.direction;
        obj.direction = transform_norm.multDir([0, 1, 0]); %%% CHECK should use transformation only? (not transformation_norm)
        %obj.direction_sphlast = obj.direction_sph;
        %obj.direction_sph = to_sph(obj.direction);
        obj.uplast = obj.up;
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
        origin1 = obj.originlast;
        origin2 = obj.origin;
        direction1 = obj.directionlast;
        direction2 = obj.direction;
        time1 = obj.time(1);
        time2 = obj.time(2);
        up1= obj.uplast;
        up2 = obj.up;

        horizontal1 = cross(direction1, up1);
        horizontal2 = cross(direction2, up2);
        vertical1 = cross(horizontal1, direction1);
        vertical2 = cross(horizontal2, direction2);

        output = zeros(res_y, res_x, 3); %%% for parfor normal rendering
        
        parfor j = 1:res_y
            outline = zeros(1, res_x, 3);
            for i = 1:res_x
                col = [0, 0, 0];
                pix_vec_sph = [1, pi/2 + (j-res_y/2-0.5)*pixel_span_y, (i-res_x/2-0.5)*pixel_span_x]; 

                for k = 1:subpix_y
                    for l = 1:subpix_x
                        randtime = rand * (time2 - time1) + time1;
                        jitter_x = rand;
                        jitter_y = rand;

                        direction_int = direction2 * randtime + direction1 * (1 - randtime);
                        horizontal_int = horizontal2 * randtime + horizontal1 * (1 - randtime);
                        vertical_int = vertical2 * randtime + vertical1 * (1 - randtime);
                        origin_int = origin2 * randtime + origin1 * (1 - randtime);
                        
                        ray_vec = to_xyzoffset(pix_vec_sph + [0, (k - subpix_y/2 - jitter_y)*subpix_span_y, (l - subpix_x/2 - jitter_x)*subpix_span_x], [direction_int; horizontal_int; vertical_int]);
                        
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

    function write(obj, varargin)
        if isempty(varargin)
            filename_towrite = obj.filename;
        else
            filename_towrite = varargin{1};
        end
        imwrite16(obj.image.img, filename_towrite, obj.gammaind);
    end

    function show(obj, fignumber)
        figure(fignumber);
        imshow(obj.image.img^(1/obj.gammaind));
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