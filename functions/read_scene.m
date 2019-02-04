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
                    scatterers{i, 1} = absorber(temp.emission, temp.colour, temp.emission_distance, temp.absorption_distance);
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

                    scatterers{i, 1} = portal_scatterer(transform_matrix, temp.scattering_distance, []);
                case 'scatterer_exp'
                    scatterers{i, 1} = scatterer_exp(temp.emission, temp.colour, temp.emission_distance, temp.absorption_distance, temp.scattering_distance, temp.order, temp.scattering_angle);
                case 'scatterer'
                    scatterers{i, 1} = scatterer(temp.emission, temp.colour, temp.emission_distance, temp.absorption_distance, temp.scattering_distance);
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
                case 'diffuse_tex'
                case 'diffuse'
                case 'fresnelmix_in'
                case 'fresnelmix'
                case 'normal_material'
                case 'portal_refractive'
                case 'portal'
                case 'randommix_in'
                case 'randommix'
                case 'reflective_fuzz'
                case 'reflective_refractive_fuzz'
                case 'reflective_refractive'
                case 'reflective'
                case 'refractive_fuzz'
                case 'refractive'
                case 'toon'
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
end