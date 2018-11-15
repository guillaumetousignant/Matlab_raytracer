classdef isocam < handle

properties
    fov % here should be x and y lengths
    subpix
    resolution
    image
    material % what is the camera in? must be refractive
    skybox
    transformation
    max_bounces
    direction
    %direction_sph
    origin
end

methods
    function obj = isocam(transform, fov, subpix, image, material, skybox, max_bounces)
        obj = obj@handle();        
        obj.fov = fov;        
        obj.resolution = [image.sizey, image.sizex];
        obj.subpix = subpix;
        obj.image = image;
        obj.material = material;
        obj.skybox = skybox;
        obj.transformation = transform;
        obj.max_bounces = max_bounces;
        obj.origin = obj.transformation.multVec([0, 0, 0]);
        transform_norm = obj.transformation.transformDir;
        obj.direction = transform_norm.multDir([0, 1, 0]); %%% CHECK should use transformation only? (not transformation_norm)
        %obj.direction_sph = to_sph(obj.direction);
    end

    function update(obj)
        obj.origin = obj.transformation.multVec([0, 0, 0]);
        transform_norm = obj.transformation.transformDir;
        obj.direction = transform_norm.multDir([0, 1, 0]); %%% CHECK should use transformation only? (not transformation_norm)
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
        origin1 = obj.origin;
        direction1 = obj.direction;

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
                        ray_origin = pix_origin - vertical * pixel_span_y*(k/subpix_y-0.5) - horizontal * -pixel_span_x*(l/subpix_x-0.5);

                        aray = ray(ray_origin, direction1, [0, 0, 0], [1, 1, 1], is_in);
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