close all;
clear all;
clc;

%% Scene
scene_name = 'scattering';
scene_struct.scene.Attributes.name = scene_name;
scene_struct.scene.Attributes.primitive_list = 'planegrey1, planegrey2, point1, point2, point3, point4, point5';

%% Textures
texture_cell = cell(0);

texture_cell{end+1}.Attributes.name = 'background';
texture_cell{end}.Attributes.type = 'texture';
texture_cell{end}.Attributes.filename = 'assets\Ocean from horn.jpg';

scene_struct.scene.textures.texture = texture_cell;

%% Scattering
scatterer_cell = cell(0);

scatterer_cell{end+1}.Attributes.name = 'air_absorber';
scatterer_cell{end}.Attributes.type = 'nonabsorber';

scatterer_cell{end+1}.Attributes.name = 'scatterer1';
scatterer_cell{end}.Attributes.type = 'scatterer_exp';
scatterer_cell{end}.Attributes.emission = 'black';
scatterer_cell{end}.Attributes.colour = 'red';
scatterer_cell{end}.Attributes.emission_distance = 0.05;
scatterer_cell{end}.Attributes.absorption_distance = 0.05;
scatterer_cell{end}.Attributes.scattering_distance = 0.01;
scatterer_cell{end}.Attributes.order = 0.2;
scatterer_cell{end}.Attributes.scattering_angle = 1;

scatterer_cell{end+1}.Attributes.name = 'scatterer2';
scatterer_cell{end}.Attributes.type = 'scatterer_exp';
scatterer_cell{end}.Attributes.emission = 'black';
scatterer_cell{end}.Attributes.colour = 'red';
scatterer_cell{end}.Attributes.emission_distance = 0.05;
scatterer_cell{end}.Attributes.absorption_distance = 0.05;
scatterer_cell{end}.Attributes.scattering_distance = 0.01;
scatterer_cell{end}.Attributes.order = 0.5;
scatterer_cell{end}.Attributes.scattering_angle = 1;

scatterer_cell{end+1}.Attributes.name = 'scatterer3';
scatterer_cell{end}.Attributes.type = 'scatterer_exp';
scatterer_cell{end}.Attributes.emission = 'black';
scatterer_cell{end}.Attributes.colour = 'red';
scatterer_cell{end}.Attributes.emission_distance = 0.05;
scatterer_cell{end}.Attributes.absorption_distance = 0.05;
scatterer_cell{end}.Attributes.scattering_distance = 0.01;
scatterer_cell{end}.Attributes.order = 1;
scatterer_cell{end}.Attributes.scattering_angle = 1;

scatterer_cell{end+1}.Attributes.name = 'scatterer4';
scatterer_cell{end}.Attributes.type = 'scatterer_exp';
scatterer_cell{end}.Attributes.emission = 'black';
scatterer_cell{end}.Attributes.colour = 'red';
scatterer_cell{end}.Attributes.emission_distance = 0.05;
scatterer_cell{end}.Attributes.absorption_distance = 0.05;
scatterer_cell{end}.Attributes.scattering_distance = 0.01;
scatterer_cell{end}.Attributes.order = 2;
scatterer_cell{end}.Attributes.scattering_angle = 1;

scatterer_cell{end+1}.Attributes.name = 'scatterer5';
scatterer_cell{end}.Attributes.type = 'scatterer_exp';
scatterer_cell{end}.Attributes.emission = 'black';
scatterer_cell{end}.Attributes.colour = 'red';
scatterer_cell{end}.Attributes.emission_distance = 0.05;
scatterer_cell{end}.Attributes.absorption_distance = 0.05;
scatterer_cell{end}.Attributes.scattering_distance = 0.01;
scatterer_cell{end}.Attributes.order = 5;
scatterer_cell{end}.Attributes.scattering_angle = 1;

scene_struct.scene.scatterers.scatterer = scatterer_cell;

%% Materials
material_cell = cell(0);

material_cell{end+1}.Attributes.name = 'air';
material_cell{end}.Attributes.type = 'transparent';
material_cell{end}.Attributes.priority = 0;
material_cell{end}.Attributes.scattering_fn = 'air_absorber'; % can be index or name

material_cell{end+1}.Attributes.name = 'difgrey';
material_cell{end}.Attributes.type = 'diffuse';
material_cell{end}.Attributes.emission = 'black'; % can also be array
material_cell{end}.Attributes.colour = 'grey1'; % can also be array
material_cell{end}.Attributes.roughness = 1;

material_cell{end+1}.Attributes.name = 'scattering_mat1';
material_cell{end}.Attributes.type = 'reflective_refractive';
material_cell{end}.Attributes.emission = 'black'; % can also be array
material_cell{end}.Attributes.colour = 'white'; % can also be array
material_cell{end}.Attributes.ind = 1.5;
material_cell{end}.Attributes.priority = 10;
material_cell{end}.Attributes.scattering_fn = 'scatterer1';

material_cell{end+1}.Attributes.name = 'scattering_mat2';
material_cell{end}.Attributes.type = 'reflective_refractive';
material_cell{end}.Attributes.emission = 'black'; % can also be array
material_cell{end}.Attributes.colour = 'white'; % can also be array
material_cell{end}.Attributes.ind = 1.5;
material_cell{end}.Attributes.priority = 10;
material_cell{end}.Attributes.scattering_fn = 'scatterer2';

material_cell{end+1}.Attributes.name = 'scattering_mat3';
material_cell{end}.Attributes.type = 'reflective_refractive';
material_cell{end}.Attributes.emission = 'black'; % can also be array
material_cell{end}.Attributes.colour = 'white'; % can also be array
material_cell{end}.Attributes.ind = 1.5;
material_cell{end}.Attributes.priority = 10;
material_cell{end}.Attributes.scattering_fn = 'scatterer3';

material_cell{end+1}.Attributes.name = 'scattering_mat4';
material_cell{end}.Attributes.type = 'reflective_refractive';
material_cell{end}.Attributes.emission = 'black'; % can also be array
material_cell{end}.Attributes.colour = 'white'; % can also be array
material_cell{end}.Attributes.ind = 1.5;
material_cell{end}.Attributes.priority = 10;
material_cell{end}.Attributes.scattering_fn = 'scatterer4';

material_cell{end+1}.Attributes.name = 'scattering_mat5';
material_cell{end}.Attributes.type = 'reflective_refractive';
material_cell{end}.Attributes.emission = 'black'; % can also be array
material_cell{end}.Attributes.colour = 'white'; % can also be array
material_cell{end}.Attributes.ind = 1.5;
material_cell{end}.Attributes.priority = 10;
material_cell{end}.Attributes.scattering_fn = 'scatterer5';

scene_struct.scene.materials.material = material_cell;

%% Transform matrices

%% Meshes

%% Objects
angles = -30:15:30;

object_cell = cell(0);

object_cell{end+1}.Attributes.name = 'point1';
object_cell{end}.Attributes.type = 'sphere';
object_cell{end}.Attributes.material = 'scattering_mat1'; % can also be name
object_cell{end}.Attributes.transform_matrix = NaN; % if not empty, search for right matrix, if empty, create.
transformation_pre_cell = cell(0);
transformation_pre_cell{end+1}.Attributes.type = 'translate';
transformation_pre_cell{end}.Attributes.value = [2 * sind(angles(1)), 2 * cosd(angles(1)), 0];
transformation_pre_cell{end+1}.Attributes.type = 'uniformscale';
transformation_pre_cell{end}.Attributes.value = 0.2;
transformation_pre_cell{end+1}.Attributes.type = 'rotatezaxis';
transformation_pre_cell{end}.Attributes.value = pi;
object_cell{end}.transformations_pre.transformation_pre = transformation_pre_cell;

object_cell{end+1}.Attributes.name = 'point2';
object_cell{end}.Attributes.type = 'sphere';
object_cell{end}.Attributes.material = 'scattering_mat2'; % can also be name
object_cell{end}.Attributes.transform_matrix = NaN; % if not empty, search for right matrix, if empty, create.
transformation_pre_cell = cell(0);
transformation_pre_cell{end+1}.Attributes.type = 'translate';
transformation_pre_cell{end}.Attributes.value = [2 * sind(angles(2)), 2 * cosd(angles(2)), 0];
transformation_pre_cell{end+1}.Attributes.type = 'uniformscale';
transformation_pre_cell{end}.Attributes.value = 0.2;
transformation_pre_cell{end+1}.Attributes.type = 'rotatezaxis';
transformation_pre_cell{end}.Attributes.value = pi;
object_cell{end}.transformations_pre.transformation_pre = transformation_pre_cell;

object_cell{end+1}.Attributes.name = 'point3';
object_cell{end}.Attributes.type = 'sphere';
object_cell{end}.Attributes.material = 'scattering_mat3'; % can also be name
object_cell{end}.Attributes.transform_matrix = NaN; % if not empty, search for right matrix, if empty, create.
transformation_pre_cell = cell(0);
transformation_pre_cell{end+1}.Attributes.type = 'translate';
transformation_pre_cell{end}.Attributes.value = [2 * sind(angles(3)), 2 * cosd(angles(3)), 0];
transformation_pre_cell{end+1}.Attributes.type = 'uniformscale';
transformation_pre_cell{end}.Attributes.value = 0.2;
transformation_pre_cell{end+1}.Attributes.type = 'rotatezaxis';
transformation_pre_cell{end}.Attributes.value = pi;
object_cell{end}.transformations_pre.transformation_pre = transformation_pre_cell;

object_cell{end+1}.Attributes.name = 'point4';
object_cell{end}.Attributes.type = 'sphere';
object_cell{end}.Attributes.material = 'scattering_mat4'; % can also be name
object_cell{end}.Attributes.transform_matrix = NaN; % if not empty, search for right matrix, if empty, create.
transformation_pre_cell = cell(0);
transformation_pre_cell{end+1}.Attributes.type = 'translate';
transformation_pre_cell{end}.Attributes.value = [2 * sind(angles(4)), 2 * cosd(angles(4)), 0];
transformation_pre_cell{end+1}.Attributes.type = 'uniformscale';
transformation_pre_cell{end}.Attributes.value = 0.2;
transformation_pre_cell{end+1}.Attributes.type = 'rotatezaxis';
transformation_pre_cell{end}.Attributes.value = pi;
object_cell{end}.transformations_pre.transformation_pre = transformation_pre_cell;

object_cell{end+1}.Attributes.name = 'point5';
object_cell{end}.Attributes.type = 'sphere';
object_cell{end}.Attributes.material = 'scattering_mat5'; % can also be name
object_cell{end}.Attributes.transform_matrix = NaN; % if not empty, search for right matrix, if empty, create.
transformation_pre_cell = cell(0);
transformation_pre_cell{end+1}.Attributes.type = 'translate';
transformation_pre_cell{end}.Attributes.value = [2 * sind(angles(5)), 2 * cosd(angles(5)), 0];
transformation_pre_cell{end+1}.Attributes.type = 'uniformscale';
transformation_pre_cell{end}.Attributes.value = 0.2;
transformation_pre_cell{end+1}.Attributes.type = 'rotatezaxis';
transformation_pre_cell{end}.Attributes.value = pi;
object_cell{end}.transformations_pre.transformation_pre = transformation_pre_cell;

object_cell{end+1}.Attributes.name = 'planegrey1';
object_cell{end}.Attributes.type = 'triangle';
object_cell{end}.Attributes.material = 'difgrey'; % can also be name
object_cell{end}.Attributes.points = [-2, 4, -0.5; -2, 0, -0.5; 2, 0, -0.5];
object_cell{end}.Attributes.normals = NaN;
object_cell{end}.Attributes.texture_coordinates = NaN;
object_cell{end}.Attributes.transform_matrix = NaN; % if not empty, search for right matrix, if empty, create.
transformation_pre_cell = cell(0);
transformation_pre_cell{end+1}.Attributes.type = 'rotatezaxis';
transformation_pre_cell{end}.Attributes.value = pi;
object_cell{end}.transformations_pre.transformation_pre = transformation_pre_cell;

object_cell{end+1}.Attributes.name = 'planegrey2';
object_cell{end}.Attributes.type = 'triangle';
object_cell{end}.Attributes.material = 'difgrey'; % can also be name
object_cell{end}.Attributes.points = [-2, 4, -0.5; 2, 0, -0.5; 2, 4, -0.5];
object_cell{end}.Attributes.normals = NaN;
object_cell{end}.Attributes.texture_coordinates = NaN;
object_cell{end}.Attributes.transform_matrix = NaN; % if not empty, search for right matrix, if empty, create.
transformation_pre_cell = cell(0);
transformation_pre_cell{end+1}.Attributes.type = 'rotatezaxis';
transformation_pre_cell{end}.Attributes.value = pi;
object_cell{end}.transformations_pre.transformation_pre = transformation_pre_cell;

scene_struct.scene.objects.object = object_cell;

%% Directional lights

%% Skyboxes
skybox_cell = cell(0);
skybox_cell{end+1}.Attributes.name = 'sky';
skybox_cell{end}.Attributes.type = 'skybox_texture_sun';
skybox_cell{end}.Attributes.light_position = [0.6209296, 1-0.2292542];
skybox_cell{end}.Attributes.texture = 'background';
skybox_cell{end}.Attributes.light_colour = [0.996, 0.941, 0.918] * 1.586010 * 8;
skybox_cell{end}.Attributes.light_radius = 0.035;

scene_struct.scene.skyboxes.skybox = skybox_cell;

%% Image buffers
res_x = 1800;
res_y = 1200;
imgbuffer_cell = cell(0);

imgbuffer_cell{end+1}.Attributes.name = 'buffer1';
imgbuffer_cell{end}.Attributes.type = 'imgbuffer_opengl';
imgbuffer_cell{end}.Attributes.resx = res_x;
imgbuffer_cell{end}.Attributes.resy = res_y;

scene_struct.scene.imgbuffers.imgbuffer = imgbuffer_cell;

%% Camera
aspect_ratio = res_x/res_y;
fov(2) = 80 * pi/180;
fov(1) = fov(2)/aspect_ratio;

camera_cell = cell(0);
camera_cell{end+1}.Attributes.name = 'camera1';
camera_cell{end}.Attributes.type = 'cam_aperture';
camera_cell{end}.Attributes.transform_matrix = NaN;
camera_cell{end}.Attributes.filename = NaN; % if is empty, use next available with scene name
upvector = [0, 0, 1];
camera_cell{end}.Attributes.up = upvector/norm(upvector);
camera_cell{end}.Attributes.fov = fov;
camera_cell{end}.Attributes.subpix = [1, 1];
camera_cell{end}.Attributes.imgbuffer = 'buffer1'; % can be index or name
camera_cell{end}.Attributes.medium_list = 'air, air'; % can be index or name
camera_cell{end}.Attributes.skybox = 'sky'; % can be index or name
camera_cell{end}.Attributes.max_bounces = 32;
camera_cell{end}.Attributes.focal_length = 2;
camera_cell{end}.Attributes.aperture = 0.005;
camera_cell{end}.Attributes.time = [0, 1];
camera_cell{end}.Attributes.gammaind = 1;
camera_cell{end}.Attributes.rendermode = 'accumulation';
camera_cell{end}.Attributes.n_iter = inf;
transformation_pre_cell = cell(0);
transformation_pre_cell{end+1}.Attributes.type = 'translate';
transformation_pre_cell{end}.Attributes.value = [0, 0, 0];
transformation_pre_cell{end+1}.Attributes.type = 'rotatezaxis';
transformation_pre_cell{end}.Attributes.value = pi;
camera_cell{end}.transformations_pre.transformation_pre = transformation_pre_cell;

scene_struct.scene.cameras.camera = camera_cell;

%% Output
struct2xml(scene_struct, ['.', filesep, 'scenes', filesep, scene_name, '.xml']);