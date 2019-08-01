close all;
clear all;
clc;

%% Scene
scene_name = 'tie';
scene_struct.scene.Attributes.name = scene_name;
scene_struct.scene.Attributes.mesh_list = 'tie';

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

material_cell{end+1}.Attributes.name = 'coating';
material_cell{end}.Attributes.type = 'reflective';
material_cell{end}.Attributes.emission = 'black'; % can also be array
material_cell{end}.Attributes.colour = 'white'; % can also be array

material_cell{end+1}.Attributes.name = 'blackred';
material_cell{end}.Attributes.type = 'diffuse';
material_cell{end}.Attributes.emission = 'black'; % can also be array
material_cell{end}.Attributes.colour = [0.0471, 0, 0]; % can also be array
material_cell{end}.Attributes.roughness = 1;

material_cell{end+1}.Attributes.name = 'hullblue1';
material_cell{end}.Attributes.type = 'diffuse';
material_cell{end}.Attributes.emission = 'black'; % can also be array
material_cell{end}.Attributes.colour = [0.7176, 0.7804, 0.7922]; % can also be array
material_cell{end}.Attributes.roughness = 1;

material_cell{end+1}.Attributes.name = 'hullblue';
material_cell{end}.Attributes.type = 'fresnelmix';
material_cell{end}.Attributes.material_refracted = 'hullblue1'; % can also be array
material_cell{end}.Attributes.material_reflected = 'coating'; % can also be array
material_cell{end}.Attributes.ind = 1.5;

material_cell{end+1}.Attributes.name = 'graymat1';
material_cell{end}.Attributes.type = 'diffuse';
material_cell{end}.Attributes.emission = 'black'; % can also be array
material_cell{end}.Attributes.colour = [0.5725, 0.5725, 0.5725]; % can also be array
material_cell{end}.Attributes.roughness = 1;

material_cell{end+1}.Attributes.name = 'graymat';
material_cell{end}.Attributes.type = 'fresnelmix';
material_cell{end}.Attributes.material_refracted = 'graymat1'; % can also be array
material_cell{end}.Attributes.material_reflected = 'coating'; % can also be array
material_cell{end}.Attributes.ind = 1.5;

material_cell{end+1}.Attributes.name = 'midgraymat1';
material_cell{end}.Attributes.type = 'diffuse';
material_cell{end}.Attributes.emission = 'black'; % can also be array
material_cell{end}.Attributes.colour = [0.5412, 0.5412, 0.5412]; % can also be array
material_cell{end}.Attributes.roughness = 1;

material_cell{end+1}.Attributes.name = 'midgraymat';
material_cell{end}.Attributes.type = 'fresnelmix';
material_cell{end}.Attributes.material_refracted = 'midgraymat1'; % can also be array
material_cell{end}.Attributes.material_reflected = 'coating'; % can also be array
material_cell{end}.Attributes.ind = 1.5;

material_cell{end+1}.Attributes.name = 'rib_graymat1';
material_cell{end}.Attributes.type = 'diffuse';
material_cell{end}.Attributes.emission = 'black'; % can also be array
material_cell{end}.Attributes.colour = [0.3294, 0.3294, 0.3294]; % can also be array
material_cell{end}.Attributes.roughness = 1;

material_cell{end+1}.Attributes.name = 'rib_graymat';
material_cell{end}.Attributes.type = 'fresnelmix';
material_cell{end}.Attributes.material_refracted = 'rib_graymat1'; % can also be array
material_cell{end}.Attributes.material_reflected = 'coating'; % can also be array
material_cell{end}.Attributes.ind = 1.5;

material_cell{end+1}.Attributes.name = 'drk_graymat1';
material_cell{end}.Attributes.type = 'diffuse';
material_cell{end}.Attributes.emission = 'black'; % can also be array
material_cell{end}.Attributes.colour = [0.4745, 0.4745, 0.4745]; % can also be array
material_cell{end}.Attributes.roughness = 1;

material_cell{end+1}.Attributes.name = 'drk_graymat';
material_cell{end}.Attributes.type = 'fresnelmix';
material_cell{end}.Attributes.material_refracted = 'drk_graymat1'; % can also be array
material_cell{end}.Attributes.material_reflected = 'coating'; % can also be array
material_cell{end}.Attributes.ind = 1.5;

material_cell{end+1}.Attributes.name = 'panl_blk1';
material_cell{end}.Attributes.type = 'diffuse';
material_cell{end}.Attributes.emission = 'black'; % can also be array
material_cell{end}.Attributes.colour = [0.0078, 0.0078, 0.0078]; % can also be array
material_cell{end}.Attributes.roughness = 1;

material_cell{end+1}.Attributes.name = 'panl_blk';
material_cell{end}.Attributes.type = 'fresnelmix';
material_cell{end}.Attributes.material_refracted = 'panl_blk1'; % can also be array
material_cell{end}.Attributes.material_reflected = 'coating'; % can also be array
material_cell{end}.Attributes.ind = 1.5;

material_cell{end+1}.Attributes.name = 'englowred';
material_cell{end}.Attributes.type = 'diffuse';
material_cell{end}.Attributes.emission = [0.9882, 0, 0]; % can also be array
material_cell{end}.Attributes.colour = [0.9882, 0, 0]; % can also be array
material_cell{end}.Attributes.roughness = 0;

material_cell{end+1}.Attributes.name = 'lasered';
material_cell{end}.Attributes.type = 'diffuse';
material_cell{end}.Attributes.emission = [0.6784, 0.3647, 0.4000]; % can also be array
material_cell{end}.Attributes.colour = [0.6784, 0.3647, 0.4000]; % can also be array
material_cell{end}.Attributes.roughness = 0;

material_cell{end+1}.Attributes.name = 'tie_mats';
material_cell{end}.Attributes.type = 'aggregate';
material_cell{end}.Attributes.materials_list = 'blackred, hullblue, graymat, midgraymat, englowred, drk_graymat, rib_graymat, panl_blk, lasered';
material_cell{end}.Attributes.materials_names = 'blackred, hullblue, gray, mid_gray, englored, drk_gray, rib_gray, panl_blk, lasered';

scene_struct.scene.materials.material = material_cell;

%% Transform matrices

%% Meshes
mesh_geometry_cell = cell(0);

mesh_geometry_cell{end+1}.Attributes.name = 'tie_mesh';
mesh_geometry_cell{end}.Attributes.type = 'mesh_geometry';
mesh_geometry_cell{end}.Attributes.filename = 'assets\tie_fighter\TIE-fighter.obj';

scene_struct.scene.mesh_geometries.mesh_geometry = mesh_geometry_cell;

%% Objects
angles = -30:15:30;

object_cell = cell(0);

object_cell{end+1}.Attributes.name = 'tie';
object_cell{end}.Attributes.type = 'mesh';
object_cell{end}.Attributes.mesh_geometry = 'tie_mesh';
object_cell{end}.Attributes.material = 'tie_mats'; % can also be name
object_cell{end}.Attributes.transform_matrix = NaN; % if not empty, search for right matrix, if empty, create.
transformation_pre_cell = cell(0);
transformation_pre_cell{end+1}.Attributes.type = 'translate';
transformation_pre_cell{end}.Attributes.value = [0, 0, -0.3];
transformation_pre_cell{end+1}.Attributes.type = 'uniformscale';
transformation_pre_cell{end}.Attributes.value = 0.005;
transformation_pre_cell{end+1}.Attributes.type = 'rotatex';
transformation_pre_cell{end}.Attributes.value = -pi/2;
transformation_pre_cell{end+1}.Attributes.type = 'rotatez';
transformation_pre_cell{end}.Attributes.value = pi/16;
transformation_pre_cell{end+1}.Attributes.type = 'rotatezaxis';
transformation_pre_cell{end}.Attributes.value = 0;
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
camera_cell{end}.Attributes.max_bounces = 8;
camera_cell{end}.Attributes.focal_length = 3;
camera_cell{end}.Attributes.aperture = 0.005;
camera_cell{end}.Attributes.time = [0, 1];
camera_cell{end}.Attributes.gammaind = 1;
camera_cell{end}.Attributes.rendermode = 'accumulation';
camera_cell{end}.Attributes.n_iter = inf;
transformation_pre_cell = cell(0);
transformation_pre_cell{end+1}.Attributes.type = 'translate';
transformation_pre_cell{end}.Attributes.value = [0, -3, 0];
transformation_pre_cell{end+1}.Attributes.type = 'rotatezaxis';
transformation_pre_cell{end}.Attributes.value = 0;
camera_cell{end}.transformations_pre.transformation_pre = transformation_pre_cell;

scene_struct.scene.cameras.camera = camera_cell;

%% Output
struct2xml(scene_struct, ['.', filesep, 'scenes', filesep, scene_name, '.xml']);