%% Scene
scene_name = 'overlap';
scene_struct = struct('scene', struct('name', scene_name));

%% Scattering
scatterer_cell = cell(3, 1);

scatterer_cell{1}.name = 'red_absorber';
scatterer_cell{1}.type = 'absorber';
scatterer_cell{1}.emission = 'black';
scatterer_cell{1}.colour = 'red';
scatterer_cell{1}.emission_distance = 1000;
scatterer_cell{1}.absorption_distance = 2;

scatterer_cell{2}.name = 'blue_absorber';
scatterer_cell{2}.type = 'absorber';
scatterer_cell{2}.emission = 'black';
scatterer_cell{2}.colour = 'watercolour';
scatterer_cell{2}.emission_distance = 1000;
scatterer_cell{2}.absorption_distance = 2;

scatterer_cell{3}.name = 'air_absorber';
scatterer_cell{3}.type = 'nonabsorber';

scene_struct.scene.scatterers.scatterer = scatterer_cell;

%% Materials
material_cell = cell(4, 1);

material_cell{1}.name = 'difgrey';
material_cell{1}.type = 'diffuse';
material_cell{1}.emission = 'black'; % can also be array
material_cell{1}.colour = 'grey1'; % can also be array
material_cell{1}.roughness = 1;

material_cell{2}.name = 'glass';
material_cell{2}.type = 'reflective_refractive_fuzz';
material_cell{2}.emission = 'black'; % can also be array
material_cell{2}.colour = 'white'; % can also be array
material_cell{2}.ind = 1.5;
material_cell{2}.priority = 30;
material_cell{2}.order = 2;
material_cell{2}.diffusivity = 0.05;
material_cell{2}.scattering_fn = 1; % can be index or name

material_cell{3}.name = 'glass2';
material_cell{3}.type = 'reflective_refractive_fuzz';
material_cell{3}.emission = 'black'; % can also be array
material_cell{3}.colour = 'white'; % can also be array
material_cell{3}.ind = 1.33;
material_cell{3}.priority = 20;
material_cell{3}.order = 1;
material_cell{3}.diffusivity = 0.05;
material_cell{3}.scattering_fn = 2; % can be index or name

material_cell{4}.name = 'air';
material_cell{4}.type = 'refractive';
material_cell{4}.emission = 'black'; % can also be array
material_cell{4}.colour = 'white'; % can also be array
material_cell{4}.ind = 1.001;
material_cell{4}.priority = 0;
material_cell{4}.scattering_fn = 3; % can be index or name

scene_struct.scene.materials.material = material_cell;

%% Transform matrices
transform_cell = cell(1, 1);

transform_cell{1}.name = 'neutralmatrix';
transform_cell{1}.value = []; % fill if is empty

scene_struct.scene.transform_matrices.transform_matrix = transform_cell;

%% Objects
object_cell = cell(4, 1);

object_cell{1}.name = 'planegrey1';
object_cell{1}.type = 'triangle';
object_cell{1}.material = 1; % can also be name
object_cell{1}.points = [-1000, 1000, -1; -1000, -1000, -1; 1000, -1000, -1];
object_cell{1}.normals = [];
object_cell{1}.texture_coordinates = [];
object_cell{1}.transform_matrix = 1; % if not empty, search for right matrix, if empty, create.

object_cell{2}.name = 'planegrey2';
object_cell{2}.type = 'triangle';
object_cell{2}.material = 1; % can also be name
object_cell{2}.points = [-1000, 1000, -1; 1000, -1000, -1; 1000, 1000, -1];
object_cell{2}.normals = [];
object_cell{2}.texture_coordinates = [];
object_cell{2}.transform_matrix = 1; % if not empty, search for right matrix, if empty, create.

object_cell{3}.name = 'sphere1';
object_cell{3}.type = 'sphere';
object_cell{3}.material = 2; % can also be name
object_cell{3}.transform_matrix = []; % if not empty, search for right matrix, if empty, create.
transformation_pre_cell = cell(2, 1);
transformation_pre_cell{1}.type = 'translation';
transformation_pre_cell{1}.value = [-0.4, 3, 0];
transformation_pre_cell{2}.type = 'uniformscale';
transformation_pre_cell{2}.value = 1;
object_cell{3}.transformations_pre.transformation_pre = transformation_pre_cell;

object_cell{4}.name = 'sphere2';
object_cell{4}.type = 'sphere';
object_cell{4}.material = 3; % can also be name
object_cell{4}.transform_matrix = []; % if not empty, search for right matrix, if empty, create.
transformation_pre_cell = cell(2, 1);
transformation_pre_cell{1}.type = 'translation';
transformation_pre_cell{1}.value = [0.7, 3, 0];
transformation_pre_cell{2}.type = 'uniformscale';
transformation_pre_cell{2}.value = 1;
object_cell{4}.transformations_pre.transformation_pre = transformation_pre_cell;

scene_struct.scene.objects.object = object_cell;

%% Directional lights
directional_light_cell = cell(1, 1);

directional_light_cell{1}.name = 'sun';
directional_light_cell{1}.colour = [2.5, 2.5, 2] * 2;
directional_light_cell{1}.transform_matrix = [];
transformation_pre_cell = cell(3, 1);
transformation_pre_cell{1}.type = 'uniformscale';
transformation_pre_cell{1}.value = 0.95;
transformation_pre_cell{2}.type = 'rotatez';
transformation_pre_cell{2}.value = -pi/4;
transformation_pre_cell{3}.type = 'rotatex';
transformation_pre_cell{3}.value = -3 * pi/8;
directional_light_cell{1}.transformations_pre.transformation_pre = transformation_pre_cell;

scene_struct.scene.directional_lights.directional_light = directional_light_cell;

%% Skyboxes
skybox_cell = cell(1, 1);

skybox_cell{1}.name = 'day';
skybox_cell{1}.type = 'skybox_flat_sun';
skybox_cell{1}.background = [0.8040, 0.8825, 0.9765];
skybox_cell{1}.lights = 1; % can be array of indices, or cell array of names. Maybe should be another struct?

scene_struct.scene.skyboxes.skybox = skybox_cell;

%% Image buffers
res_x = 1800;
res_y = 1200;
imgbuffer_cell = cell(1, 1);

imgbuffer_cell{1}.name = 'buffer1';
imgbuffer_cell{1}.type = 'imgbuffer';
imgbuffer_cell{1}.resx = res_x;
imgbuffer_cell{1}.resy = res_y;

scene_struct.scene.imgbuffers.imgbuffer = imgbuffer_cell;

%% Camera
aspect_ratio = res_x/res_y;
fov(2) = 80 * pi/180;
fov(1) = fov(2)/aspect_ratio;

camera_cell = cell(1, 1);

camera_cell{1}.name = 'camera1';
camera_cell{1}.type = 'cam';
camera_cell{1}.transformation_matrix = [];
camera_cell{1}.filename = []; % if is empty, use next available with scene name
camera_cell{1}.up = [0, 0, 1];
camera_cell{1}.fov = fov;
camera_cell{1}.subpix = [1, 1];
camera_cell{1}.imgbuffer = 1; % can be index or name
camera_cell{1}.material = 4; % can be index or name
camera_cell{1}.skybox = 1; % can be index or name
camera_cell{1}.max_bounces = 8;
camera_cell{1}.gammaind = 1;
camera_cell{1}.rendermode = 'accumulation';
camera_cell{1}.n_iter = inf;

scene_struct.scene.cameras.camera = camera_cell;

%% Output
struct2xml(scene_struct, [scene_name, '.xml']);