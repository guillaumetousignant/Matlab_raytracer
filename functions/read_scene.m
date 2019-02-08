function read_scene(xml_filename, varargin)
    %[num, status] = str2num(str) % will work for matrices, NaN, inf, i etc.

    % Colours
    load colours_mat colours

    s = xml2struct(xml_filename);

    scenename = s.scene.Attributes.name;
    new_filename = next_filename(['.', filesep, 'images', filesep, scenename, '.png']);

    %% Creation
    if isfield(s.scene, 'transform_matrices')
        n_transform_matrices = size(s.scene.transform_matrices.transform_matrix, 2);
        transform_matrices = cell(n_transform_matrices, 1);

        for i = 1:n_transform_matrices
            if n_transform_matrices == 1
                value = s.scene.transform_matrices.transform_matrix.Attributes.value;
            else
                value = s.scene.transform_matrices.transform_matrix{1, i}.Attributes.value;
            end
            [value_num, status] = str2num(value);
            
            if status
                if isnan(value_num)
                    transform_matrices{i, 1} = transformmatrix();
                else
                    %if length(value_num) == 16
                    %    value_num = reshape(value_num, [4, 4]); % maybe not needed
                    %end
                    transform_matrices{i, 1} = transformmatrix(value_num);
                end
            else
                warning('read_scene:transformFedString', 'Can''t initialise a transformation matrix with a string. Ignored.');
                transform_matrices{i, 1} = transformmatrix();
            end            
        end
    else
        n_transform_matrices = 0;
        transform_matrices = {};
    end

    if isfield(s.scene, 'textures')
        n_textures = size(s.scene.textures.texture, 2);
        textures = cell(n_textures, 1);

        for i = 1:n_textures
            if n_textures == 1
                temp = s.scene.textures.texture.Attributes;
            else
                temp = s.scene.textures.texture{1, i}.Attributes;
            end
            switch lower(temp.type)
                case 'texture'
                    textures{i, 1} = texture(temp.filename);
                otherwise
                    warning('read_scene:unknowntextureType', ['Unknown texture type "', temp.type, '", ignoring.']);
            end
        end
    else
        n_textures = 0;
        textures = {};
    end

    if isfield(s.scene, 'scatterers')
        n_scatterers = size(s.scene.scatterers.scatterer, 2);
        scatterers = cell(n_scatterers, 1);
        scatterers_medium_list = cell(n_scatterers, 1);

        for i = 1:n_scatterers
            if n_scatterers == 1
                temp = s.scene.scatterers.scatterer.Attributes;
            else
                temp = s.scene.scatterers.scatterer{1, i}.Attributes;
            end
            switch lower(temp.type)
                case 'absorber'
                    scatterers{i, 1} = absorber(get_colour(temp.emission), get_colour(temp.colour), get_value(temp.emission_distance), get_value(temp.absorption_distance));
                case 'nonabsorber'
                    scatterers{i, 1} = nonabsorber();
                case 'portal_scatterer'
                    transform_matrix = get_transform_matrix(temp.transform_matrix);
                    scatterers_medium_list{i, 1} = get_is_in(temp.medium_list);
                    scatterers{i, 1} = portal_scatterer(transform_matrix, get_value(temp.scattering_distance), []);
                case 'scatterer_exp'
                    scatterers{i, 1} = scatterer_exp(get_colour(temp.emission), get_colour(temp.colour), get_value(temp.emission_distance), get_value(temp.absorption_distance), get_value(temp.scattering_distance), get_value(temp.order), get_value(temp.scattering_angle));
                case 'scatterer'
                    scatterers{i, 1} = scatterer(get_colour(temp.emission), get_colour(temp.colour), get_value(temp.emission_distance), get_value(temp.absorption_distance), get_value(temp.scattering_distance));
                otherwise
                    scatterers{i, 1} = nonabsorber();
                    warning('read_scene:unknownScatterer', ['Unknown scattering type "', lower(temp.type), '". Ignored.']);
            end
        end
    else
        n_scatterers = 0;
        scatterers = {};
        scatterers_medium_list = {};
    end

    if isfield(s.scene, 'materials')
        n_materials = size(s.scene.materials.material, 2);
        materials = cell(n_materials, 1);
        materials_mix_list = cell(n_materials, 2);
        materials_medium_list = cell(n_materials, 1);

        for i = 1:n_materials
            if n_materials == 1
                temp = s.scene.materials.material.Attributes;
            else
                temp = s.scene.materials.material{1, i}.Attributes;
            end
            switch lower(temp.type)
                case 'diffuse_full'
                    materials{i, 1} = diffuse_full(temp.emission_map, get_texture(temp.texture), get_value(temp.roughness));
                case 'diffuse_tex'
                    materials{i, 1} = diffuse_tex(get_colour(temp.emission), get_texture(temp.texture), get_value(temp.roughness));
                case 'diffuse'
                    materials{i, 1} = diffuse(get_colour(temp.emission), get_colour(temp.colour), get_value(temp.roughness));
                case 'fresnelmix_in'
                    materials_mix_list(i, :) = get_materials(temp.material_refracted, temp.material_reflected);
                    materials{i, 1} = fresnelmix_in([], [], get_value(temp.ind));
                case 'fresnelmix'
                    materials_mix_list(i, :) = get_materials(temp.material_refracted, temp.material_reflected);
                    materials{i, 1} = fresnelmix([], [], get_value(temp.ind));
                case 'normal_material'
                    materials{i, 1} = normal_material();
                case 'portal_refractive'
                    materials{i, 1} = diffuse([0, 0, 0], [0.5 0.5 0.5], 1);
                    warning('read_scene:portal_refractiveNotImplemented', 'Portal_refractive not implemented, ignoring.');
                case 'portal'
                    transform_matrix = get_transform_matrix(temp.transform_matrix);
                    materials_medium_list{i, 1} = get_is_in(temp.medium_list);
                    materials{i, 1} = portal(transform_matrix, []);
                case 'randommix_in'
                    materials_mix_list(i, :) = get_materials(temp.material_refracted, temp.material_reflected);
                    materials{i, 1} = randommix_in([], [], get_value(temp.ratio));
                case 'randommix'
                    materials_mix_list(i, :) = get_materials(temp.material_refracted, temp.material_reflected);
                    materials{i, 1} = randommix([], [], get_value(temp.ratio));
                case 'reflective_fuzz'
                    materials{i, 1} = reflective_fuzz(get_colour(temp.emission), get_colour(temp.colour), get_value(temp.order), get_value(temp.diffusivity));
                case 'reflective_refractive_fuzz'
                    scattering_fn = get_scattering_fn(temp.scattering_fn);
                    materials{i, 1} = reflective_refractive_fuzz(get_colour(temp.emission), get_colour(temp.colour), get_value(temp.ind), get_value(temp.priority), get_value(temp.order), get_value(temp.diffusivity), scattering_fn);
                case 'reflective_refractive'
                    scattering_fn = get_scattering_fn(temp.scattering_fn);
                    materials{i, 1} = reflective_refractive(get_colour(temp.emission), get_colour(temp.colour), get_value(temp.ind), get_value(temp.priority), scattering_fn);
                case 'reflective'
                    materials{i, 1} = reflective(get_colour(temp.emission), get_colour(temp.colour));
                case 'refractive_fuzz'
                    scattering_fn = get_scattering_fn(temp.scattering_fn);
                    materials{i, 1} = refractive_fuzz(get_colour(temp.emission), get_colour(temp.colour), get_colour(temp.ind), get_colour(temp.priority), get_value(temp.ind), get_value(temp.diffusivity), scattering_fn);
                case 'refractive'
                    scattering_fn = get_scattering_fn(temp.scattering_fn);
                    materials{i, 1} = refractive(get_colour(temp.emission), get_colour(temp.colour), get_colour(temp.ind), get_colour(temp.priority), scattering_fn);
                case 'toon'
                    materials{i, 1} = diffuse([0, 0, 0], [0.5 0.5 0.5], 1);
                    warning('read_scene:toonNotImplemented', 'Toon shader not implemented, ignoring.');
            end
        end
    else
        n_materials = 0;
        materials = {};
        materials_mix_list = {};
        materials_medium_list = {};
    end

    if isfield(s.scene, 'mesh_geometries')
        n_mesh_geometries = size(s.scene.mesh_geometries.mesh_geometry, 2);
        mesh_geometries = cell(n_mesh_geometries, 1);

        for i = 1:n_mesh_geometries
            if n_mesh_geometries == 1
                temp = s.scene.mesh_geometries.mesh_geometry.Attributes;
            else
                temp = s.scene.mesh_geometries.mesh_geometry{1, i}.Attributes;
            end
            switch lower(temp.type)
                case 'mesh_geometry'
                    mesh_geometries{i, 1} = mesh_geometry(temp.filename);
                otherwise
                    error('read_scene:unknownGeometry', ['Unknown geometry type "', lower(temp.type), '". Exiting.']);
            end
        end
    else
        n_mesh_geometries = 0;
        mesh_geometries = {};
    end

    if isfield(s.scene, 'objects')
        n_objects = size(s.scene.objects.object, 2);
        objects = cell(n_objects, 1);

        for i = 1:n_objects
            if n_objects == 1
                temp = s.scene.objects.object.Attributes;
            else
                temp = s.scene.objects.object{1, i}.Attributes;
            end
            transform_matrix = get_transform_matrix(temp.transform_matrix);
            temp_material = get_material(temp.material);
            switch lower(temp.type)
                case 'sphere'
                    objects{i, 1} = sphere(temp_material, transform_matrix);
                case 'sphere_motionblur'
                    objects{i, 1} = sphere_motionblur(temp_material, transform_matrix);
                case 'plane'
                    objects{i, 1} = plane(temp_material, transform_matrix);
                case 'mesh'
                    temp_mesh_geometry = get_mesh_geometry(temp.mesh_geometry);
                    objects{i, 1} = mesh(temp_mesh_geometry, temp_material, transform_matrix);
                case 'mesh_motionblur'
                    temp_mesh_geometry = get_mesh_geometry(temp.mesh_geometry);
                    objects{i, 1} = mesh_motionblur(temp_mesh_geometry, temp_material, transform_matrix);
                case 'triangle'
                    normals = get_value(temp.normals);
                    if isnan(normals)
                        normals = [];
                    end
                    texcoord = get_value(temp.texture_coordinates);
                    if isnan(texcoord)
                        texcoord = [];
                    end
                    objects{i, 1} = triangle(temp_material, get_value(temp.points), normals, texcoord, transform_matrix);
                case 'triangle_motionblur'
                    normals = get_value(temp.normals);
                    if isnan(normals)
                        normals = [];
                    end
                    texcoord = get_value(temp.texture_coordinates);
                    if isnan(texcoord)
                        texcoord = [];
                    end
                    objects{i, 1} = triangle_motionblur(temp_material, get_value(temp.points), normals, texcoord, transform_matrix);
                case 'triangle_mesh'
                    temp_mesh_geometry = get_mesh_geometry(temp.mesh_geometry);
                    objects{i, 1} = triangle_mesh(temp_material, temp_mesh_geometry, get_value(temp.index), transform_matrix);
                case 'triangle_mesh_motionblur'
                    temp_mesh_geometry = get_mesh_geometry(temp.mesh_geometry);
                    objects{i, 1} = triangle_mesh_motionblur(temp_material, temp_mesh_geometry, get_value(temp.index), transform_matrix); 
                otherwise
                    error('read_scene:unknownObject', ['Unknown object type "', lower(temp.type), '". Ignored.']);
            end
        end
    else
        n_objects = 0;
        objects = {};
    end

    if isfield(s.scene, 'directional_lights')
        n_directional_lights = size(s.scene.directional_lights.directional_light, 2);
        directional_lights = cell(n_directional_lights, 1);

        for i = 1:n_directional_lights
            if n_directional_lights == 1
                temp = s.scene.directional_lights.directional_light.Attributes;
            else
                temp = s.scene.directional_lights.directional_light{1, i}.Attributes;
            end
            transform_matrix = get_transform_matrix(temp.transform_matrix);
            directional_lights{i, 1} = directional_light(get_colour(temp.colour), transform_matrix);        
        end
    else
        n_directional_lights = 0;
        directional_lights = {};
    end

    if isfield(s.scene, 'skyboxes')
        n_skyboxes = size(s.scene.skyboxes.skybox, 2);
        skyboxes = cell(n_skyboxes, 1);

        for i = 1:n_skyboxes
            if n_skyboxes == 1
                temp = s.scene.skyboxes.skybox.Attributes;
            else
                temp = s.scene.skyboxes.skybox{1, i}.Attributes;
            end
            switch lower(temp.type)
                case 'skybox_flat_sun'
                    directional_lights = get_directional_lights(temp.lights);
                    skyboxes{i, 1} = skybox_flat_sun(get_colour(temp.colour), directional_lights{:});
                case 'skybox_flat'
                    skyboxes{i, 1} = skybox_flat(get_colour(temp.colour));
                case 'skybox_texture_sun'
                    skyboxes{i, 1} = skybox_texture_sun(get_texture(temp.texture), get_value(temp.light_position), get_colour(temp.light_colour), get_value(temp.light_radius));
                case 'skybox_texture_transformation_sun'
                    transform_matrix = get_transform_matrix(temp.transform_matrix);
                    skyboxes{i, 1} = skybox_texture_transformation_sun(get_texture(temp.texture), transform_matrix, get_value(temp.light_position), get_colour(temp.light_colour), get_value(temp.light_radius));
                case 'skybox_texture_transformation'
                    transform_matrix = get_transform_matrix(temp.transform_matrix);
                    skyboxes{i, 1} = skybox_texture_transformation(get_texture(temp.texture), transform_matrix);
                case 'skybox_texture'
                    skyboxes{i, 1} = skybox_texture(get_texture(temp.texture));
                otherwise
                    skyboxes{i, 1} = skybox_flat([0.5, 0.5, 0.5]);
                    warning('read_scene:unknownSkyboxType', ['Unknown skybox type "', temp.type, '", ignoring.']);
            end                    
        end
    else
        n_skyboxes = 0;
        skyboxes = {};
    end

    if isfield(s.scene, 'imgbuffers')
        n_imgbuffers = size(s.scene.imgbuffers.imgbuffer, 2);
        imgbuffers = cell(n_imgbuffers, 1);

        for i = 1:n_imgbuffers
            if n_imgbuffers == 1
                temp = s.scene.imgbuffers.imgbuffer.Attributes;
            else
                temp = s.scene.imgbuffers.imgbuffer{1, i}.Attributes;
            end
            switch lower(temp.type)
                case 'imgbuffer'
                    imgbuffers{i, 1} = imgbuffer(get_value(temp.resx), get_value(temp.resy));
                otherwise
                    imgbuffers{i, 1} = imgbuffer(300, 200);
                    warning('read_scene:unknownImgbufferType', ['Unknown imgbuffer type "', temp.type, '", ignoring.']);
            end
        end
    else
        n_imgbuffers = 0;
        imgbuffers = {};
    end

    if isfield(s.scene, 'cameras')
        n_cameras = size(s.scene.cameras.camera, 2);
        cameras = cell(n_cameras, 1);

        for i = 1:n_cameras
            if n_cameras == 1
                temp = s.scene.cameras.camera.Attributes;
            else
                temp = s.scene.cameras.camera{1, i}.Attributes;
            end            
            if strcmpi(temp.filename, 'nan')
                filename = new_filename;
            else
                filename = temp.filename; 
            end
            switch lower(temp.type)
                case 'cam'
                    cameras{i, 1} = cam(get_transform_matrix(temp.transform_matrix), filename, get_value(temp.up), get_value(temp.fov), get_value(temp.subpix), get_imgbuffer(temp.imgbuffer), get_is_in2(temp.medium_list), get_skybox(temp.skybox), get_value(temp.max_bounces), get_value(temp.gammaind));
                case 'cam_aperture'
                    cameras{i, 1} = cam_aperture(get_transform_matrix(temp.transform_matrix), filename, get_value(temp.up), get_value(temp.fov), get_value(temp.subpix), get_imgbuffer(temp.imgbuffer), get_is_in2(temp.medium_list), get_skybox(temp.skybox), get_value(temp.max_bounces), get_value(temp.focal_length), get_value(temp.aperture), get_value(temp.gammaind));
                case 'cam_motionblur'
                    cameras{i, 1} = cam_motionblur(get_transform_matrix(temp.transform_matrix), filename, get_value(temp.up), get_value(temp.fov), get_value(temp.subpix), get_imgbuffer(temp.imgbuffer), get_is_in2(temp.medium_list), get_skybox(temp.skybox), get_value(temp.max_bounces), get_value(temp.time), get_value(temp.gammaind));
                case 'cam_motionblur_aperture'
                    cameras{i, 1} = cam_motionblur_aperture(get_transform_matrix(temp.transform_matrix), filename, get_value(temp.up), get_value(temp.fov), get_value(temp.subpix), get_imgbuffer(temp.imgbuffer), get_is_in2(temp.medium_list), get_skybox(temp.skybox), get_value(temp.max_bounces), get_value(temp.focal_length), get_value(temp.aperture), get_value(temp.time), get_value(temp.gammaind));
                case 'reccam'
                    cameras{i, 1} = reccam(get_transform_matrix(temp.transform_matrix), filename, get_value(temp.up), get_value(temp.fov), get_value(temp.subpix), get_imgbuffer(temp.imgbuffer), get_is_in2(temp.medium_list), get_skybox(temp.skybox), get_value(temp.max_bounces), get_value(temp.gammaind));
                case 'reccam_aperture'
                    cameras{i, 1} = reccam_aperture(get_transform_matrix(temp.transform_matrix), filename, get_value(temp.up), get_value(temp.fov), get_value(temp.subpix), get_imgbuffer(temp.imgbuffer), get_is_in2(temp.medium_list), get_skybox(temp.skybox), get_value(temp.max_bounces), get_value(temp.focal_length), get_value(temp.aperture), get_value(temp.gammaind));
                case 'reccam_motionblur'
                    cameras{i, 1} = reccam_motionblur(get_transform_matrix(temp.transform_matrix), filename, get_value(temp.up), get_value(temp.fov), get_value(temp.subpix), get_imgbuffer(temp.imgbuffer), get_is_in2(temp.medium_list), get_skybox(temp.skybox), get_value(temp.max_bounces), get_value(temp.time), get_value(temp.gammaind));
                case 'reccam_motionblur_aperture'
                    cameras{i, 1} = reccam_motionblur_aperture(get_transform_matrix(temp.transform_matrix), filename, get_value(temp.up), get_value(temp.fov), get_value(temp.subpix), get_imgbuffer(temp.imgbuffer), get_is_in2(temp.medium_list), get_skybox(temp.skybox), get_value(temp.max_bounces), get_value(temp.focal_length), get_value(temp.aperture), get_value(temp.time), get_value(temp.gammaind));
                case 'isocam'
                    cameras{i, 1} = isocam(get_transform_matrix(temp.transform_matrix), filename, get_value(temp.up), get_value(temp.fov), get_value(temp.subpix), get_imgbuffer(temp.imgbuffer), get_is_in2(temp.medium_list), get_skybox(temp.skybox), get_value(temp.max_bounces), get_value(temp.gammaind));
                case 'isocam_aperture'
                    cameras{i, 1} = isocam_aperture(get_transform_matrix(temp.transform_matrix), filename, get_value(temp.up), get_value(temp.fov), get_value(temp.subpix), get_imgbuffer(temp.imgbuffer), get_is_in2(temp.medium_list), get_skybox(temp.skybox), get_value(temp.max_bounces), get_value(temp.focal_length), get_value(temp.aperture), get_value(temp.gammaind));
                case 'isocam_motionblur'
                    cameras{i, 1} = isocam_motionblur(get_transform_matrix(temp.transform_matrix), filename, get_value(temp.up), get_value(temp.fov), get_value(temp.subpix), get_imgbuffer(temp.imgbuffer), get_is_in2(temp.medium_list), get_skybox(temp.skybox), get_value(temp.max_bounces), get_value(temp.time), get_value(temp.gammaind));
                case 'isocam_motionblur_aperture'
                    cameras{i, 1} = isocam_motionblur_aperture(get_transform_matrix(temp.transform_matrix), filename, get_value(temp.up), get_value(temp.fov), get_value(temp.subpix), get_imgbuffer(temp.imgbuffer), get_is_in2(temp.medium_list), get_skybox(temp.skybox), get_value(temp.max_bounces), get_value(temp.focal_length), get_value(temp.aperture), get_value(temp.time), get_value(temp.gammaind));
                case 'cam_3d'
                    cameras{i, 1} = cam_3D(get_transform_matrix(temp.transform_matrix), filename, get_value(temp.up), get_value(temp.fov), get_value(temp.subpix), get_imgbuffer(temp.imgbuffer), get_imgbuffer(temp.imgbuffer_R), get_value(temp.eye_dist), get_is_in2(temp.medium_list), get_skybox(temp.skybox), get_value(temp.max_bounces), get_value(temp.focal_length), get_value(temp.gammaind));
                case 'cam_3d_aperture'
                    cameras{i, 1} = cam_3D_aperture(get_transform_matrix(temp.transform_matrix), filename, get_value(temp.up), get_value(temp.fov), get_value(temp.subpix), get_imgbuffer(temp.imgbuffer), get_imgbuffer(temp.imgbuffer_R), get_value(temp.eye_dist), get_is_in2(temp.medium_list), get_skybox(temp.skybox), get_value(temp.max_bounces), get_value(temp.focal_length), get_value(temp.aperture), get_value(temp.gammaind));
                case 'cam_3d_motionblur'
                    cameras{i, 1} = cam_3D_motionblur(get_transform_matrix(temp.transform_matrix), filename, get_value(temp.up), get_value(temp.fov), get_value(temp.subpix), get_imgbuffer(temp.imgbuffer), get_imgbuffer(temp.imgbuffer_R), get_value(temp.eye_dist), get_is_in2(temp.medium_list), get_skybox(temp.skybox), get_value(temp.max_bounces), get_value(temp.focal_length), get_value(temp.time), get_value(temp.gammaind));
                case 'cam_3d_motionblur_aperture'
                    cameras{i, 1} = cam_3D_motionblur_aperture(get_transform_matrix(temp.transform_matrix), filename, get_value(temp.up), get_value(temp.fov), get_value(temp.subpix), get_imgbuffer(temp.imgbuffer), get_imgbuffer(temp.imgbuffer_R), get_value(temp.eye_dist), get_is_in2(temp.medium_list), get_skybox(temp.skybox), get_value(temp.max_bounces), get_value(temp.focal_length), get_value(temp.aperture), get_value(temp.time), get_value(temp.gammaind));
                otherwise
                    error('read_scene:unknownCameraType', ['Unknown camera type "', temp.type, '", exiting.']);
            end
        end
    else
        n_cameras = 0;
        cameras = {};
    end


    %% Fixes
    % Materials mix fix
    for i = 1:n_materials
        if ~isempty(materials_mix_list{i, 1})
            materials{i, 1}.material_refracted = materials{materials_mix_list{i, 1}, 1};
            materials{i, 1}.material_reflected = materials{materials_mix_list{i, 2}, 1};
        end
    end

    % Materials medium_list fix
    for i = 1:n_materials
        if ~isempty(materials_medium_list{i, 1})
            medium_list = cell(length(materials_medium_list{i, 1}), 1);
            for j = 1:length(materials_medium_list{i, 1})
                medium_list{j, 1} = materials{materials_medium_list{i, 1}(j)};
            end

            materials{i, 1}.medium_list = medium_list;
        end
    end

    % Scatterers medium_list fix
    for i = 1:n_scatterers
        if ~isempty(scatterers_medium_list{i, 1})
            medium_list = cell(length(scatterers_medium_list{i, 1}), 1);
            for j = 1:length(scatterers_medium_list{i, 1})
                medium_list{j, 1} = materials{scatterers_medium_list{i, 1}(j)};
            end

            scatterers{i, 1}.medium_list = medium_list;
        end
    end


    %% Updating pre
    for i = 1:n_directional_lights
        if n_directional_lights == 1
            temp = s.scene.directional_lights.directional_light;
        else
            temp = s.scene.directional_lights.directional_light{1, i};
        end
        if isfield(temp, 'transformations_pre')
            n_transforms = size(temp.transformations_pre.transformation_pre, 2);
            for j = 1:n_transforms
                if n_transforms == 1
                    transform_struct = temp.transformations_pre.transformation_pre.Attributes;
                else
                    transform_struct = temp.transformations_pre.transformation_pre{1, j}.Attributes;
                end
                apply_transformation(directional_lights{i, 1}, transform_struct);
            end
        end      
        directional_lights{i, 1}.update;
    end

    for i = 1:n_objects
        if n_objects == 1
            temp = s.scene.objects.object;
        else
            temp = s.scene.objects.object{1, i};
        end
        if isfield(temp, 'transformations_pre')
            n_transforms = size(temp.transformations_pre.transformation_pre, 2);
            for j = 1:n_transforms
                if n_transforms == 1
                    transform_struct = temp.transformations_pre.transformation_pre.Attributes;
                else
                    transform_struct = temp.transformations_pre.transformation_pre{1, j}.Attributes;
                end
                apply_transformation(objects{i, 1}, transform_struct);
            end
        end      
        objects{i, 1}.update;
    end

    for i = 1:n_cameras
        if n_cameras == 1
            temp = s.scene.cameras.camera;
        else
            temp = s.scene.cameras.camera{1, i};
        end
        if isfield(temp, 'transformations_pre')
            n_transforms = size(temp.transformations_pre.transformation_pre, 2);
            for j = 1:n_transforms
                if n_transforms == 1
                    transform_struct = temp.transformations_pre.transformation_pre.Attributes;
                else
                    transform_struct = temp.transformations_pre.transformation_pre{1, j}.Attributes;
                end
                apply_transformation(cameras{i, 1}, transform_struct);
            end
        end      
        cameras{i, 1}.update;
    end

    %% Updating post


    %% Scene building
    if isfield(s.scene.Attributes, 'primitive_list')
        primitives = get_primitives(s.scene.Attributes.primitive_list);
    else
        primitives = {};
    end
    if isfield(s.scene.Attributes, 'mesh_list')
        meshes = get_primitives(s.scene.Attributes.mesh_list);
    else
        meshes = {};
    end

    ascene = scene(primitives{:});

    for i = 1:size(meshes, 1)
        ascene.addmesh(meshes{i, 1});
    end

    ascene.update;
    ascene.buildacc;

    % Autofocus
    for i = 1:n_cameras
        if n_cameras == 1
            temp = s.scene.cameras.camera.Attributes;
        else
            temp = s.scene.cameras.camera{1, i}.Attributes;
        end
        if isfield(temp, 'focal_length') && isnan(get_value(temp.focal_length))
            cameras{i, 1}.autofocus(ascene, get_value(temp.focus_position));
        end
        cameras{i, 1}.update;
    end
  

    %% Running
    for i = 1:n_cameras
        if n_cameras == 1
            temp = s.scene.cameras.camera.Attributes;
        else
            temp = s.scene.cameras.camera{1, i}.Attributes;
        end
        switch lower(temp.rendermode)
        case 'accumulation'
            n_iter = get_value(temp.n_iter);
            cameras{i, 1}.accumulate(ascene, n_iter);
        otherwise
            warning('read_scene:unknownCameraMode', ['Unknown camera mode: "', temp.rendermode, '", ignored.']);
        end
    end


    %% Functions
    function output_colour = get_colour(input_colour)
        %%% CHECK fucks up with white, pink and grey
        [output_colour, colour_status] = str2num(input_colour);
        is_in_map = isfield(colours, input_colour);
        if ~colour_status || is_in_map
            if is_in_map
                output_colour = colours.(input_colour);
            else
                output_colour = [0.5 0.5 0.5];
                warning('read_scene:unknownColour', ['Unknown colour "', input_colour, '", ignoring.']);
            end
        end
    end

    function output_scattering_fn = get_scattering_fn(input_scattering_fn)
        [input_scattering_fn_num, status_sf] = str2num(input_scattering_fn);
        if status_sf
            output_scattering_fn = scatterers{input_scattering_fn_num};
        else
            index_sf = 0;
            for j1 = 1:size(s.scene.scatterers.scatterer, 2)
                if size(s.scene.scatterers.scatterer, 2) == 1
                    temp_sf = s.scene.scatterers.scatterer.Attributes;
                else
                    temp_sf = s.scene.scatterers.scatterer{1, j1}.Attributes;
                end
                if strcmpi(temp_sf.name, input_scattering_fn)
                    output_scattering_fn = scatterers{j1};
                    index_sf = j1;
                    break
                end
            end
            if ~index_sf
                output_scattering_fn = nonabsorber();
                warning('read_scene:scattererNotFound', ['Scatterer "', input_scattering_fn, '" not found, ignoring.']);
            end
        end
    end

    function output_materials = get_materials(material_refracted, material_reflected)
        output_materials = cell(1, 2);

        input_material = material_refracted;
        [input_material_num, status_mat1] = str2num(input_material);
        if status_mat1
            output_materials{1, 1} = materials{input_material_num};
        else
            index_mat1 = 0;
            for j2 = 1:size(s.scene.materials.material, 2)
                if size(s.scene.materials.material, 2) == 1
                    temp_mat1 = s.scene.materials.material.Attributes;
                else
                    temp_mat1 = s.scene.materials.material{1, j2}.Attributes;
                end
                if strcmpi(temp_mat1.name, input_material)
                    output_materials{1, 1} = materials{j2};
                    index_mat1 = j2;
                    break
                end
            end
            if ~index_mat1
                output_materials{1, 1} = diffuse([0, 0, 0], [0.5, 0.5, 0.5], 1);
                warning('read_scene:materialNotFound', ['Material "', input_material, '" not found, ignoring.']);
            end
        end

        input_material = material_reflected;
        [input_material_num, status_mat2] = str2num(input_material);
        if status_mat2
            output_materials{1, 2} = materials{input_material_num};
        else
            index_mat2 = 0;
            for j2 = 1:size(s.scene.materials.material, 2)
                if size(s.scene.materials.material, 2) == 1
                    temp_mat2 = s.scene.materials.material.Attributes;
                else
                    temp_mat2 = s.scene.materials.material{1, j2}.Attributes;
                end
                if strcmpi(temp_mat2.name, input_material)
                    output_materials{1, 2} = materials{j2};
                    index_mat2 = j2;
                    break
                end
            end
            if ~index_mat2
                output_materials{1, 2} = diffuse([0, 0, 0], [0.5, 0.5, 0.5], 1);
                warning('read_scene:materialNotFound', ['Material "', input_material, '" not found, ignoring.']);
            end
        end
    end

    function output_material = get_material(input_material)
        [input_material_num, status_mat] = str2num(input_material);
        if status_mat
            output_material = materials{input_material_num};
        else
            index_mat = 0;
            for j6 = 1:size(s.scene.materials.material, 2)
                if size(s.scene.materials.material, 2) == 1
                    temp_mat = s.scene.materials.material.Attributes;
                else
                    temp_mat = s.scene.materials.material{1, j6}.Attributes;
                end
                if strcmpi(temp_mat.name, input_material)
                    output_material = materials{j6};
                    index_mat = j6;
                    break
                end
            end
            if ~index_mat
                output_material = diffuse([0, 0, 0], [0.5, 0.5, 0.5], 1);
                warning('read_scene:materialNotFound', ['Material "', input_material, '" not found, ignoring.']);
            end
        end
    end

    function transform_matrix_output = get_transform_matrix(transform_matrix_input)
        [transform_matrix_input_num, status_tm] = str2num(transform_matrix_input);
        if status_tm
            if isnan(transform_matrix_input_num)
                transform_matrix_output = transformmatrix();
            else
                transform_matrix_output = transform_matrices{transform_matrix_input_num};
            end
        else
            index_tm = 0;
            for j3 = 1:n_transform_matrices
                if size(s.scene.transform_matrices.transform_matrix, 2) == 1
                    temp_tm = s.scene.transform_matrices.transform_matrix.Attributes;
                else
                    temp_tm = s.scene.transform_matrices.transform_matrix{1, j3}.Attributes;
                end
                if strcmpi(temp_tm.name, transform_matrix_input)
                    transform_matrix_output = transform_matrices{j3, 1};
                    index_tm = j3;
                    break
                end
            end
            if ~index_tm
                transform_matrix_output = transformmatrix();
                warning('read_scene:transformmatrixNotFound', ['Transformation matric "', transform_matrix_input, '" not found, ignoring.']);
            end
        end
    end

    function is_in_output = get_is_in(is_in_input)
        % Returns material indices
        [value_num_in, status_in] = str2num(is_in_input);
        if status_in
            is_in_output = value_num_in;
        else
            is_in_input = strsplit(is_in_input, {',', ';'});
            index_in = zeros(1, length(is_in_input));
            for j4 = 1:length(is_in_input)
                value_temp = strtrim(is_in_input{j4});
                for k1 = 1:size(s.scene.materials.material, 2)
                    if size(s.scene.materials.material, 2) == 1
                        temp_in = s.scene.materials.material.Attributes;
                    else
                        temp_in = s.scene.materials.material{1, k1}.Attributes;
                    end
                    if strcmpi(temp_in.name, value_temp)
                        index_in(1, j4) = k1;
                        break
                    end
                end
            end
            is_in_output = index_in;
        end
    end

    function is_in_output = get_is_in2(is_in_input)
        % Returns materials
        [index_in2, status_in2] = str2num(is_in_input);
        if ~status_in2
            is_in_input = strsplit(is_in_input, {',', ';'});
            index_in2 = zeros(1, length(is_in_input));
            for j10 = 1:length(is_in_input)
                value_temp = strtrim(is_in_input{j10});
                for k1 = 1:size(s.scene.materials.material, 2)
                    if size(s.scene.materials.material, 2) == 1
                        temp_in2 = s.scene.materials.material.Attributes;
                    else
                        temp_in2 = s.scene.materials.material{1, k1}.Attributes;
                    end
                    if strcmpi(temp_in2.name, value_temp)
                        index_in2(1, j10) = k1;
                        break
                    end
                end
            end
        end
        is_in_output = cell(length(index_in2), 1);
        for j10 = 1:length(index_in2)
            is_in_output{j10, 1} = materials{index_in2(j10)};
        end
    end

    function directional_lights_output = get_directional_lights(directional_lights_input)
        [value_num_dl, status_dl] = str2num(directional_lights_input);
        if status_dl
            directional_lights_output1 = value_num_dl;
        else
            directional_lights_input = strsplit(directional_lights_input, {',', ';'});
            index_dl = zeros(1, length(directional_lights_input));
            for j5 = 1:length(directional_lights_input)
                value_temp = strtrim(directional_lights_input{j5});
                for k2 = 1:size(s.scene.directional_lights.directional_light, 2)
                    if size(s.scene.directional_lights.directional_light, 2) == 1
                        temp_dl = s.scene.directional_lights.directional_light.Attributes;
                    else
                        temp_dl = s.scene.directional_lights.directional_light{1, k2}.Attributes;
                    end
                    if strcmpi(temp_dl.name, value_temp)
                        index_dl(1, j5) = k2;
                        break
                    end
                end
            end
            directional_lights_output1 = index_dl;
        end
        directional_lights_output = cell(size(directional_lights_output1, 2), 1);
        for j5 = 1:size(directional_lights_output1, 2)
            directional_lights_output{j5, 1} = directional_lights{directional_lights_output1(1, j5), 1};
        end
    end

    function output_mesh_geometry = get_mesh_geometry(input_mesh_geometry)
        [input_mesh_geometry_num, status_mg] = str2num(input_mesh_geometry);
        if status_mg
            output_mesh_geometry = mesh_geometries{input_mesh_geometry_num};
        else
            index_mg = 0;
            for j7 = 1:size(s.scene.mesh_geometries.mesh_geometry, 2)
                if size(s.scene.mesh_geometries.mesh_geometry, 2) == 1
                    temp_mg = s.scene.mesh_geometries.mesh_geometry.Attributes;
                else
                    temp_mg = s.scene.mesh_geometries.mesh_geometry{1, j7}.Attributes;
                end
                if strcmpi(temp_mg.name, input_mesh_geometry)
                    output_mesh_geometry = mesh_geometries{j7};
                    index_mg = j7;
                    break
                end
            end
            if ~index_mg
                error('read_scene:mesh_geometryNotFound', ['Mesh geometry "', input_mesh_geometry, '" not found, exiting.']);
            end
        end
    end

    function output_imgbuffer = get_imgbuffer(input_imgbuffer)
        [input_imgbuffer_num, status_im] = str2num(input_imgbuffer);
        if status_im
            output_imgbuffer = imgbuffers{input_imgbuffer_num};
        else
            index_im = 0;
            for j8 = 1:size(s.scene.imgbuffers.imgbuffer, 2)
                if size(s.scene.imgbuffers.imgbuffer, 2) == 1
                    temp_im = s.scene.imgbuffers.imgbuffer.Attributes;
                else
                    temp_im = s.scene.imgbuffers.imgbuffer{1, j8}.Attributes;
                end
                if strcmpi(temp_im.name, input_imgbuffer)
                    output_imgbuffer = imgbuffers{j8};
                    index_im = j8;
                    break
                end
            end
            if ~index_im
                output_imgbuffer = imgbuffer(300, 200);
                warning('read_scene:imgbufferNotFound', ['Image buffer "', input_imgbuffer, '" not found, ignoring.']);
            end
        end
    end

    function output_skybox = get_skybox(input_skybox)
        [input_skybox_num, status_sk] = str2num(input_skybox);
        if status_sk
            output_skybox = skyboxes{input_skybox_num};
        else
            index_sk = 0;
            for j9 = 1:size(s.scene.skyboxes.skybox, 2)
                if size(s.scene.skyboxes.skybox, 2) == 1
                    temp_sk = s.scene.skyboxes.skybox.Attributes;
                else
                    temp_sk = s.scene.skyboxes.skybox{1, j9}.Attributes;
                end
                if strcmpi(temp_sk.name, input_skybox)
                    output_skybox = skyboxes{j9};
                    index_sk = j9;
                    break
                end
            end
            if ~index_sk
                output_skybox = skybox_flat([0.5, 0.5, 0.5]);
                warning('read_scene:skyboxNotFound', ['Skybox "', input_skybox, '" not found, ignoring.']);
            end
        end
    end

    function output_texture = get_texture(input_texture)
        [input_texture_num, status_tx] = str2num(input_texture);
        if status_tx
            output_texture = textures{input_texture_num};
        else
            index_tx = 0;
            for j10 = 1:size(s.scene.textures.texture, 2)
                if size(s.scene.textures.texture, 2) == 1
                    temp_mg = s.scene.textures.texture.Attributes;
                else
                    temp_mg = s.scene.textures.texture{1, j10}.Attributes;
                end
                if strcmpi(temp_mg.name, input_texture)
                    output_texture = textures{j10};
                    index_tx = j10;
                    break
                end
            end
            if ~index_tx
                error('read_scene:textureNotFound', ['Texture "', input_texture, '" not found, exiting.']);
            end
        end
    end

    function primitives_output = get_primitives(input_primitives)
        % Returns materials
        [index_pri, status_pri] = str2num(input_primitives);
        if ~status_pri
            input_primitives = strsplit(input_primitives, {',', ';'});
            index_pri = zeros(1, length(input_primitives));
            for j11 = 1:length(input_primitives)
                value_temp_pri = strtrim(input_primitives{j11});
                for k11 = 1:size(s.scene.objects.object, 2)
                    if size(s.scene.objects.object, 2) == 1
                        temp_pri = s.scene.objects.object.Attributes;
                    else
                        temp_pri = s.scene.objects.object{1, k11}.Attributes;
                    end
                    if strcmpi(temp_pri.name, value_temp_pri)
                        index_pri(1, j11) = k11;
                        break
                    end
                end
            end
        end
        primitives_output = cell(length(index_pri), 1);
        for j11 = 1:length(index_pri)
            primitives_output{j11, 1} = objects{index_pri(j11)};
        end
    end
end

function output_value = get_value(input_value)
    [output_value, value_status] = str2num(input_value);
    if ~value_status
        output_value = 1;
        warning('read_scene:unknownValue', ['Unknown value "', input_value, '", ignoring.']);
    end
end

function apply_transformation(object, transform)
    value = get_value(transform.value);
    switch lower(transform.type)
        case 'rotatexaxis'
            object.transformation.rotatexaxis(value);
        case 'rotateyaxis'
            object.transformation.rotateyaxis(value);
        case 'rotatezaxis'
            object.transformation.rotatezaxis(value);
        case 'rotatex'
            object.transformation.rotatex(value);
        case 'rotatey'
            object.transformation.rotatey(value);
        case 'rotatez'
            object.transformation.rotatez(value);
        case 'rotateaxis'
            vec = get_value(transform.axis);
            object.transformation.rotateaxis(vec, value);
        case 'rotate'
            vec = get_value(transform.axis);
            object.transformation.rotate(vec, value);
        case 'translate'
            object.transformation.translate(value);
        case 'scaleaxis'
            object.transformation.aleaxis(value);
        case 'uniformscaleaxis'
            object.transformation.uniformscaleaxis(value);
        case 'scale'
            object.transformation.scale(value);
        case 'uniformscale'
            object.transformation.uniformscale(value);
        case 'reflect'
            object.transformation.reflect(value);
        case 'shear'
            object.transformation.shear(value);
        case 'transpose'
            object.transformation.transpose();
        case 'invert'
            object.transformation.invert();
        case 'neg'
            object.transformation.neg();
        otherwise
            warning('read_scene:unknownTransformation', ['Transformation "', transform.type, '" not found, ignoring.']);
    end
end