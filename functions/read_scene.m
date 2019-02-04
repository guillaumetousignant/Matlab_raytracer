function read_scene(filename, varargin)
    %[num, status] = str2num(str) % will work for matrices, NaN, inf, i etc.

    % Colours
    load colours_mat colours

    s = xml2struct(filename);

    scenename = s.scene.Attributes.name;
    filename = next_filename(['.', filesep, 'images', filesep, scenename, '.png']);

    objects = {};
    directional_lights = {};
    skyboxes = {};
    imgbuffers = {};
    cameras = {};

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
                    value = temp.transform_matrix;
                    [value_num, status] = str2num(value);
                    if status
                        if isnan(value_num)
                            transform_matrix = transformmatrix();
                        else
                            transform_matrix = transform_matrices{value_num};
                        end
                    else
                        for j = 1:n_transform_matrices
                            if strcmpi(s.scene.transform_matrices.transform_matrix{j, 1}.Attributes.name, transform)
                                transform_matrix = transform_matrices{j, 1};
                                break
                            end
                        end
                    end

                    value = temp.is_in;
                    [value_num, status] = str2num(value);
                    if status
                        scatterers_medium_list{i, 1} = value_num;
                    else
                        value = strsplit(value, {',', ';'});
                        index = zeros(1, length(value));
                        for j = 1:length(value)
                            value_temp = strtrim(value{j});
                            for k = 1:size(s.scene.materials.material, 1)
                                if strcmpi(s.scene.materials.material{k, 1}.Attributes.name, value_temp)
                                    index(1, j) = k;
                                    break
                                end
                            end
                        end
                        scatterers_medium_list{i, 1} = index;
                    end

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
                    materials{i, 1} = 
                case 'fresnelmix'
                    materials{i, 1} = 
                case 'normal_material'
                    materials{i, 1} = normal_material();
                case 'portal_refractive'
                    materials{i, 1} = diffuse([0, 0, 0], [0.5 0.5 0.5], 1);
                    warning('read_scene:portal_refractiveNotImplemented', 'Portal_refractive not implemented, ignoring.');
                case 'portal'
                    value = temp.transform_matrix;
                    [value_num, status] = str2num(value);
                    if status
                        if isnan(value_num)
                            transform_matrix = transformmatrix();
                        else
                            transform_matrix = transform_matrices{value_num};
                        end
                    else
                        for j = 1:n_transform_matrices
                            if strcmpi(s.scene.transform_matrices.transform_matrix{j, 1}.Attributes.name, transform)
                                transform_matrix = transform_matrices{j, 1};
                                break
                            end
                        end
                    end

                    value = temp.is_in;
                    [value_num, status] = str2num(value);
                    if status
                        materials_medium_list{i, 1} = value_num;
                    else
                        value = strsplit(value, {',', ';'});
                        index = zeros(1, length(value));
                        for j = 1:length(value)
                            value_temp = strtrim(value{j});
                            for k = 1:size(s.scene.materials.material, 1)
                                if strcmpi(s.scene.materials.material{k, 1}.Attributes.name, value_temp)
                                    index(1, j) = k;
                                    break
                                end
                            end
                        end
                        materials_medium_list{i, 1} = index;
                    end

                    materials{i, 1} = portal(transform_matrix, []);
                case 'randommix_in'
                    materials{i, 1} = 
                case 'randommix'
                    materials{i, 1} = 
                case 'reflective_fuzz'
                    materials{i, 1} = 
                case 'reflective_refractive_fuzz'
                    materials{i, 1} = 
                case 'reflective_refractive'
                    materials{i, 1} = 
                case 'reflective'
                    materials{i, 1} = 
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



    % Materials mix fix
    for i = 1:n_materials
        if ~isempty(materials_mix_list{i, 1})
            
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
end

function output_value = get_value(input_value)
    [output_value, value_status] = str2num(input_value);
    if ~value_status
        output_value = 1;
        warning('read_scene:unknownValue', ['Unknown value "', input_value, '", ignoring.']);
    end
end