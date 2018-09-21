classdef reccam_aperture < reccam

properties
    focal_length
    aperture
end

methods
    function obj = reccam_aperture(transform, fov, subpix, image, material, skybox, max_bounces, focal_length, aperture)
        obj = obj@reccam(transform, fov, subpix, image, material, skybox, max_bounces);        
        obj.focal_length = focal_length;
        obj.aperture = aperture;
    end

    function raytrace(obj, scene)
        
        tot_subpix = obj.subpix(1) * obj.subpix(2);
        fov_y = obj.fov(1);
        fov_x = obj.fov(2);
        res_y = obj.resolution(1);
        res_x = obj.resolution(2);
        subpix_y = obj.subpix(1);
        subpix_x = obj.subpix(2);
        is_in = obj.material;
        origin1 = obj.origin;
        direction1 = obj.direction;
        apert = obj.aperture;
        focal = obj.focal_length;

        horizontal = cross(direction1, [0, 0, 1]);
        vertical = cross(horizontal, direction1);
        focuspoint = origin1 + focal * direction1;
        pixel_span_x = horizontal * focal * tan(fov_x/2)*2/res_x;
        pixel_span_y = vertical * focal * tan(fov_y/2)*2/res_y;

        output = zeros(res_y, res_x, 3); %%% for parfor normal rendering
        
        parfor j = 1:res_y
            outline = zeros(1, res_x, 3);
            for i = 1:res_x
                col = [0, 0, 0];
                
                for k = 1:subpix_y
                    for l = 1:subpix_x
                        rand_theta = rand * 2 * pi;
                        rand_r = rand * apert;

                        
                        pix_point = focuspoint - (j-res_y/2-0.5) * pixel_span_y + (i-res_x/2-0.5) * pixel_span_x;
                        origin2 = origin1 + cos(rand_theta) * rand_r * vertical + sin(rand_theta) * rand_r * horizontal;

                        ray_point = pix_point - pixel_span_y*(k/subpix_y-0.5) - pixel_span_x*(l/subpix_x-0.5);
                        ray_vec = ray_point - origin2;
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
        obj.image.set(output); %%% for parfor normal rendering
    end  
end
end