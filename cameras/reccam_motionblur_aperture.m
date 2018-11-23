classdef reccam_motionblur_aperture < reccam_motionblur

properties
    focal_length
    focal_lengthlast
    aperture
    focal_length_buffer
end

methods
    function obj = reccam_motionblur_aperture(transform, fov, subpix, image, material, skybox, max_bounces, focal_length, aperture, time)
        obj = obj@reccam_motionblur(transform, fov, subpix, image, material, skybox, max_bounces, time);        
        obj.time = time; 
        obj.focal_length = focal_length;
        obj.aperture = aperture;
    end
    
    function update(obj)
        obj.originlast = obj.origin;
        obj.origin = obj.transformation.multVec([0, 0, 0]);
        transform_norm = obj.transformation.transformDir;
        obj.directionlast = obj.direction;
        obj.direction = transform_norm.multDir([0, 1, 0]);
        obj.focal_lengthlast = obj.focal_length;
        obj.focal_length = obj.focal_length_buffer;
    end

    function raytrace(obj, scene)
        
        tot_subpix = obj.subpix(1) * obj.subpix(2);
        fov_y = obj.fov(1);
        fov_x = obj.fov(2);
        res_y = obj.image.sizey;
        res_x = obj.image.sizex;
        subpix_y = obj.subpix(1);
        subpix_x = obj.subpix(2);
        is_in = obj.material;
        origin1 = obj.origin;
        origin2 = obj.originlast;
        direction1 = obj.direction;
        direction2 = obj.directionlast;
        time1 = obj.time(1);
        time2 = obj.time(2);
        apert = obj.aperture;
        focal1 = obj.focal_lengthlast;
        focal2 = obj.focal_length;

        horizontal1 = cross(direction1, [0, 0, 1]); % maybe have those cached?
        horizontal2 = cross(direction2, [0, 0, 1]);
        vertical1 = cross(horizontal1, direction1);
        vertical2 = cross(horizontal2, direction2);
        focuspoint1 = origin1 + focal1 * direction1;
        focuspoint2 = origin2 + focal2 * direction2;
        pixel_span_x1 = focal1 * tan(fov_x/2)*2/res_x; % maybe have those cached?
        pixel_span_x2 = focal2 * tan(fov_x/2)*2/res_x; % maybe have those cached?
        pixel_span_y1 = focal1 * tan(fov_y/2)*2/res_y;
        pixel_span_y2 = focal2 * tan(fov_y/2)*2/res_y;

        output = zeros(res_y, res_x, 3); %%% for parfor normal rendering
        
        parfor j = 1:res_y
            outline = zeros(1, res_x, 3);
            for i = 1:res_x
                col = [0, 0, 0];

                for k = 1:subpix_y
                    for l = 1:subpix_x
                        randtime = rand * (time2 - time1) + time1;
                        rand_theta = rand * 2 * pi;
                        rand_r = rand * apert;

                        focuspoint_int = focuspoint2 * randtime + focuspoint1 * (1 - randtime);
                        origin_int = origin2 * randtime + origin1 * (1 - randtime);
                        horizontal_int = horizontal2 * randtime + horizontal1 * (1 - randtime);
                        vertical_int = vertical2 * randtime + vertical1 * (1 - randtime);
                        
                        pixel_span_x_int = pixel_span_x2 * randtime + pixel_span_x1 * (1 - randtime);
                        pixel_span_y_int = pixel_span_y2 * randtime + pixel_span_y1 * (1 - randtime);

                        origin2_int = origin_int + cos(rand_theta) * rand_r * vertical_int + sin(rand_theta) * rand_r * horizontal_int;
                        
                        pix_point = -(j-res_y/2-0.5) * horizontal_int * pixel_span_y_int + (i-res_x/2-0.5) * vertical_int * pixel_span_x_int;
                        ray_point = focuspoint_int + pix_point - horizontal_int * pixel_span_y_int*(k/subpix_y-0.5) - vertical_int * pixel_span_x_int*(l/subpix_x-0.5);
                        ray_vec = ray_point - origin2_int;
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

    function show(obj, fignumber)
        figure(fignumber);
        imshow(obj.image.img);
    end
end
end