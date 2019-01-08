classdef cam_aperture < cam

properties
    focal_length
    aperture
    focal_length_buffer
end

methods
    function obj = cam_aperture(transform, fov, subpix, image, material, skybox, max_bounces, focal_length, aperture)
        obj = obj@cam(transform, fov, subpix, image, material, skybox, max_bounces);        
        obj.focal_length = focal_length;
        obj.focal_length_buffer = focal_length;
        obj.aperture = aperture;
    end
    
    function update(obj)
        obj.origin = obj.transformation.multVec([0, 0, 0]);
        transform_norm = obj.transformation.transformDir;
        obj.direction = transform_norm.multDir([0, 1, 0]); %%% CHECK should use transformation only? (not transformation_norm)
        %obj.direction_sph = to_sph(obj.direction);
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
        origin1 = obj.origin;
        direction1 = obj.direction;
        direction_sph1 = to_sph(direction1);
        apert = obj.aperture;
        focal = obj.focal_length;

        horizontal = cross(direction1, [0, 0, 1]); % maybe have those cached?
        vertical = cross(horizontal, direction1);

        output = zeros(res_y, res_x, 3); %%% for parfor normal rendering
        
        parfor j = 1:res_y
            outline = zeros(1, res_x, 3);
            for i = 1:res_x
                col = [0, 0, 0];
                pix_vec_sph = direction_sph1 + [0, (j-res_y/2-0.5)*pixel_span_y, (i-res_x/2-0.5)*-pixel_span_x]; 

                for k = 1:subpix_y
                    for l = 1:subpix_x
                        rand_theta = rand * 2 * pi;
                        rand_r = rand * apert;
                        jitter_x = rand;
                        jitter_y = rand;
                        
                        subpix_vec_sph = pix_vec_sph + [0, (k - subpix_y/2 - jitter_y)*subpix_span_y, (l - subpix_x/2 - jitter_x)*-subpix_span_x];
                        origin2 = origin1 + cos(rand_theta) * rand_r * vertical + sin(rand_theta) * rand_r * horizontal;

                        ray_vec = (origin1 + to_xyz(subpix_vec_sph) * focal) - origin2;
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
        imwrite16(obj.image.img, filename);
    end

    function show(obj, fignumber)
        figure(fignumber);
        imshow(obj.image.img);
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