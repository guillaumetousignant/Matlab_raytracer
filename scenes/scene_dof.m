%% Scene
scene_name = 'dof';
scene_struct = struct();
scene_struct.scene.Attributes.name = scene_name;
scene_struct.scene.Attributes.primitive_list = 'point2, point3, point4, point5, point6, planegrey1, planegrey2';

%% Textures

%% Scattering
scatterer_cell = cell(1, 1);

scatterer_cell{1}.Attributes.name = 'air_absorber';
scatterer_cell{1}.Attributes.type = 'nonabsorber';

scene_struct.scene.scatterers.scatterer = scatterer_cell;

%% Materials
material_cell = cell(3, 1);

material_cell{1}.Attributes.name = 'air';
material_cell{1}.Attributes.type = 'transparent';
material_cell{1}.Attributes.priority = 0;
material_cell{1}.Attributes.scattering_fn = 'air_absorber'; % can be index or name

material_cell{2}.Attributes.name = 'difgrey';
material_cell{2}.Attributes.type = 'diffuse';
material_cell{2}.Attributes.emission = 'black'; % can also be array
material_cell{2}.Attributes.colour = 'grey1'; % can also be array
material_cell{2}.Attributes.roughness = 1;

material_cell{3}.Attributes.name = 'difgrey2';
material_cell{3}.Attributes.type = 'diffuse';
material_cell{3}.Attributes.emission = 'black'; % can also be array
material_cell{3}.Attributes.colour = 'grey2'; % can also be index
material_cell{3}.Attributes.roughness = 0.5;      

scene_struct.scene.materials.material = material_cell;

%% Transform matrices

%% Meshes

%% Objects
object_cell = cell(7, 1);

object_cell{1}.Attributes.name = 'point2';
object_cell{1}.Attributes.type = 'sphere';
object_cell{1}.Attributes.material = 'difgrey2'; % can also be name
object_cell{1}.Attributes.transform_matrix = NaN; % if not empty, search for right matrix, if empty, create.
transformation_pre_cell = cell(2, 1);
transformation_pre_cell{1}.Attributes.type = 'translate';
transformation_pre_cell{1}.Attributes.value = [-0.5, 1, 0];
transformation_pre_cell{2}.Attributes.type = 'uniformscale';
transformation_pre_cell{2}.Attributes.value = 0.2;
object_cell{1}.transformations_pre.transformation_pre = transformation_pre_cell;

object_cell{2}.Attributes.name = 'point3';
object_cell{2}.Attributes.type = 'sphere';
object_cell{2}.Attributes.material = 'difgrey2'; % can also be name
object_cell{2}.Attributes.transform_matrix = NaN; % if not empty, search for right matrix, if empty, create.
transformation_pre_cell = cell(2, 1);
transformation_pre_cell{1}.Attributes.type = 'translate';
transformation_pre_cell{1}.Attributes.value = [0, 2, 0];
transformation_pre_cell{2}.Attributes.type = 'uniformscale';
transformation_pre_cell{2}.Attributes.value = 0.2;
object_cell{2}.transformations_pre.transformation_pre = transformation_pre_cell;

object_cell{3}.Attributes.name = 'point4';
object_cell{3}.Attributes.type = 'sphere';
object_cell{3}.Attributes.material = 'difgrey2'; % can also be name
object_cell{3}.Attributes.transform_matrix = NaN; % if not empty, search for right matrix, if empty, create.
transformation_pre_cell = cell(2, 1);
transformation_pre_cell{1}.Attributes.type = 'translate';
transformation_pre_cell{1}.Attributes.value = [0.5, 3, 0];
transformation_pre_cell{2}.Attributes.type = 'uniformscale';
transformation_pre_cell{2}.Attributes.value = 0.2;
object_cell{3}.transformations_pre.transformation_pre = transformation_pre_cell;

object_cell{4}.Attributes.name = 'point5';
object_cell{4}.Attributes.type = 'sphere';
object_cell{4}.Attributes.material = 'difgrey2'; % can also be name
object_cell{4}.Attributes.transform_matrix = NaN; % if not empty, search for right matrix, if empty, create.
transformation_pre_cell = cell(2, 1);
transformation_pre_cell{1}.Attributes.type = 'translate';
transformation_pre_cell{1}.Attributes.value = [1, 4, 0];
transformation_pre_cell{2}.Attributes.type = 'uniformscale';
transformation_pre_cell{2}.Attributes.value = 0.2;
object_cell{4}.transformations_pre.transformation_pre = transformation_pre_cell;

object_cell{5}.Attributes.name = 'point6';
object_cell{5}.Attributes.type = 'sphere';
object_cell{5}.Attributes.material = 'difgrey2'; % can also be name
object_cell{5}.Attributes.transform_matrix = NaN; % if not empty, search for right matrix, if empty, create.
transformation_pre_cell = cell(2, 1);
transformation_pre_cell{1}.Attributes.type = 'translate';
transformation_pre_cell{1}.Attributes.value = [1.5, 5, 0];
transformation_pre_cell{2}.Attributes.type = 'uniformscale';
transformation_pre_cell{2}.Attributes.value = 0.2;
object_cell{5}.transformations_pre.transformation_pre = transformation_pre_cell;

object_cell{6}.Attributes.name = 'planegrey1';
object_cell{6}.Attributes.type = 'triangle';
object_cell{6}.Attributes.material = 'difgrey'; % can also be name
object_cell{6}.Attributes.points = [-2, 4, -0.5; -2, 0, -0.5; 2, 0, -0.5];
object_cell{6}.Attributes.normals = NaN;
object_cell{6}.Attributes.texture_coordinates = NaN;
object_cell{6}.Attributes.transform_matrix = NaN; % if not empty, search for right matrix, if empty, create.

object_cell{7}.Attributes.name = 'planegrey2';
object_cell{7}.Attributes.type = 'triangle';
object_cell{7}.Attributes.material = 'difgrey'; % can also be name
object_cell{7}.Attributes.points = [-2, 4, -0.5; 2, 0, -0.5; 2, 4, -0.5];
object_cell{7}.Attributes.normals = NaN;
object_cell{7}.Attributes.texture_coordinates = NaN;
object_cell{7}.Attributes.transform_matrix = NaN; % if not empty, search for right matrix, if empty, create.

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
res_x = 1800;
res_y = 1200;
imgbuffer_cell = cell(1, 1);

imgbuffer_cell{1}.Attributes.name = 'buffer1';
imgbuffer_cell{1}.Attributes.type = 'imgbuffer_opengl';
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
camera_cell{1}.Attributes.skybox = 1; % can be index or name
camera_cell{1}.Attributes.max_bounces = 8;
camera_cell{1}.Attributes.focal_length = sqrt(0.5*0.5 + 3*3);
camera_cell{1}.Attributes.aperture = 0.05;
camera_cell{1}.Attributes.gammaind = 1;
camera_cell{1}.Attributes.rendermode = 'accumulation';
camera_cell{1}.Attributes.n_iter = inf;

scene_struct.scene.cameras.camera = camera_cell;

%% Output
struct2xml(scene_struct, ['.', filesep, 'scenes', filesep, scene_name, '.xml']);