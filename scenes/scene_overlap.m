%% Scene
scene_name = 'overlap';
scene_struct.scene.Attributes.name = scene_name;

%% Scattering
scatterer_cell = cell(3, 1);

scatterer_cell{1}.Attributes.name = 'red_absorber';
scatterer_cell{1}.Attributes.type = 'absorber';
scatterer_cell{1}.Attributes.emission = 'black';
scatterer_cell{1}.Attributes.colour = 'red';
scatterer_cell{1}.Attributes.emission_distance = 1000;
scatterer_cell{1}.Attributes.absorption_distance = 2;

scatterer_cell{2}.Attributes.name = 'blue_absorber';
scatterer_cell{2}.Attributes.type = 'absorber';
scatterer_cell{2}.Attributes.emission = 'black';
scatterer_cell{2}.Attributes.colour = 'watercolour';
scatterer_cell{2}.Attributes.emission_distance = 1000;
scatterer_cell{2}.Attributes.absorption_distance = 2;

scatterer_cell{3}.Attributes.name = 'air_absorber';
scatterer_cell{3}.Attributes.type = 'nonabsorber';

scene_struct.scene.scatterers.scatterer = scatterer_cell;

%% Materials
material_cell = cell(4, 1);

material_cell{1}.Attributes.name = 'difgrey';
material_cell{1}.Attributes.type = 'diffuse';
material_cell{1}.Attributes.emission = 'black'; % can also be array
material_cell{1}.Attributes.colour = 'grey1'; % can also be array
material_cell{1}.Attributes.roughness = 1;

material_cell{2}.Attributes.name = 'glass';
material_cell{2}.Attributes.type = 'reflective_refractive_fuzz';
material_cell{2}.Attributes.emission = 'black'; % can also be array
material_cell{2}.Attributes.colour = 'white'; % can also be array
material_cell{2}.Attributes.ind = 1.5;
material_cell{2}.Attributes.priority = 30;
material_cell{2}.Attributes.order = 2;
material_cell{2}.Attributes.diffusivity = 0.05;
material_cell{2}.Attributes.scattering_fn = 1; % can be index or name

material_cell{3}.Attributes.name = 'glass2';
material_cell{3}.Attributes.type = 'reflective_refractive_fuzz';
material_cell{3}.Attributes.emission = 'black'; % can also be array
material_cell{3}.Attributes.colour = 'white'; % can also be array
material_cell{3}.Attributes.ind = 1.33;
material_cell{3}.Attributes.priority = 20;
material_cell{3}.Attributes.order = 1;
material_cell{3}.Attributes.diffusivity = 0.05;
material_cell{3}.Attributes.scattering_fn = 2; % can be index or name

material_cell{4}.Attributes.name = 'air';
material_cell{4}.Attributes.type = 'refractive';
material_cell{4}.Attributes.emission = 'black'; % can also be array
material_cell{4}.Attributes.colour = 'white'; % can also be array
material_cell{4}.Attributes.ind = 1.001;
material_cell{4}.Attributes.priority = 0;
material_cell{4}.Attributes.scattering_fn = 3; % can be index or name

scene_struct.scene.materials.material = material_cell;

%% Transform matrices
transform_cell = cell(1, 1);

transform_cell{1}.Attributes.name = 'neutralmatrix';
transform_cell{1}.Attributes.value = NaN; % fill if is empty

scene_struct.scene.transform_matrices.transform_matrix = transform_cell;

%% Objects
object_cell = cell(4, 1);

object_cell{1}.Attributes.name = 'planegrey1';
object_cell{1}.Attributes.type = 'triangle';
object_cell{1}.Attributes.material = 1; % can also be name
object_cell{1}.Attributes.points = [-1000, 1000, -1; -1000, -1000, -1; 1000, -1000, -1];
object_cell{1}.Attributes.normals = NaN;
object_cell{1}.Attributes.texture_coordinates = NaN;
object_cell{1}.Attributes.transform_matrix = 1; % if not empty, search for right matrix, if empty, create.

object_cell{2}.Attributes.name = 'planegrey2';
object_cell{2}.Attributes.type = 'triangle';
object_cell{2}.Attributes.material = 1; % can also be name
object_cell{2}.Attributes.points = [-1000, 1000, -1; 1000, -1000, -1; 1000, 1000, -1];
object_cell{2}.Attributes.normals = NaN;
object_cell{2}.Attributes.texture_coordinates = NaN;
object_cell{2}.Attributes.transform_matrix = 1; % if not empty, search for right matrix, if empty, create.

object_cell{3}.Attributes.name = 'sphere1';
object_cell{3}.Attributes.type = 'sphere';
object_cell{3}.Attributes.material = 2; % can also be name
object_cell{3}.Attributes.transform_matrix = NaN; % if not empty, search for right matrix, if empty, create.
transformation_pre_cell = cell(2, 1);
transformation_pre_cell{1}.Attributes.type = 'translation';
transformation_pre_cell{1}.Attributes.value = [-0.4, 3, 0];
transformation_pre_cell{2}.Attributes.type = 'uniformscale';
transformation_pre_cell{2}.Attributes.value = 1;
object_cell{3}.transformations_pre.transformation_pre = transformation_pre_cell;

object_cell{4}.Attributes.name = 'sphere2';
object_cell{4}.Attributes.type = 'sphere';
object_cell{4}.Attributes.material = 3; % can also be name
object_cell{4}.Attributes.transform_matrix = NaN; % if not empty, search for right matrix, if empty, create.
transformation_pre_cell = cell(2, 1);
transformation_pre_cell{1}.Attributes.type = 'translation';
transformation_pre_cell{1}.Attributes.value = [0.7, 3, 0];
transformation_pre_cell{2}.Attributes.type = 'uniformscale';
transformation_pre_cell{2}.Attributes.value = 1;
object_cell{4}.transformations_pre.transformation_pre = transformation_pre_cell;

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
skybox_cell{1}.Attributes.background = [0.8040, 0.8825, 0.9765];
skybox_cell{1}.Attributes.lights = 1; % can be array of indices, or cell array of names. Maybe should be another struct?

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
camera_cell{1}.Attributes.type = 'cam';
camera_cell{1}.Attributes.transformation_matrix = NaN;
camera_cell{1}.Attributes.filename = NaN; % if is empty, use next available with scene name
camera_cell{1}.Attributes.up = [0, 0, 1];
camera_cell{1}.Attributes.fov = fov;
camera_cell{1}.Attributes.subpix = [1, 1];
camera_cell{1}.Attributes.imgbuffer = 1; % can be index or name
camera_cell{1}.Attributes.material = 4; % can be index or name
camera_cell{1}.Attributes.skybox = 1; % can be index or name
camera_cell{1}.Attributes.max_bounces = 8;
camera_cell{1}.Attributes.gammaind = 1;
camera_cell{1}.Attributes.rendermode = 'accumulation';
camera_cell{1}.Attributes.n_iter = inf;

scene_struct.scene.cameras.camera = camera_cell;

%% Output
struct2xml(scene_struct, ['.', filesep, 'scenes', filesep, scene_name, '.xml']);