function read_scene(filename, varargin)
    %[num, status] = str2num(str) % will work for matrices, NaN, inf, i etc.

    % Colours
    load colours_mat colours

    s = xml2struct(filename);

    scenename = s.scene.Attributes.name;
    filename = next_filename(['.', filesep, 'images', filesep, scenename, '.png']);

    objects = {};
    skyboxes = {};
    imgbuffers = {};
    cameras = {};

    %% Creation
    if isfield(s.scene, 'transform_matrices')
        n_transform_matrices = size(s.scene.transform_matrices.transform_matrix, 1);
        transform_matrices = cell(n_transform_matrices, 1);

        for i = 1:n_transform_matrices
            value = s.scene.transform_matrices.transform_matrix{i, 1}.Attributes.value;
            [value_num, status] = str2num(value);
            
            if status
                if isnan(value_num)
                    transform_matrices{i, 1} = transformmatrix();
                else
                    if length(value_num) == 16
                        value_num = reshape(value_num, [4, 4]);
                    end
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

    if isfield(s.scene, 'scatterers')
        n_scatterers = size(s.scene.scatterers.scatterer, 1);
        scatterers = cell(n_scatterers, 1);
        scatterers_medium_list = cell(n_scatterers, 1);

        for i = 1:n_scatterers
            temp = s.scene.scatterers.scatterer{i, 1}.Attributes;
            switch lower(temp.type)
                case 'absorber'
                    scatterers{i, 1} = absorber(get_colour(temp.emission), get_colour(temp.colour), get_value(temp.emission_distance), get_value(temp.absorption_distance));
                case 'nonabsorber'
                    scatterers{i, 1} = nonabsorber();
                case 'portal_scatterer'
                    transform_matrix = get_transform_matrix(temp.transform_matrix);
                    scatterers_medium_list{i, 1} = get_is_in(temp.is_in);
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
        n_materials = size(s.scene.materials.material, 1);
        materials = cell(n_materials, 1);
        materials_mix_list = cell(n_materials, 2);
        materials_medium_list = cell(n_materials, 1);

        for i = 1:n_materials
            temp = s.scene.materials.material{i, 1}.Attributes;
            switch lower(temp.type)
                case 'diffuse_full'
                    materials{i, 1} = diffuse_full(temp.emission_map, temp.texture, get_value(temp.roughness));
                case 'diffuse_tex'
                    materials{i, 1} = diffuse_tex(get_colour(temp.emission), temp.texture, get_value(temp.roughness));
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
                    materials_medium_list{i, 1} = get_is_in(temp.is_in);
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
                    materials{i, 1} = reflective_refractivefuzz(get_colour(temp.emission), get_colour(temp.colour), get_value(temp.ind), get_value(temp.priority), get_value(temp.order), get_value(temp.diffusivity), scattering_fn);
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

    if isfield(s.scene, 'directional_lights')
        n_directional_lights = size(s.scene.directional_lights.directional_light, 1);
        directional_lights = cell(n_directional_lights, 1);

        for i = 1:n_directional_lights
            temp = s.scene.directional_lights.directional_light{i, 1}.Attributes;
            transform_matrix = get_transform_matrix(temp.transform_matrix);
            directional_lights{i, 1} = directional_light(get_colour(temp.colour), transform_matrix);        
        end
    else
        n_directional_lights = 0;
        directional_lights = {};
    end

    if isfield(s.scene, 'skyboxes')
        n_skyboxes = size(s.scene.skyboxes.skybox, 1);
        skyboxes = cell(n_skyboxes, 1);

        for i = 1:n_skyboxes
            temp = s.scene.skyboxes.skybox{i, 1}.Attributes;
            switch lower(temp.type)
                case 'skybox_flat_sun'
                    skyboxes{i, 1} = 
                case 'skybox_flat'
                    skyboxes{i, 1} = skybox_flat(get_colour(temp.colour));
                case 'skybox_texture_sun'
                    skyboxes{i, 1} = 
                case 'skybox_texture_transformation_sun'
                    skyboxes{i, 1} = 
                case 'skybox_texture_transformation'
                    skyboxes{i, 1} = 
                case 'skybox_texture'
                    skyboxes{i, 1} = 
            end                    
        end
    else
        n_skyboxes = 0;
        skyboxes = {};
    end


    %% Fixes
    % Materials mix fix
    for i = 1:n_materials
        if ~isempty(materials_mix_list{i, 1})
            materials{i, 1}.material_refracted = materials{materials_mix_list{i, 1}, 1};
            materials{i, 1}.material_reflected = materials{materials_mix_list{i, 2}, 1};
        end
    end

    % Materials is_in fix
    for i = 1:n_materials
        if ~isempty(materials_medium_list{i, 1})
            is_in = cell(length(materials_medium_list{i, 1}), 1);
            for j = 1:length(materials_medium_list{i, 1})
                is_in{j, 1} = materials{materials_medium_list{i, 1}(j)};
            end

            materials{i, 1}.is_in = is_in;
        end
    end

    % Scatterers is_in fix
    for i = 1:n_scatterers
        if ~isempty(scatterers_medium_list{i, 1})
            is_in = cell(length(scatterers_medium_list{i, 1}), 1);
            for j = 1:length(scatterers_medium_list{i, 1})
                is_in{j, 1} = materials{scatterers_medium_list{i, 1}(j)};
            end

            scatterers{i, 1}.is_in = is_in;
        end
    end


    %% Updating
    for i = 1:n_directional_lights
        temp = s.scene.directional_lights.directional_light{i, 1};
        if isfield(temp, 'transformations_pre')
            n_transforms = length(temp.transformations_pre.transformation_pre);
            for j = 1:n_transforms
                apply_transformation(directional_lights{i, 1}, temp.transformations_pre.transformation_pre{j, 1}.Attributes);
            end
        end      
        directional_lights{i, 1}.update;
    end










    function output_colour = get_colour(input_colour)
        [output_colour, colour_status] = str2num(input_colour);
        if ~colour_status
            if isfield(colours, input_colour)
                output_colour = colours(input_colour);
            else
                output_colour = [0.5 0.5 0.5];
                warning('read_scene:unknownColour', ['Unknown colour "', input_colour, '", ignoring.']);
            end
        end
    end

    function output_scattering_fn = get_scattering_fn(input_scattering_fn)
        [input_scattering_fn_num, status] = str2num(input_scattering_fn);
        if status
            output_scattering_fn = scatterers{input_scattering_fn_num};
        else
            index = 0;
            for j1 = 1:size(s.scene.scatterers.scatterer, 1)
                if strcmpi(s.scene.scatterers.scatterer{j1, 1}.Attributes.name, input_scattering_fn)
                    output_scattering_fn = scatterers{j1};
                    break
                end
            end
            if ~index
                output_scattering_fn = nonabsorber();
                warning('read_scene:scattererNotFound', ['Scatterer "', input_scattering_fn, '" not found, ignoring.']);
            end
        end
    end

    function output_materials = get_materials(material_refracted, material_reflected)
        output_materials = cell(1, 2);

        input_material = material_refracted;
        [input_material_num, status] = str2num(input_material);
        if status
            output_materials{1, 1} = materials{input_material_num};
        else
            index = 0;
            for j2 = 1:size(s.scene.materials.material, 1)
                if strcmpi(s.scene.materials.material{j2, 1}.Attributes.name, input_material)
                    output_materials{1, 1} = materials{j2};
                    break
                end
            end
            if ~index
                output_materials{1, 1} = diffuse([0, 0, 0], [0.5, 0.5, 0.5], 1);
                warning('read_scene:materialNotFound', ['Material "', input_material, '" not found, ignoring.']);
            end
        end

        input_material = material_reflected;
        [input_material_num, status] = str2num(input_material);
        if status
            output_materials{1, 2} = materials{input_material_num};
        else
            index = 0;
            for j2 = 1:size(s.scene.materials.material, 1)
                if strcmpi(s.scene.materials.material{j2, 1}.Attributes.name, input_material)
                    output_materials{1, 2} = materials{j2};
                    break
                end
            end
            if ~index
                output_materials{1, 2} = diffuse([0, 0, 0], [0.5, 0.5, 0.5], 1);
                warning('read_scene:materialNotFound', ['Material "', input_material, '" not found, ignoring.']);
            end
        end
    end

    function transform_matrix_output = get_transform_matrix(transform_matrix_input)
        [transform_matrix_input_num, status] = str2num(transform_matrix_input);
        if status
            if isnan(transform_matrix_input_num)
                transform_matrix_output = transformmatrix();
            else
                transform_matrix_output = transform_matrices{transform_matrix_input_num};
            end
        else
            for j3 = 1:n_transform_matrices
                if strcmpi(s.scene.transform_matrices.transform_matrix{j3, 1}.Attributes.name, transform)
                    transform_matrix_output = transform_matrices{j3, 1};
                    break
                end
            end
        end
    end

    function is_in_output = get_is_in(is_in_input)
        [value_num, status] = str2num(is_in_input);
        if status
            is_in_output = value_num;
        else
            is_in_input = strsplit(is_in_input, {',', ';'});
            index = zeros(1, length(is_in_input));
            for j4 = 1:length(is_in_input)
                value_temp = strtrim(is_in_input{j4});
                for k1 = 1:size(s.scene.materials.material, 1)
                    if strcmpi(s.scene.materials.material{k1, 1}.Attributes.name, value_temp)
                        index(1, j4) = k1;
                        break
                    end
                end
            end
            is_in_output = index;
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
    end
end