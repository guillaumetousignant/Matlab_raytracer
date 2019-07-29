close all;
clear all;
clc;

%% Scene
scene_name = 'glace';
scene_struct.scene.Attributes.name = scene_name;
scene_struct.scene.Attributes.primitive_list = 'light1, light2, light3, light4, light5, light6, light7, light8';
scene_struct.scene.Attributes.mesh_list = 'glace';

%% Textures
texture_cell = cell(0);

texture_cell{end+1}.Attributes.name = 'background';
texture_cell{end}.Attributes.type = 'texture';
texture_cell{end}.Attributes.filename = 'assets\Ocean from horn.jpg';

texture_cell{end+1}.Attributes.name = 'peinture';
texture_cell{end}.Attributes.type = 'texture';
texture_cell{end}.Attributes.filename = 'assets\rink2.jpg';

scene_struct.scene.textures.texture = texture_cell;

%% Scattering
scatterer_cell = cell(0);

scatterer_cell{end+1}.Attributes.name = 'air_absorber';
scatterer_cell{end}.Attributes.type = 'nonabsorber';

scatterer_cell{end+1}.Attributes.name = 'glace_scatterer';
scatterer_cell{end}.Attributes.type = 'scatterer';
scatterer_cell{end}.Attributes.emission = 'black';
scatterer_cell{end}.Attributes.colour = 'white';
scatterer_cell{end}.Attributes.emission_distance = 1;
scatterer_cell{end}.Attributes.absorption_distance = 1;
scatterer_cell{end}.Attributes.scattering_distance = 0.5;

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

material_cell{end+1}.Attributes.name = 'diflight';
material_cell{end}.Attributes.type = 'diffuse';
material_cell{end}.Attributes.emission = [5, 5, 5]; % can also be array
material_cell{end}.Attributes.colour = 'white'; % can also be array
material_cell{end}.Attributes.roughness = 0;

material_cell{end+1}.Attributes.name = 'glace_mat1';
material_cell{end}.Attributes.type = 'reflective_refractive_fuzz';
material_cell{end}.Attributes.emission = 'black'; % can also be array
material_cell{end}.Attributes.colour = 'white'; % can also be array
material_cell{end}.Attributes.ind = 1.33;
material_cell{end}.Attributes.priority = 10;
material_cell{end}.Attributes.order = 1;
material_cell{end}.Attributes.diffusivity = 0.01;
material_cell{end}.Attributes.scattering_fn = 'glace_scatterer';

material_cell{end+1}.Attributes.name = 'coating';
material_cell{end}.Attributes.type = 'reflective';
material_cell{end}.Attributes.emission = 'black'; % can also be array
material_cell{end}.Attributes.colour = 'white'; % can also be array

material_cell{end+1}.Attributes.name = 'glace_mat';
material_cell{end}.Attributes.type = 'fresnelmix';
material_cell{end}.Attributes.material_refracted = 'glace_mat1'; % can also be array
material_cell{end}.Attributes.material_reflected = 'coating'; % can also be array
material_cell{end}.Attributes.ind = 1.33;

material_cell{end+1}.Attributes.name = 'peinture_mat';
material_cell{end}.Attributes.type = 'diffuse_tex';
material_cell{end}.Attributes.emission = 'black'; % can also be array
material_cell{end}.Attributes.texture = 'peinture'; % can also be array
material_cell{end}.Attributes.roughness = 1;

material_cell{end+1}.Attributes.name = 'glace_mats';
material_cell{end}.Attributes.type = 'aggregate';
material_cell{end}.Attributes.materials_list = 'glace_mat, peinture_mat, difgrey';
material_cell{end}.Attributes.materials_names = 'lambert2SG, lambert3SG, lambert4SG';


scene_struct.scene.materials.material = material_cell;

%% Transform matrices

%% Meshes
mesh_geometry_cell = cell(0);

mesh_geometry_cell{end+1}.Attributes.name = 'glace_mesh';
mesh_geometry_cell{end}.Attributes.type = 'mesh_geometry';
mesh_geometry_cell{end}.Attributes.filename = 'assets\Glace.obj';

scene_struct.scene.mesh_geometries.mesh_geometry = mesh_geometry_cell;

%% Objects
object_cell = cell(0);

object_cell{end+1}.Attributes.name = 'glace';
object_cell{end}.Attributes.type = 'mesh';
object_cell{end}.Attributes.mesh_geometry = 'glace_mesh';
object_cell{end}.Attributes.material = 'glace_mats'; % can also be name
object_cell{end}.Attributes.transform_matrix = NaN; % if not empty, search for right matrix, if empty, create.
transformation_pre_cell = cell(0);
transformation_pre_cell{end+1}.Attributes.type = 'translate';
transformation_pre_cell{end}.Attributes.value = [0, 0, -1];
transformation_pre_cell{end+1}.Attributes.type = 'uniformscale';
transformation_pre_cell{end}.Attributes.value = 0.1;
transformation_pre_cell{end+1}.Attributes.type = 'rotatex';
transformation_pre_cell{end}.Attributes.value = pi/2;
transformation_pre_cell{end+1}.Attributes.type = 'rotatez';
transformation_pre_cell{end}.Attributes.value = 0;
transformation_pre_cell{end+1}.Attributes.type = 'rotatezaxis';
transformation_pre_cell{end}.Attributes.value = 0;
object_cell{end}.transformations_pre.transformation_pre = transformation_pre_cell;

object_cell{end+1}.Attributes.name = 'light1';
object_cell{end}.Attributes.type = 'sphere';
object_cell{end}.Attributes.material = 'diflight'; % can also be name
object_cell{end}.Attributes.transform_matrix = NaN; % if not empty, search for right matrix, if empty, create.
transformation_pre_cell = cell(0);
transformation_pre_cell{end+1}.Attributes.type = 'translate';
transformation_pre_cell{end}.Attributes.value = [0.2776, 0.2460, -0.5];
transformation_pre_cell{end+1}.Attributes.type = 'uniformscale';
transformation_pre_cell{end}.Attributes.value = 0.1;
object_cell{end}.transformations_pre.transformation_pre = transformation_pre_cell;

object_cell{end+1}.Attributes.name = 'light2';
object_cell{end}.Attributes.type = 'sphere';
object_cell{end}.Attributes.material = 'diflight'; % can also be name
object_cell{end}.Attributes.transform_matrix = NaN; % if not empty, search for right matrix, if empty, create.
transformation_pre_cell = cell(0);
transformation_pre_cell{end+1}.Attributes.type = 'translate';
transformation_pre_cell{end}.Attributes.value = [0.2776, 0.7381, -0.5];
transformation_pre_cell{end+1}.Attributes.type = 'uniformscale';
transformation_pre_cell{end}.Attributes.value = 0.1;
object_cell{end}.transformations_pre.transformation_pre = transformation_pre_cell;

object_cell{end+1}.Attributes.name = 'light3';
object_cell{end}.Attributes.type = 'sphere';
object_cell{end}.Attributes.material = 'diflight'; % can also be name
object_cell{end}.Attributes.transform_matrix = NaN; % if not empty, search for right matrix, if empty, create.
transformation_pre_cell = cell(0);
transformation_pre_cell{end+1}.Attributes.type = 'translate';
transformation_pre_cell{end}.Attributes.value = [0.2776, -0.2460, -0.5];
transformation_pre_cell{end+1}.Attributes.type = 'uniformscale';
transformation_pre_cell{end}.Attributes.value = 0.1;
object_cell{end}.transformations_pre.transformation_pre = transformation_pre_cell;

object_cell{end+1}.Attributes.name = 'light4';
object_cell{end}.Attributes.type = 'sphere';
object_cell{end}.Attributes.material = 'diflight'; % can also be name
object_cell{end}.Attributes.transform_matrix = NaN; % if not empty, search for right matrix, if empty, create.
transformation_pre_cell = cell(0);
transformation_pre_cell{end+1}.Attributes.type = 'translate';
transformation_pre_cell{end}.Attributes.value = [0.2776, -0.7381, -0.5];
transformation_pre_cell{end+1}.Attributes.type = 'uniformscale';
transformation_pre_cell{end}.Attributes.value = 0.1;
object_cell{end}.transformations_pre.transformation_pre = transformation_pre_cell;

object_cell{end+1}.Attributes.name = 'light5';
object_cell{end}.Attributes.type = 'sphere';
object_cell{end}.Attributes.material = 'diflight'; % can also be name
object_cell{end}.Attributes.transform_matrix = NaN; % if not empty, search for right matrix, if empty, create.
transformation_pre_cell = cell(0);
transformation_pre_cell{end+1}.Attributes.type = 'translate';
transformation_pre_cell{end}.Attributes.value = [-0.2776, 0.2460, -0.5];
transformation_pre_cell{end+1}.Attributes.type = 'uniformscale';
transformation_pre_cell{end}.Attributes.value = 0.1;
object_cell{end}.transformations_pre.transformation_pre = transformation_pre_cell;

object_cell{end+1}.Attributes.name = 'light6';
object_cell{end}.Attributes.type = 'sphere';
object_cell{end}.Attributes.material = 'diflight'; % can also be name
object_cell{end}.Attributes.transform_matrix = NaN; % if not empty, search for right matrix, if empty, create.
transformation_pre_cell = cell(0);
transformation_pre_cell{end+1}.Attributes.type = 'translate';
transformation_pre_cell{end}.Attributes.value = [0.2776, 0.2460, -0.5];
transformation_pre_cell{end+1}.Attributes.type = 'uniformscale';
transformation_pre_cell{end}.Attributes.value = 0.1;
object_cell{end}.transformations_pre.transformation_pre = transformation_pre_cell;

object_cell{end+1}.Attributes.name = 'light7';
object_cell{end}.Attributes.type = 'sphere';
object_cell{end}.Attributes.material = 'diflight'; % can also be name
object_cell{end}.Attributes.transform_matrix = NaN; % if not empty, search for right matrix, if empty, create.
transformation_pre_cell = cell(0);
transformation_pre_cell{end+1}.Attributes.type = 'translate';
transformation_pre_cell{end}.Attributes.value = [-0.2776, -0.2460, -0.5];
transformation_pre_cell{end+1}.Attributes.type = 'uniformscale';
transformation_pre_cell{end}.Attributes.value = 0.1;
object_cell{end}.transformations_pre.transformation_pre = transformation_pre_cell;

object_cell{end+1}.Attributes.name = 'light8';
object_cell{end}.Attributes.type = 'sphere';
object_cell{end}.Attributes.material = 'diflight'; % can also be name
object_cell{end}.Attributes.transform_matrix = NaN; % if not empty, search for right matrix, if empty, create.
transformation_pre_cell = cell(0);
transformation_pre_cell{end+1}.Attributes.type = 'translate';
transformation_pre_cell{end}.Attributes.value = [-0.2776, -0.7381, -0.5];
transformation_pre_cell{end+1}.Attributes.type = 'uniformscale';
transformation_pre_cell{end}.Attributes.value = 0.1;
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
camera_cell{end}.Attributes.max_bounces = 16;
camera_cell{end}.Attributes.focal_length = 2;
camera_cell{end}.Attributes.aperture = 0.0;
camera_cell{end}.Attributes.gammaind = 1;
camera_cell{end}.Attributes.rendermode = 'accumulation';
camera_cell{end}.Attributes.n_iter = inf;
transformation_pre_cell = cell(0);
transformation_pre_cell{end+1}.Attributes.type = 'translate';
transformation_pre_cell{end}.Attributes.value = [0, -2, 0];
transformation_pre_cell{end+1}.Attributes.type = 'rotatezaxis';
transformation_pre_cell{end}.Attributes.value = 0;
camera_cell{end}.transformations_pre.transformation_pre = transformation_pre_cell;

scene_struct.scene.cameras.camera = camera_cell;

%% Output
struct2xml(scene_struct, ['.', filesep, 'scenes', filesep, scene_name, '.xml']);