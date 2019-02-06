classdef cam_3D_aperture < handle

properties
    camera
    camera_R
    focal_length
    focal_length_buffer
    eye_dist
    aperture

    filename
    fov
    subpix
    image
    image_R
    medium_list % what is the camera in? must be refractive
    skybox
    transformation
    max_bounces
    direction
    origin
    gammaind
    up
    up_buffer
end

methods
    function obj = cam_3D_aperture(transform, filename, up, fov, subpix, image, image_R, eye_dist, medium_list, skybox, max_bounces, focal_length, aperture, gammaind)
        obj = obj@handle();   
        
        point = strfind(filename, '.');
        if ~isempty(point)
            point = point(end);
            filename_L = [filename(1:point-1), '_L', filename(point:end)];
            filename_R = [filename(1:point-1), '_R', filename(point:end)];
            filename_S = [filename(1:point-1), '_S', filename(point:end)];
        else
            filename_L = [filename, '_L.png'];
            filename_R = [filename, '_R.png'];
            filename_S = [filename, '_S.png'];
        end
        
        obj.camera = cam_aperture(transform, filename_L, up, fov, subpix, image, medium_list, skybox, max_bounces, focal_length, aperture, gammaind);
        obj.camera_R = cam_aperture(transform, filename_R, up, fov, subpix, image_R, medium_list, skybox, max_bounces, focal_length, aperture, gammaind);
        
        obj.filename = filename_S;
        obj.fov = fov;        
        obj.subpix = subpix;
        obj.image = image;
        obj.image_R = image_R;
        obj.matemedium_listrial = medium_list;
        obj.skybox = skybox;
        obj.transformation = transform;
        obj.max_bounces = max_bounces;
        obj.origin = obj.transformation.multVec([0, 0, 0]);
        transform_norm = obj.transformation.transformDir;
        obj.direction = transform_norm.multDir([0, 1, 0]); %%% CHECK should use transformation only? (not transformation_norm)
        obj.focal_length = focal_length;
        obj.focal_length_buffer = focal_length;
        obj.eye_dist = eye_dist;
        obj.aperture = aperture;
        obj.gammaind = gammaind;
        obj.up = up;
        obj.up_buffer = up;

        horizontal = cross(obj.direction, up);

        obj.camera.origin = -eye_dist/2 * horizontal + obj.origin;
        obj.camera_R.origin = eye_dist/2 * horizontal + obj.origin;

        L_vec = focal_length * obj.direction + eye_dist/2 * horizontal;
        R_vec = focal_length * obj.direction - eye_dist/2 * horizontal;
        obj.camera.direction = L_vec/norm(L_vec);
        obj.camera_R.direction = R_vec/norm(R_vec);
    end

    function update(obj)
        obj.origin = obj.transformation.multVec([0, 0, 0]);
        transform_norm = obj.transformation.transformDir;
        obj.direction = transform_norm.multDir([0, 1, 0]); %%% CHECK should use transformation only? (not transformation_norm)
        %obj.direction_sph = to_sph(obj.direction);
        obj.focal_length = obj.focal_length_buffer;
        obj.up = obj.up_buffer;

        obj.camera.focal_length = obj.focal_length;
        obj.camera_R.focal_length = obj.focal_length;
        obj.camera.up = obj.up;
        obj.camera_R.up = obj.up;

        horizontal = cross(obj.direction, obj.up);

        obj.camera.origin = -obj.eye_dist/2 * horizontal + obj.origin;
        obj.camera_R.origin =  obj.eye_dist/2 * horizontal + obj.origin;

        L_vec = obj.focal_length * obj.direction + obj.eye_dist/2 * horizontal;
        R_vec = obj.focal_length * obj.direction - obj.eye_dist/2 * horizontal;
        obj.camera.direction = L_vec/norm(L_vec);
        obj.camera_R.direction = R_vec/norm(R_vec);
    end

    function raytrace(obj, scene)
        obj.camera.raytrace(scene);
        obj.camera_R.raytrace(scene);
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
            filename_L_towrite = obj.camera.filename;
            filename_R_towrite = obj.camera_R.filename;
            filename_S_towrite = obj.filename;
        elseif length(varargin) == 1
            filename_in = varargin{1};
            point = strfind(filename_in, '.');
            if ~isempty(point)
                point = point(end);
                filename_L_towrite = [filename_in(1:point-1), '_L', filename_in(point:end)];
                filename_R_towrite = [filename_in(1:point-1), '_R', filename_in(point:end)];
                filename_S_towrite = [filename_in(1:point-1), '_S', filename_in(point:end)];
            else
                filename_L_towrite = [filename_in, '_L.png'];
                filename_R_towrite = [filename_in, '_R.png'];
                filename_S_towrite = [filename_in, '_S.png'];
            end
        elseif length(varargin) == 3
            filename_L_towrite = varargin{1};
            filename_R_towrite = varargin{2};
            filename_S_towrite = varargin{3};
        else
            warning('cam_3D_aperture:wrongFileNameNumber', 'Write function takes 0, 1 or 3 arguments for 3D cams.');
            filename_L_towrite = obj.camera.filename;
            filename_R_towrite = obj.camera_R.filename;
            filename_S_towrite = obj.filename;
        end
        
        imwrite16(obj.image.img, filename_L_towrite, obj.gammaind);
        imwrite16(obj.image_R.img, filename_R_towrite, obj.gammaind);
        
        imwrite16(cat(3, obj.image.img(:, :, 1), obj.image_R.img(:, :, [2, 3])), filename_S_towrite, obj.gammaind);
    end

    function show(obj, fignumber)
        figure(fignumber);
        imshow(obj.image.img.^(1/obj.gammaind));
        figure(fignumber+1);
        imshow(obj.image_R.img.^(1/obj.gammaind));
    end

    function focus(obj, foc_dist)
        obj.focal_length_buffer = foc_dist;
    end

    function autofocus(obj, scene, position)
        % position is [x, y]
        ray_direction_sph = to_sph(obj.direction) + [0, (position(2)-0.5)*obj.fov(1), (position(1)-0.5)*-obj.fov(2)]; % 0, y, x

        focusray = ray(obj.origin, to_xyz(ray_direction_sph), [0, 0, 0], [1, 1, 1], obj.medium_list);

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