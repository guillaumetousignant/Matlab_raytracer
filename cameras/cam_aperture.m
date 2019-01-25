classdef cam_aperture < cam

properties
    focal_length
    aperture
    focal_length_buffer
end

methods
    function obj = cam_aperture(transform, up, fov, subpix, image, material, skybox, max_bounces, focal_length, aperture, gammaind)
        obj = obj@cam(transform, up, fov, subpix, image, material, skybox, max_bounces, gammaind);        
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
        direction1 = obj.direction;
        apert = obj.aperture;
        focal = obj.focal_length;
        up_dir = obj.up;

        horizontal = cross(direction1, up_dir); 
        vertical = cross(horizontal, direction1);

        output = zeros(res_y, res_x, 3); %%% for parfor normal rendering
        
        parfor j = 1:res_y
            outline = zeros(1, res_x, 3);
            for i = 1:res_x
                col = [0, 0, 0];
                pix_vec_sph = [1, pi/2 + (j-res_y/2-0.5)*pixel_span_y, (i-res_x/2-0.5)*pixel_span_x]; 

                for k = 1:subpix_y
                    for l = 1:subpix_x
                        rand_theta = rand * 2 * pi;
                        rand_r = rand * apert;
                        jitter_x = rand;
                        jitter_y = rand;
                        
                        subpix_vec_sph = pix_vec_sph + [0, (k - subpix_y/2 - jitter_y)*subpix_span_y, (l - subpix_x/2 - jitter_x)*subpix_span_x];
                        origin2 = origin1 + cos(rand_theta) * rand_r * vertical + sin(rand_theta) * rand_r * horizontal;

                        ray_vec = (origin1 + to_xyzoffset(subpix_vec_sph, [direction1; horizontal; vertical]) * focal) - origin2;
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

        horizontal = cross(obj.direction, obj.up_dir); 
        vertical = cross(horizontal, obj.direction);

        ray_direction_sph = [1, pi/2 + (position(2)-0.5)*obj.fov(1), (position(1)-0.5)*obj.fov(2)]; % 0, y, x

        focusray = ray(obj.origin, to_xyzoffset(ray_direction_sph, [obj.direction; horizontal; vertical]), [0, 0, 0], [1, 1, 1], obj.material);

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