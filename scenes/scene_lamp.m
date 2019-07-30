close all;
clear all;
clc;

%% Scene
scene_name = 'lamp';
scene_struct.scene.Attributes.name = scene_name;
scene_struct.scene.Attributes.primitive_list = 'planegrey1, planegrey2, sphereair';
scene_struct.scene.Attributes.mesh_list = 'lamp';

%% Textures

%% Scattering
scatterer_cell = cell(0);

scatterer_cell{end+1}.Attributes.name = 'air_absorber';
scatterer_cell{end}.Attributes.type = 'nonabsorber';

scatterer_cell{end+1}.Attributes.name = 'air_scatterer';
scatterer_cell{end}.Attributes.type = 'scatterer';
scatterer_cell{end}.Attributes.emission = 'black';
scatterer_cell{end}.Attributes.colour = 'white';
scatterer_cell{end}.Attributes.emission_distance = 10000;
scatterer_cell{end}.Attributes.absorption_distance = 10000;
scatterer_cell{end}.Attributes.scattering_distance = 2;

scene_struct.scene.scatterers.scatterer = scatterer_cell;

%% Materials
material_cell = cell(0);

material_cell{end+1}.Attributes.name = 'air';
material_cell{end}.Attributes.type = 'transparent';
material_cell{end}.Attributes.priority = 0;
material_cell{end}.Attributes.scattering_fn = 'air_absorber'; % can be index or name

material_cell{end+1}.Attributes.name = 'air2';
material_cell{end}.Attributes.type = 'transparent';
material_cell{end}.Attributes.priority = 2;
material_cell{end}.Attributes.scattering_fn = 'air_scatterer'; % can be index or name

material_cell{end+1}.Attributes.name = 'difgrey';
material_cell{end}.Attributes.type = 'diffuse';
material_cell{end}.Attributes.emission = 'black'; % can also be array
material_cell{end}.Attributes.colour = 'grey1'; % can also be array
material_cell{end}.Attributes.roughness = 1;

material_cell{end+1}.Attributes.name = 'metal1';
material_cell{end}.Attributes.type = 'reflective_fuzz';
material_cell{end}.Attributes.emission = 'black'; % can also be array
material_cell{end}.Attributes.colour = 'grey1'; % can also be array
material_cell{end}.Attributes.order = 5;
material_cell{end}.Attributes.diffusivity = 1;

material_cell{end+1}.Attributes.name = 'coating';
material_cell{end}.Attributes.type = 'reflective';
material_cell{end}.Attributes.emission = 'black'; % can also be array
material_cell{end}.Attributes.colour = 'white'; % can also be array

material_cell{end+1}.Attributes.name = 'metal';
material_cell{end}.Attributes.type = 'fresnelmix';
material_cell{end}.Attributes.material_refracted = 'metal'; % can also be array
material_cell{end}.Attributes.material_reflected = 'coating'; % can also be array
material_cell{end}.Attributes.ind = 1.5;

material_cell{end+1}.Attributes.name = 'diflight';
material_cell{end}.Attributes.type = 'diffuse';
material_cell{end}.Attributes.emission = [256, 256, 256]; % can also be array
material_cell{end}.Attributes.colour = 'white'; % can also be array
material_cell{end}.Attributes.roughness = 0;

material_cell{end+1}.Attributes.name = 'lamp_mats';
material_cell{end}.Attributes.type = 'aggregate';
material_cell{end}.Attributes.materials_list = 'diflight, metal';
material_cell{end}.Attributes.materials_names = 'initialShadingGroup, phong1SG';


scene_struct.scene.materials.material = material_cell;

%% Transform matrices

%% Meshes
mesh_geometry_cell = cell(0);

mesh_geometry_cell{end+1}.Attributes.name = 'lamp_mesh';
mesh_geometry_cell{end}.Attributes.type = 'mesh_geometry';
mesh_geometry_cell{end}.Attributes.filename = 'assets\lamp.obj';

scene_struct.scene.mesh_geometries.mesh_geometry = mesh_geometry_cell;

%% Objects
object_cell = cell(0);

object_cell{end+1}.Attributes.name = 'lamp';
object_cell{end}.Attributes.type = 'mesh';
object_cell{end}.Attributes.mesh_geometry = 'lamp_mesh';
object_cell{end}.Attributes.material = 'lamp_mats'; % can also be name
object_cell{end}.Attributes.transform_matrix = NaN; % if not empty, search for right matrix, if empty, create.
transformation_pre_cell = cell(0);
transformation_pre_cell{end+1}.Attributes.type = 'translate';
transformation_pre_cell{end}.Attributes.value = [0.5, 0, -0.5];
transformation_pre_cell{end+1}.Attributes.type = 'uniformscale';
transformation_pre_cell{end}.Attributes.value = 0.025;
transformation_pre_cell{end+1}.Attributes.type = 'rotatex';
transformation_pre_cell{end}.Attributes.value = pi/2;
transformation_pre_cell{end+1}.Attributes.type = 'rotatez';
transformation_pre_cell{end}.Attributes.value = -pi/2.5;
transformation_pre_cell{end+1}.Attributes.type = 'rotatezaxis';
transformation_pre_cell{end}.Attributes.value = 0;
object_cell{end}.transformations_pre.transformation_pre = transformation_pre_cell;

object_cell{end+1}.Attributes.name = 'planegrey1';
object_cell{end}.Attributes.type = 'triangle';
object_cell{end}.Attributes.material = 'difgrey'; % can also be name
object_cell{end}.Attributes.points = [-2, 2, -0.5; -2, -6, -0.5; 2, -6, -0.5];
object_cell{end}.Attributes.normals = NaN;
object_cell{end}.Attributes.texture_coordinates = NaN;
object_cell{end}.Attributes.transform_matrix = NaN; % if not empty, search for right matrix, if empty, create.
transformation_pre_cell = cell(0);
transformation_pre_cell{end+1}.Attributes.type = 'rotatezaxis';
transformation_pre_cell{end}.Attributes.value = 0;
object_cell{end}.transformations_pre.transformation_pre = transformation_pre_cell;

object_cell{end+1}.Attributes.name = 'planegrey2';
object_cell{end}.Attributes.type = 'triangle';
object_cell{end}.Attributes.material = 'difgrey'; % can also be name
object_cell{end}.Attributes.points = [-2, 2, -0.5; 2, -6, -0.5; 2, 2, -0.5];
object_cell{end}.Attributes.normals = NaN;
object_cell{end}.Attributes.texture_coordinates = NaN;
object_cell{end}.Attributes.transform_matrix = NaN; % if not empty, search for right matrix, if empty, create.
transformation_pre_cell = cell(0);
transformation_pre_cell{end+1}.Attributes.type = 'rotatezaxis';
transformation_pre_cell{end}.Attributes.value = 0;
object_cell{end}.transformations_pre.transformation_pre = transformation_pre_cell;

object_cell{end+1}.Attributes.name = 'sphereair';
object_cell{end}.Attributes.type = 'sphere';
object_cell{end}.Attributes.material = 'air2'; % can also be name
object_cell{end}.Attributes.transform_matrix = NaN; % if not empty, search for right matrix, if empty, create.
transformation_pre_cell = cell(0);
transformation_pre_cell{end+1}.Attributes.type = 'translate';
transformation_pre_cell{end}.Attributes.value = [0, 0, 0];
transformation_pre_cell{end+1}.Attributes.type = 'uniformscale';
transformation_pre_cell{end}.Attributes.value = 5;
object_cell{end}.transformations_pre.transformation_pre = transformation_pre_cell;

scene_struct.scene.objects.object = object_cell;

%% Directional lights

directional_light_cell = cell(0);

directional_light_cell{end+1}.Attributes.name = 'moon';
directional_light_cell{end}.Attributes.colour = [0.9, 0.9, 1] * 5;
directional_light_cell{end}.Attributes.transform_matrix = NaN;
directional_light_cell{end}.Attributes.type = 'directional_light';
transformation_pre_cell = cell(0);
transformation_pre_cell{end+1}.Attributes.type = 'uniformscale';
transformation_pre_cell{end}.Attributes.value = 0.92;
transformation_pre_cell{end+1}.Attributes.type = 'rotatez';
transformation_pre_cell{end}.Attributes.value = -pi/4 + pi;
transformation_pre_cell{end+1}.Attributes.type = 'rotatex';
transformation_pre_cell{end}.Attributes.value = pi/4;
directional_light_cell{end}.transformations_pre.transformation_pre = transformation_pre_cell;

scene_struct.scene.directional_lights.directional_light = directional_light_cell;

%% Skyboxes
skybox_cell = cell(0);

skybox_cell{end+1}.Attributes.name = 'night';
skybox_cell{end}.Attributes.type = 'skybox_flat_sun';
skybox_cell{end}.Attributes.colour = [0.05, 0.05, 0.05];
skybox_cell{end}.Attributes.lights = 'moon'; % can be array of indices, or cell array of names. Maybe should be another struct?

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
camera_cell{end}.Attributes.skybox = 'night'; % can be index or name
camera_cell{end}.Attributes.max_bounces = 32;
camera_cell{end}.Attributes.focal_length = 2;
camera_cell{end}.Attributes.aperture = 0.01;
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