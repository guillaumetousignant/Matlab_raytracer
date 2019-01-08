classdef isocam_aperture < isocam

properties
    focal_length
    aperture
    focal_length_buffer
end

methods
    function obj = isocam_aperture(transform, fov, subpix, image, material, skybox, max_bounces, focal_length, aperture)
        obj = obj@isocam(transform, fov, subpix, image, material, skybox, max_bounces);        
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
        apert = obj.aperture;
        focal = obj.focal_length;

        horizontal = cross(direction1, [0, 0, 1]);
        vertical = cross(horizontal, direction1);

        output = zeros(res_y, res_x, 3); %%% for parfor normal rendering
        
        parfor j = 1:res_y
            outline = zeros(1, res_x, 3);
            for i = 1:res_x
                col = [0, 0, 0];

                pix_origin = origin1 - vertical * (j-res_y/2-0.5) * pixel_span_y - horizontal * (i-res_x/2-0.5)*-pixel_span_x;

                for k = 1:subpix_y
                    for l = 1:subpix_x
                        rand_theta = rand * 2 * pi;
                        rand_r = rand * apert;
                        jitter_x = rand;
                        jitter_y = rand;

                        ray_origin = pix_origin - vertical * (k - subpix_y/2 - jitter_y)*subpix_span_y - horizontal * (l - subpix_x/2 - jitter_x)*-subpix_span_x;
                        ray_origin2 = ray_origin + cos(rand_theta) * rand_r * vertical + sin(rand_theta) * rand_r * horizontal;
                        direction2 = (ray_origin + direction1 * focal) - ray_origin2;
                        direction2 = direction2/norm(direction2);

                        aray = ray(ray_origin2, direction2, [0, 0, 0], [1, 1, 1], is_in);
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
        
    end
end
end