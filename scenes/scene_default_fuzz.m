%% Scene
scene_name = 'default_fuzz';
scene_struct = struct();
scene_struct.scene.Attributes.name = scene_name;
scene_struct.scene.Attributes.primitive_list = 'spherepurple, mirror_fuzz, light, sphereglass_fuzz, ground';

%% Textures

%% Scattering
scatterer_cell = cell(2, 1);

scatterer_cell{1}.Attributes.name = 'air_absorber';
scatterer_cell{1}.Attributes.type = 'nonabsorber';

scatterer_cell{2}.Attributes.name = 'glass_absorber';
scatterer_cell{2}.Attributes.type = 'absorber';
scatterer_cell{2}.Attributes.emission = 'black';
scatterer_cell{2}.Attributes.colour = 'turquoise';
scatterer_cell{2}.Attributes.emission_distance = 100;
scatterer_cell{2}.Attributes.absorption_distance = 32;

scene_struct.scene.scatterers.scatterer = scatterer_cell;

%% Materials
material_cell = cell(6, 1);

material_cell{1}.Attributes.name = 'air';
material_cell{1}.Attributes.type = 'refractive';
material_cell{1}.Attributes.emission = 'black'; % can also be array
material_cell{1}.Attributes.colour = 'white'; % can also be array
material_cell{1}.Attributes.ind = 1.001;
material_cell{1}.Attributes.priority = 0;
material_cell{1}.Attributes.scattering_fn = 'air_absorber'; % can be index or name

material_cell{2}.Attributes.name = 'difpurple';
material_cell{2}.Attributes.type = 'diffuse';
material_cell{2}.Attributes.emission = 'black'; % can also be array
material_cell{2}.Attributes.colour = 'purple'; % can also be array
material_cell{2}.Attributes.roughness = 1;

material_cell{3}.Attributes.name = 'diflight';
material_cell{3}.Attributes.type = 'diffuse';
material_cell{3}.Attributes.emission = [2, 2, 2]; % can also be array
material_cell{3}.Attributes.colour = 'white'; % can also be index
material_cell{3}.Attributes.roughness = 1;

material_cell{4}.Attributes.name = 'difgreen';
material_cell{4}.Attributes.type = 'diffuse';
material_cell{4}.Attributes.emission = 'black'; % can also be array
material_cell{4}.Attributes.colour = 'green'; % can also be array
material_cell{4}.Attributes.roughness = 1;

material_cell{5}.Attributes.name = 'ref1_fuzz';
material_cell{5}.Attributes.type = 'reflective_fuzz';
material_cell{5}.Attributes.emission = 'black'; % can also be array
material_cell{5}.Attributes.colour = 'yellow'; % can also be array
material_cell{5}.Attributes.order = 1;
material_cell{5}.Attributes.diffusivity = 0.04;

material_cell{6}.Attributes.name = 'glass_fuzz';
material_cell{6}.Attributes.type = 'reflective_refractive_fuzz';
material_cell{6}.Attributes.emission = 'black'; % can also be array
material_cell{6}.Attributes.colour = 'white'; % can also be array
material_cell{6}.Attributes.ind = 1.5;
material_cell{6}.Attributes.priority = 10;
material_cell{6}.Attributes.order = 1;
material_cell{6}.Attributes.diffusivity = 0.03;
material_cell{6}.Attributes.scattering_fn = 'glass_absorber';        

scene_struct.scene.materials.material = material_cell;

%% Transform matrices

%% Meshes

%% Objects
object_cell = cell(5, 1);

object_cell{1}.Attributes.name = 'spherepurple';
object_cell{1}.Attributes.type = 'sphere';
object_cell{1}.Attributes.material = 'difpurple'; % can also be name
object_cell{1}.Attributes.transform_matrix = NaN; % if not empty, search for right matrix, if empty, create.
transformation_pre_cell = cell(2, 1);
transformation_pre_cell{1}.Attributes.type = 'translate';
transformation_pre_cell{1}.Attributes.value = [1, 2, 0.5];
transformation_pre_cell{2}.Attributes.type = 'uniformscale';
transformation_pre_cell{2}.Attributes.value = 0.5;
object_cell{1}.transformations_pre.transformation_pre = transformation_pre_cell;

object_cell{2}.Attributes.name = 'mirror_fuzz';
object_cell{2}.Attributes.type = 'sphere';
object_cell{2}.Attributes.material = 'ref1_fuzz'; % can also be name
object_cell{2}.Attributes.transform_matrix = NaN; % if not empty, search for right matrix, if empty, create.
transformation_pre_cell = cell(2, 1);
transformation_pre_cell{1}.Attributes.type = 'translate';
transformation_pre_cell{1}.Attributes.value = [-1.5, 4, -0.8];
transformation_pre_cell{2}.Attributes.type = 'uniformscale';
transformation_pre_cell{2}.Attributes.value = 1.5;
object_cell{2}.transformations_pre.transformation_pre = transformation_pre_cell;

object_cell{3}.Attributes.name = 'light';
object_cell{3}.Attributes.type = 'sphere';
object_cell{3}.Attributes.material = 'diflight'; % can also be name
object_cell{3}.Attributes.transform_matrix = NaN; % if not empty, search for right matrix, if empty, create.
transformation_pre_cell = cell(2, 1);
transformation_pre_cell{1}.Attributes.type = 'translate';
transformation_pre_cell{1}.Attributes.value = [0, 3, 0.8];
transformation_pre_cell{2}.Attributes.type = 'uniformscale';
transformation_pre_cell{2}.Attributes.value = 0.75;
object_cell{3}.transformations_pre.transformation_pre = transformation_pre_cell;

object_cell{4}.Attributes.name = 'sphereglass_fuzz';
object_cell{4}.Attributes.type = 'sphere';
object_cell{4}.Attributes.material = 'glass_fuzz'; % can also be name
object_cell{4}.Attributes.transform_matrix = NaN; % if not empty, search for right matrix, if empty, create.
transformation_pre_cell = cell(2, 1);
transformation_pre_cell{1}.Attributes.type = 'translate';
transformation_pre_cell{1}.Attributes.value = [0.5, 2, 0.2];
transformation_pre_cell{2}.Attributes.type = 'uniformscale';
transformation_pre_cell{2}.Attributes.value = 0.4;
object_cell{4}.transformations_pre.transformation_pre = transformation_pre_cell;

object_cell{5}.Attributes.name = 'ground';
object_cell{5}.Attributes.type = 'sphere';
object_cell{5}.Attributes.material = 'difgreen'; % can also be name
object_cell{5}.Attributes.transform_matrix = NaN; % if not empty, search for right matrix, if empty, create.
transformation_pre_cell = cell(2, 1);
transformation_pre_cell{1}.Attributes.type = 'translate';
transformation_pre_cell{1}.Attributes.value = [0, 0, -101];
transformation_pre_cell{2}.Attributes.type = 'uniformscale';
transformation_pre_cell{2}.Attributes.value = 100;
object_cell{5}.transformations_pre.transformation_pre = transformation_pre_cell;

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

skybox_cell{1}.Attributes.name = 'grey';
skybox_cell{1}.Attributes.type = 'skybox_flat_sun';
skybox_cell{1}.Attributes.colour = [0.75, 0.75, 0.75];
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
camera_cell{1}.Attributes.type = 'cam';
camera_cell{1}.Attributes.transform_matrix = NaN;
camera_cell{1}.Attributes.filename = NaN; % if is empty, use next available with scene name
upvector = [0, 0, 1];
camera_cell{1}.Attributes.up = upvector/norm(upvector);
camera_cell{1}.Attributes.fov = fov;
camera_cell{1}.Attributes.subpix = [1, 1];
camera_cell{1}.Attributes.imgbuffer = 1; % can be index or name
camera_cell{1}.Attributes.medium_list = 'air; air'; % can be index or name
camera_cell{1}.Attributes.skybox = 1; % can be index or name
camera_cell{1}.Attributes.max_bounces = 8;
camera_cell{1}.Attributes.gammaind = 1;
camera_cell{1}.Attributes.rendermode = 'accumulation';
camera_cell{1}.Attributes.n_iter = inf;

scene_struct.scene.cameras.camera = camera_cell;

%% Output
struct2xml(scene_struct, ['.', filesep, 'scenes', filesep, scene_name, '.xml']);