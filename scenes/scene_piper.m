%% Scene
scene_name = 'piper';
scene_struct = struct();
scene_struct.scene.Attributes.name = scene_name;
%scene_struct.scene.Attributes.primitive_list = 'planegrey1, planegrey2';
scene_struct.scene.Attributes.mesh_list = 'piper';

%% Textures
texture_cell = cell(1, 1);

texture_cell{1}.Attributes.name = 'piper_diffuse';
texture_cell{1}.Attributes.type = 'texture';
texture_cell{1}.Attributes.filename = '.\assets\piper_pa18_obj\piper_diffuse.jpg';

scene_struct.scene.textures.texture = texture_cell;

%% Scattering
scatterer_cell = cell(2, 1);

scatterer_cell{1}.Attributes.name = 'air_absorber';
scatterer_cell{1}.Attributes.type = 'nonabsorber';

scatterer_cell{2}.Attributes.name = 'glass_absorber';
scatterer_cell{2}.Attributes.type = 'absorber';
scatterer_cell{2}.emission = 'black';
scatterer_cell{2}.colour = 'grey2';
scatterer_cell{2}.emission_distance = 1000;
scatterer_cell{2}.absorption_distance = 5;

scene_struct.scene.scatterers.scatterer = scatterer_cell;

%% Materials
material_cell = cell(16, 1);

material_cell{1}.Attributes.name = 'air';
material_cell{1}.Attributes.type = 'refractive';
material_cell{1}.Attributes.emission = 'black'; % can also be array
material_cell{1}.Attributes.colour = 'white'; % can also be array
material_cell{1}.Attributes.ind = 1.001;
material_cell{1}.Attributes.priority = 0;
material_cell{1}.Attributes.scattering_fn = 'air_absorber'; % can be index or name

material_cell{2}.Attributes.name = 'difgrey';
material_cell{2}.Attributes.type = 'diffuse';
material_cell{2}.Attributes.emission = 'black'; % can also be array
material_cell{2}.Attributes.colour = 'grey1'; % can also be array
material_cell{2}.Attributes.roughness = 1;

material_cell{3}.Attributes.name = 'base1';
material_cell{3}.Attributes.type = 'diffuse_tex';
material_cell{3}.Attributes.emission = 'black'; % can also be array
material_cell{3}.Attributes.texture = 'piper_diffuse'; % can also be index
material_cell{3}.Attributes.roughness = 1;

material_cell{4}.Attributes.name = 'base_NONE1';
material_cell{4}.Attributes.type = 'diffuse_tex';
material_cell{4}.Attributes.emission = 'black'; % can also be array
material_cell{4}.Attributes.texture = 'piper_diffuse'; % can also be index
material_cell{4}.Attributes.roughness = 1;

material_cell{5}.Attributes.name = 'glass';
material_cell{5}.Attributes.type = 'reflective_refractive'; %%% CHECK should also point to diffuse map
material_cell{5}.Attributes.emission = 'black'; % can also be array
material_cell{5}.Attributes.colour = [0.95, 0.95, 0.95]; % can also be index
material_cell{5}.Attributes.ind = 1.5;
material_cell{5}.priority = 10;
material_cell{5}.scattering_fn = 'glass_absorber';

material_cell{6}.Attributes.name = 'glass_NONE';
material_cell{6}.Attributes.type = 'reflective_refractive'; %%% CHECK should also point to diffuse map
material_cell{6}.Attributes.emission = 'black'; % can also be array
material_cell{6}.Attributes.colour = [0.95, 0.95, 0.95]; % can also be index
material_cell{6}.Attributes.ind = 1.5;
material_cell{6}.priority = 11;
material_cell{6}.scattering_fn = 'glass_absorber';

material_cell{7}.Attributes.name = 'internals_alu';
material_cell{7}.Attributes.type = 'reflective_fuzz_tex';
material_cell{7}.Attributes.emission = 'black'; % can also be array
material_cell{7}.Attributes.texture = 'piper_diffuse';
material_cell{7}.Attributes.order = 1;
material_cell{7}.Attributes.diffusivity = 0.04;

material_cell{8}.Attributes.name = 'internals_alu_NONE';
material_cell{8}.Attributes.type = 'reflective_fuzz';
material_cell{8}.Attributes.emission = 'black'; % can also be array
material_cell{8}.Attributes.colour = [0.336015, 0.336015, 0.336015]; % can also be array
material_cell{8}.Attributes.order = 1;
material_cell{8}.Attributes.diffusivity = 0.04;

material_cell{9}.Attributes.name = 'internals_b';
material_cell{9}.Attributes.type = 'diffuse';
material_cell{9}.Attributes.emission = 'black'; % can also be array
material_cell{9}.Attributes.colour = [0.007214,0.007214, 0.007214];
material_cell{9}.Attributes.roughness = 1;

material_cell{10}.Attributes.name = 'mirror';
material_cell{10}.Attributes.type = 'reflective';
material_cell{10}.Attributes.emission = 'black'; % can also be array
material_cell{10}.Attributes.colour = [0.95, 0.95, 0.95]; % can also be array

material_cell{11}.Attributes.name = 'prop';
material_cell{11}.Attributes.type = 'diffuse_tex';
material_cell{11}.Attributes.emission = 'black'; % can also be array
material_cell{11}.Attributes.texture = 'piper_diffuse'; % can also be index
material_cell{11}.Attributes.roughness = 1;

material_cell{12}.Attributes.name = 'tires';
material_cell{12}.Attributes.type = 'diffuse_tex';
material_cell{12}.Attributes.emission = 'black'; % can also be array
material_cell{12}.Attributes.texture = 'piper_diffuse'; % can also be index
material_cell{12}.Attributes.roughness = 0.2;

material_cell{13}.Attributes.name = 'piper_mat';
material_cell{13}.Attributes.type = 'aggregate';
material_cell{13}.Attributes.materials_names = 'base; base_NONE; glass; glass_NONE; internals_alu; internals_alu_NONE; internals_b; mirror; prop; tires';
material_cell{13}.Attributes.materials_list = 'base; base_NONE; glass; glass_NONE; internals_alu; internals_alu_NONE; internals_b; mirror; prop; tires'; % can also be array

material_cell{14}.Attributes.name = 'coating';
material_cell{14}.Attributes.type = 'reflective';
material_cell{14}.Attributes.emission = 'black'; % can also be array
material_cell{14}.Attributes.colour = 'white'; % can also be array

material_cell{15}.Attributes.name = 'base';
material_cell{15}.Attributes.type = 'fresnelmix';
material_cell{15}.Attributes.material_refracted = 'base';
material_cell{15}.Attributes.material_reflected = 'coating';
material_cell{15}.Attributes.ind = 1.5;

material_cell{16}.Attributes.name = 'base_NONE';
material_cell{16}.Attributes.type = 'fresnelmix';
material_cell{16}.Attributes.material_refracted = 'base_NONE';
material_cell{16}.Attributes.material_reflected = 'coating';
material_cell{16}.Attributes.ind = 1.5;

scene_struct.scene.materials.material = material_cell;

%% Transform matrices

%% Meshes
mesh_geometry_cell = cell(1, 1);

mesh_geometry_cell{1}.Attributes.name = 'piper_mesh';
mesh_geometry_cell{1}.Attributes.type = 'mesh_geometry';
mesh_geometry_cell{1}.Attributes.filename = '.\assets\piper_pa18_obj\piper_pa18.obj';

scene_struct.scene.mesh_geometries.mesh_geometry = mesh_geometry_cell;

%% Objects
object_cell = cell(3, 1);

object_cell{1}.Attributes.name = 'planegrey1';
object_cell{1}.Attributes.type = 'triangle';
object_cell{1}.Attributes.material = 'difgrey'; % can also be name
object_cell{1}.Attributes.points = [-2, 4, -0.5; -2, 0, -0.5; 2, 0, -0.5];
object_cell{1}.Attributes.normals = NaN;
object_cell{1}.Attributes.texture_coordinates = NaN;
object_cell{1}.Attributes.transform_matrix = NaN; % if not empty, search for right matrix, if empty, create.

object_cell{2}.Attributes.name = 'planegrey2';
object_cell{2}.Attributes.type = 'triangle';
object_cell{2}.Attributes.material = 'difgrey'; % can also be name
object_cell{2}.Attributes.points = [-2, 4, -0.5; 2, 0, -0.5; 2, 4, -0.5];
object_cell{2}.Attributes.normals = NaN;
object_cell{2}.Attributes.texture_coordinates = NaN;
object_cell{2}.Attributes.transform_matrix = NaN; % if not empty, search for right matrix, if empty, create.

object_cell{3}.Attributes.name = 'piper';
object_cell{3}.Attributes.type = 'mesh';
object_cell{3}.Attributes.mesh_geometry = 'piper_mesh';
object_cell{3}.Attributes.material = 'piper_mat'; % can also be name
object_cell{3}.Attributes.transform_matrix = NaN; % if not empty, search for right matrix, if empty, create.
transformation_pre_cell = cell(5, 1);
transformation_pre_cell{1}.Attributes.type = 'translate';
transformation_pre_cell{1}.Attributes.value = [0, 1.75, -0.25];
transformation_pre_cell{2}.Attributes.type = 'uniformscale';
transformation_pre_cell{2}.Attributes.value = 0.2;
transformation_pre_cell{3}.Attributes.type = 'rotatex';
transformation_pre_cell{3}.Attributes.value = pi/2;
transformation_pre_cell{4}.Attributes.type = 'rotatez';
transformation_pre_cell{4}.Attributes.value = pi/8;
transformation_pre_cell{5}.Attributes.type = 'rotatezaxis';
transformation_pre_cell{5}.Attributes.value = pi;
object_cell{3}.transformations_pre.transformation_pre = transformation_pre_cell;

scene_struct.scene.objects.object = object_cell;

%% Directional lights
directional_light_cell = cell(1, 1);

directional_light_cell{1}.Attributes.name = 'sun';
directional_light_cell{1}.Attributes.colour = [2.5, 2.5, 2] * 2;
directional_light_cell{1}.Attributes.transform_matrix = NaN;
transformation_pre_cell = cell(3, 1);
transformation_pre_cell{1}.Attributes.type = 'uniformscale';
transformation_pre_cell{1}.Attributes.value = 0.95;
transformation_pre_cell{2}.Attributes.type = 'rotatez';
transformation_pre_cell{2}.Attributes.value = -pi/4;
transformation_pre_cell{3}.Attributes.type = 'rotatex';
transformation_pre_cell{3}.Attributes.value = -3 * pi/8;
directional_light_cell{1}.transformations_pre.transformation_pre = transformation_pre_cell;

scene_struct.scene.directional_lights.directional_light = directional_light_cell;

%% Skyboxes
skybox_cell = cell(1, 1);

skybox_cell{1}.Attributes.name = 'day';
skybox_cell{1}.Attributes.type = 'skybox_flat_sun';
skybox_cell{1}.Attributes.colour = [0.8040, 0.8825, 0.9765];
skybox_cell{1}.Attributes.lights = 'sun'; % can be array of indices, or cell array of names. Maybe should be another struct?

scene_struct.scene.skyboxes.skybox = skybox_cell;

%% Image buffers
res_x = 1800;
res_y = 1200;
imgbuffer_cell = cell(1, 1);

imgbuffer_cell{1}.Attributes.name = 'buffer1';
imgbuffer_cell{1}.Attributes.type = 'imgbuffer';
imgbuffer_cell{1}.Attributes.resx = res_x;
imgbuffer_cell{1}.Attributes.resy = res_y;

scene_struct.scene.imgbuffers.imgbuffer = imgbuffer_cell;

%% Camera
aspect_ratio = res_x/res_y;
fov(2) = 80 * pi/180;
fov(1) = fov(2)/aspect_ratio;

camera_cell = cell(1, 1);

camera_cell{1}.Attributes.name = 'camera1';
camera_cell{1}.Attributes.type = 'cam_aperture';
camera_cell{1}.Attributes.transform_matrix = NaN;
camera_cell{1}.Attributes.filename = NaN; % if is empty, use next available with scene name
upvector = [0, 0, 1];
camera_cell{1}.Attributes.up = upvector/norm(upvector);
camera_cell{1}.Attributes.fov = fov;
camera_cell{1}.Attributes.subpix = [1, 1];
camera_cell{1}.Attributes.imgbuffer = 1; % can be index or name
camera_cell{1}.Attributes.medium_list = 'air; air'; % can be index or name
camera_cell{1}.Attributes.skybox = 'day'; % can be index or name
camera_cell{1}.Attributes.max_bounces = 8;
camera_cell{1}.Attributes.gammaind = 1;
camera_cell{1}.Attributes.focal_length = 1.5;
camera_cell{1}.Attributes.aperture = 0.01;
camera_cell{1}.Attributes.rendermode = 'accumulation';
camera_cell{1}.Attributes.n_iter = inf;
transformation_pre_cell = cell(1, 1);
transformation_pre_cell{1}.Attributes.type = 'rotatez';
transformation_pre_cell{1}.Attributes.value = pi;
camera_cell{1}.transformations_pre.transformation_pre = transformation_pre_cell;

scene_struct.scene.cameras.camera = camera_cell;

%% Output
struct2xml(scene_struct, ['.', filesep, 'scenes', filesep, scene_name, '.xml']);