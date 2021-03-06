classdef reccam < handle

properties
    filename
    fov
    subpix
    image
    medium_list % what is the camera in? must be refractive
    skybox
    transformation
    max_bounces
    direction
    origin
    gammaind
    up % must be normalised
    up_buffer
end

methods
    function obj = reccam(transform, filename, up, fov, subpix, image, medium_list, skybox, max_bounces, gammaind)
        obj = obj@handle();    
        obj.filename = filename;    
        obj.fov = fov;        
        obj.subpix = subpix;
        obj.image = image;
        obj.medium_list = medium_list;
        obj.skybox = skybox;
        obj.transformation = transform;
        obj.max_bounces = max_bounces;
        obj.origin = obj.transformation.multVec([0, 0, 0]);
        transform_norm = obj.transformation.transformDir;
        obj.direction = transform_norm.multDir([0, 1, 0]); %%% CHECK should use transformation only? (not transformation_norm)
        obj.gammaind = gammaind;
        obj.up = up;
        obj.up_buffer = up;
    end

    function update(obj)
        obj.origin = obj.transformation.multVec([0, 0, 0]);
        transform_norm = obj.transformation.transformDir;
        obj.direction = transform_norm.multDir([0, 1, 0]); %%% CHECK should use transformation only? (not transformation_norm)
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
        up_dir = obj.up;

        horizontal = cross(direction1, up_dir); % maybe have those cached?
        vertical = cross(horizontal, direction1);
        focuspoint = origin1 + direction1;
        pixel_span_x = horizontal * tan(fov_x/2)*2/res_x; % maybe have those cached?
        pixel_span_y = vertical * tan(fov_y/2)*2/res_y;
        subpix_span_y = pixel_span_y/subpix_y;
        subpix_span_x = pixel_span_x/subpix_x;

        output = zeros(res_y, res_x, 3); %%% for parfor normal rendering
        
        parfor j = 1:res_y
            outline = zeros(1, res_x, 3);
            for i = 1:res_x
                col = [0, 0, 0];
                pix_point = focuspoint - (j-res_y/2-0.5) * pixel_span_y + (i-res_x/2-0.5) * pixel_span_x;

                for k = 1:subpix_y
                    for l = 1:subpix_x
                        jitter_x = rand;
                        jitter_y = rand;

                        ray_point = pix_point - (k - subpix_y/2 - jitter_y)*subpix_span_y - (l - subpix_x/2 - jitter_x)*subpix_span_x; %%% CHECK should be +x?
                        ray_vec = ray_point - origin1;
                        ray_vec = ray_vec/norm(ray_vec);
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

    function accumulate(obj, ascene, varargin)
        if isempty(varargin)
            niter_max = inf;
        else
            niter_max = varargin{1};
        end

        niter = 0;
        while niter < niter_max
            niter = niter + 1;
            tic
            obj.raytrace(ascene);
            fprintf('\nIteration %i done.\n', niter);
            toc

            obj.show(1);
            obj.write();
        end
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