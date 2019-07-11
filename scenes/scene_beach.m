%% Scene
scene_name = 'beach';
scene_struct = struct();
scene_struct.scene.Attributes.name = scene_name;
%scene_struct.scene.Attributes.primitive_list = 'planegrey1, planegrey2';
scene_struct.scene.Attributes.mesh_list = 'sand, water';

%% Textures

%% Scattering
scatterer_cell = cell(2, 1);

scatterer_cell{1}.Attributes.name = 'air_absorber';
scatterer_cell{1}.Attributes.type = 'nonabsorber';

scatterer_cell{2}.Attributes.name = 'water_absorber';
scatterer_cell{2}.Attributes.type = 'scatterer';
scatterer_cell{2}.Attributes.emission = 'black';
scatterer_cell{2}.Attributes.colour = 'watercolour';
scatterer_cell{2}.Attributes.emission_distance = 0.5;
scatterer_cell{2}.Attributes.absorption_distance = 0.5;
scatterer_cell{2}.Attributes.scattering_distance = 2;

scene_struct.scene.scatterers.scatterer = scatterer_cell;

%% Materials
material_cell = cell(3, 1);

material_cell{1}.Attributes.name = 'air';
material_cell{1}.Attributes.type = 'refractive';
material_cell{1}.Attributes.emission = 'black'; % can also be array
material_cell{1}.Attributes.colour = 'white'; % can also be array
material_cell{1}.Attributes.ind = 1.001;
material_cell{1}.Attributes.priority = 0;
material_cell{1}.Attributes.scattering_fn = 'air_absorber'; % can be index or name

material_cell{2}.Attributes.name = 'sand_mat';
material_cell{2}.Attributes.type = 'diffuse';
material_cell{2}.Attributes.emission = 'black'; % can also be array
material_cell{2}.Attributes.colour = [0.9, 0.85, 0.7]; % can be array or string
material_cell{2}.Attributes.roughness = 0.5;

material_cell{3}.Attributes.name = 'water_mat';
material_cell{3}.Attributes.type = 'reflective_refractive';
material_cell{3}.Attributes.emission = 'black'; % can also be array
material_cell{3}.Attributes.colour = 'white';
material_cell{3}.Attributes.ind = 1.33;
material_cell{3}.Attributes.priority = 10;
material_cell{3}.Attributes.scattering_fn = 'water_absorber';

scene_struct.scene.materials.material = material_cell;

%% Transform matrices
transform_cell = cell(1, 1);

transform_cell{1}.Attributes.name = 'beach_matrix';
transform_cell{1}.Attributes.value = NaN; % fill if is empty

scene_struct.scene.transform_matrices.transform_matrix = transform_cell;

%% Meshes
mesh_geometry_cell = cell(2, 1);

mesh_geometry_cell{1}.Attributes.name = 'sand_mesh';
mesh_geometry_cell{1}.Attributes.type = 'mesh_geometry';
mesh_geometry_cell{1}.Attributes.filename = '.\assets\sand.obj';

mesh_geometry_cell{2}.Attributes.name = 'water_mesh';
mesh_geometry_cell{2}.Attributes.type = 'mesh_geometry';
mesh_geometry_cell{2}.Attributes.filename = '.\assets\water.obj';

scene_struct.scene.mesh_geometries.mesh_geometry = mesh_geometry_cell;

%% Objects
object_cell = cell(2, 1);

object_cell{1}.Attributes.name = 'sand';
object_cell{1}.Attributes.type = 'mesh';
object_cell{1}.Attributes.mesh_geometry = 'sand_mesh';
object_cell{1}.Attributes.material = 'sand_mat'; % can also be name
object_cell{1}.Attributes.transform_matrix = 'beach_matrix'; % if not empty, search for right matrix, if empty, create.
transformation_pre_cell = cell(4, 1);
transformation_pre_cell{1}.Attributes.type = 'translate';
transformation_pre_cell{1}.Attributes.value = [0, 1, -0.4];
transformation_pre_cell{2}.Attributes.type = 'uniformscale';
transformation_pre_cell{2}.Attributes.value = 1;
transformation_pre_cell{3}.Attributes.type = 'rotatex';
transformation_pre_cell{3}.Attributes.value = pi/2;
transformation_pre_cell{4}.Attributes.type = 'rotatez';
transformation_pre_cell{4}.Attributes.value = 5 * pi/8;
object_cell{1}.transformations_pre.transformation_pre = transformation_pre_cell;

object_cell{2}.Attributes.name = 'water';
object_cell{2}.Attributes.type = 'mesh';
object_cell{2}.Attributes.mesh_geometry = 'water_mesh';
object_cell{2}.Attributes.material = 'water_mat'; % can also be name
object_cell{2}.Attributes.transform_matrix = 'beach_matrix'; % if not empty, search for right matrix, if empty, create.

scene_struct.scene.objects.object = object_cell;

%% Directional lights
directional_light_cell = cell(1, 1);

directional_light_cell{1}.Attributes.name = 'sun';
directional_light_cell{1}.Attributes.colour = [2.5, 2.5, 2] * 2;
directional_light_cell{1}.Attributes.transform_matrix = NaN;
directional_light_cell{1}.Attributes.type = 'directional_light';
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
res_x = 300;
res_y = 200;
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
camera_cell{1}.Attributes.medium_list = 'air, air'; % can be index or name
camera_cell{1}.Attributes.skybox = 'day'; % can be index or name
camera_cell{1}.Attributes.max_bounces = 8;
camera_cell{1}.Attributes.focal_length = 1;
camera_cell{1}.Attributes.aperture = 0.01;
camera_cell{1}.Attributes.gammaind = 1;
camera_cell{1}.Attributes.rendermode = 'accumulation';
camera_cell{1}.Attributes.n_iter = inf;

scene_struct.scene.cameras.camera = camera_cell;

%% Output
struct2xml(scene_struct, ['.', filesep, 'scenes', filesep, scene_name, '.xml']);