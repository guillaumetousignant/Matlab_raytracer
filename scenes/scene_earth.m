close all;
clear all;
clc;

%% Scene
scene_name = 'earth';
scene_struct.scene.Attributes.name = scene_name;
scene_struct.scene.Attributes.primitive_list = 'ground, earth';

%% Textures
texture_cell = cell(0);
texture_cell{end+1}.Attributes.name = 'earth_texture';
texture_cell{end}.Attributes.type = 'texture';
texture_cell{end}.Attributes.filename = '.\assets\earth_2048.png';

scene_struct.scene.textures.texture = texture_cell;

%% Scattering
scatterer_cell = cell(0);
scatterer_cell{end+1}.Attributes.name = 'air_absorber';
scatterer_cell{end}.Attributes.type = 'nonabsorber';

scene_struct.scene.scatterers.scatterer = scatterer_cell;

%% Materials
material_cell = cell(0);
material_cell{end+1}.Attributes.name = 'air';
material_cell{end}.Attributes.type = 'transparent';
material_cell{end}.Attributes.priority = 0;
material_cell{end}.Attributes.scattering_fn = 'air_absorber'; % can be index or name

material_cell{end+1}.Attributes.name = 'difgreen';
material_cell{end}.Attributes.type = 'diffuse';
material_cell{end}.Attributes.emission = 'black'; % can also be array
material_cell{end}.Attributes.colour = 'green'; % can also be array
material_cell{end}.Attributes.roughness = 1;

material_cell{end+1}.Attributes.name = 'earthmat';
material_cell{end}.Attributes.type = 'diffuse_tex';
material_cell{end}.Attributes.emission = 'black'; % can also be array
material_cell{end}.Attributes.texture = 'earth_texture';
material_cell{end}.Attributes.roughness = 1;    

scene_struct.scene.materials.material = material_cell;

%% Transform matrices

%% Meshes

%% Objects
object_cell = cell(0);
object_cell{end+1}.Attributes.name = 'ground';
object_cell{end}.Attributes.type = 'sphere';
object_cell{end}.Attributes.material = 'difgreen'; % can also be name
object_cell{end}.Attributes.transform_matrix = NaN; % if not empty, search for right matrix, if empty, create.
transformation_pre_cell = cell(0);
transformation_pre_cell{end+1}.Attributes.type = 'translate';
transformation_pre_cell{end}.Attributes.value = [0, 0, -101];
transformation_pre_cell{end+1}.Attributes.type = 'uniformscale';
transformation_pre_cell{end}.Attributes.value = 100;
object_cell{end}.transformations_pre.transformation_pre = transformation_pre_cell;

object_cell{end+1}.Attributes.name = 'earth';
object_cell{end}.Attributes.type = 'sphere_motionblur';
object_cell{end}.Attributes.material = 'earthmat'; % can also be name
object_cell{end}.Attributes.transform_matrix = NaN; % if not empty, search for right matrix, if empty, create.
transformation_pre_cell = cell(0);
transformation_pre_cell{end+1}.Attributes.type = 'translate';
transformation_pre_cell{end}.Attributes.value = [0, 2, 0];
transformation_pre_cell{end+1}.Attributes.type = 'uniformscale';
transformation_pre_cell{end}.Attributes.value = 1;
object_cell{end}.transformations_pre.transformation_pre = transformation_pre_cell;
transformation_post_cell = cell(0);
transformation_post_cell{end+1}.Attributes.type = 'rotatez';
transformation_post_cell{end}.Attributes.value = pi/4;
object_cell{end}.transformations_post.transformation_post = transformation_post_cell;

scene_struct.scene.objects.object = object_cell;

%% Directional lights
directional_light_cell = cell(0);
directional_light_cell{end+1}.Attributes.name = 'sun';
directional_light_cell{end}.Attributes.colour = [2.5, 2.5, 2] * 2;
directional_light_cell{end}.Attributes.transform_matrix = NaN;
directional_light_cell{end}.Attributes.type = 'directional_light';
transformation_pre_cell = cell(0);
transformation_pre_cell{end+1}.Attributes.type = 'uniformscale';
transformation_pre_cell{end}.Attributes.value = 0.95;
transformation_pre_cell{end+1}.Attributes.type = 'rotatez';
transformation_pre_cell{end}.Attributes.value = -pi/4;
transformation_pre_cell{end+1}.Attributes.type = 'rotatex';
transformation_pre_cell{end}.Attributes.value = -3 * pi/8;
directional_light_cell{end}.transformations_pre.transformation_pre = transformation_pre_cell;

scene_struct.scene.directional_lights.directional_light = directional_light_cell;

%% Skyboxes
skybox_cell = cell(0);
skybox_cell{end+1}.Attributes.name = 'sky';
skybox_cell{end}.Attributes.type = 'skybox_flat_sun';
skybox_cell{end}.Attributes.colour = [0.75, 0.85, 1];
skybox_cell{end}.Attributes.lights = 'sun'; % can be array of indices, or cell array of names. Maybe should be another struct?

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
camera_cell{end}.Attributes.type = 'cam_motionblur';
camera_cell{end}.Attributes.transform_matrix = NaN;
camera_cell{end}.Attributes.filename = NaN; % if is empty, use next available with scene name
upvector = [0, 0, 1];
camera_cell{end}.Attributes.up = upvector/norm(upvector);
camera_cell{end}.Attributes.fov = fov;
camera_cell{end}.Attributes.subpix = [1, 1];
camera_cell{end}.Attributes.imgbuffer = 1; % can be index or name
camera_cell{end}.Attributes.medium_list = 'air, air'; % can be index or name
camera_cell{end}.Attributes.skybox = 'sky'; % can be index or name
camera_cell{end}.Attributes.max_bounces = 8;
camera_cell{end}.Attributes.focal_length = 4;
camera_cell{end}.Attributes.aperture = 0.05;
camera_cell{end}.Attributes.gammaind = 1;
camera_cell{end}.Attributes.rendermode = 'accumulation';
camera_cell{end}.Attributes.n_iter = inf;
camera_cell{end}.Attributes.time = [0, 1];
transformation_pre_cell = cell(0);
transformation_pre_cell{end+1}.Attributes.type = 'translate';
transformation_pre_cell{end}.Attributes.value = [0, -2, 0];
camera_cell{end}.transformations_pre.transformation_pre = transformation_pre_cell;

scene_struct.scene.cameras.camera = camera_cell;

%% Output
struct2xml(scene_struct, ['.', filesep, 'scenes', filesep, scene_name, '.xml']);