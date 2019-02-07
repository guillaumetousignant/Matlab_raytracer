%% Scene
scene_name = 'zombie';
scene_struct.scene.Attributes.name = scene_name;

%% Scattering
scatterer_cell = cell(1, 1);

scatterer_cell{1}.Attributes.name = 'air_absorber';
scatterer_cell{1}.Attributes.type = 'nonabsorber';

scene_struct.scene.scatterers.scatterer = scatterer_cell;

%% Materials
material_cell = cell(5, 1);

material_cell{1}.Attributes.name = 'difgrey';
material_cell{1}.Attributes.type = 'diffuse';
material_cell{1}.Attributes.emission = 'black'; % can also be array
material_cell{1}.Attributes.colour = 'grey1'; % can also be array
material_cell{1}.Attributes.roughness = 1;

material_cell{2}.Attributes.name = 'difgrey2';
material_cell{2}.Attributes.type = 'diffuse';
material_cell{2}.Attributes.emission = 'black'; % can also be array
material_cell{2}.Attributes.colour = 'grey2'; % can also be array
material_cell{2}.Attributes.roughness = 1;

material_cell{3}.Attributes.name = 'diflight';
material_cell{3}.Attributes.type = 'diffuse';
material_cell{3}.Attributes.emission = [8, 8, 8]; % can also be array
material_cell{3}.Attributes.colour = 'white'; % can also be array
material_cell{3}.Attributes.roughness = 0;

material_cell{4}.Attributes.name = 'air';
material_cell{4}.Attributes.type = 'refractive';
material_cell{4}.Attributes.emission = 'black'; % can also be array
material_cell{4}.Attributes.colour = 'white'; % can also be array
material_cell{4}.Attributes.ind = 1.001;
material_cell{4}.Attributes.priority = 0;
material_cell{4}.Attributes.scattering_fn = 'air_absorber'; % can be index or name

material_cell{5}.Attributes.name = 'zombiemat';
material_cell{5}.Attributes.type = 'diffuse_tex';
material_cell{5}.Attributes.emission = 'black'; % can also be array
material_cell{5}.Attributes.texture = '.\assets\Zombie beast_texture5.jpg';
material_cell{5}.Attributes.roughness = 1;

scene_struct.scene.materials.material = material_cell;

%% Transform matrices
mesh_geometry_cell = cell(1, 1);

mesh_geometry_cell{1}.Attributes.name = 'zombie_mesh';
mesh_geometry_cell{1}.Attributes.type = 'mesh_geometry';
mesh_geometry_cell{1}.Attributes.filename = '.\assets\Zombie_Beast4_test.obj';

scene_struct.scene.mesh_geometries.mesh_geometry = mesh_geometry_cell;

%% Objects
object_cell = cell(4, 1);

object_cell{1}.Attributes.name = 'planegrey1';
object_cell{1}.Attributes.type = 'triangle';
object_cell{1}.Attributes.material = 'difgrey'; % can also be name
object_cell{1}.Attributes.points = [-2, 4, -0.5; -2, -4, -0.5; 2, -4, -0.5];
object_cell{1}.Attributes.normals = NaN;
object_cell{1}.Attributes.texture_coordinates = NaN;
object_cell{1}.Attributes.transform_matrix = NaN; % if not empty, search for right matrix, if empty, create.
transformation_pre_cell = cell(1, 1);
transformation_pre_cell{1}.Attributes.type = 'rotatezaxis';
transformation_pre_cell{1}.Attributes.value = pi;
object_cell{1}.transformations_pre.transformation_pre = transformation_pre_cell;

object_cell{2}.Attributes.name = 'planegrey2';
object_cell{2}.Attributes.type = 'triangle';
object_cell{2}.Attributes.material = 'difgrey'; % can also be name
object_cell{2}.Attributes.points = [-2, 4, -0.5; 2, -4, -0.5; 2, 4, -0.5];
object_cell{2}.Attributes.normals = NaN;
object_cell{2}.Attributes.texture_coordinates = NaN;
object_cell{2}.Attributes.transform_matrix = NaN; % if not empty, search for right matrix, if empty, create.
transformation_pre_cell = cell(1, 1);
transformation_pre_cell{1}.Attributes.type = 'rotatezaxis';
transformation_pre_cell{1}.Attributes.value = pi;
object_cell{2}.transformations_pre.transformation_pre = transformation_pre_cell;

object_cell{3}.Attributes.name = 'light';
object_cell{3}.Attributes.type = 'sphere';
object_cell{3}.Attributes.material = 'diflight'; % can also be name
object_cell{3}.Attributes.transform_matrix = NaN; % if not empty, search for right matrix, if empty, create.
transformation_pre_cell = cell(3, 1);
transformation_pre_cell{1}.Attributes.type = 'translate';
transformation_pre_cell{1}.Attributes.value = [-0.3, 0.8, 0.2];
transformation_pre_cell{2}.Attributes.type = 'uniformscale';
transformation_pre_cell{2}.Attributes.value = 0.1;
transformation_pre_cell{3}.Attributes.type = 'rotatezaxis';
transformation_pre_cell{3}.Attributes.value = pi;
object_cell{3}.transformations_pre.transformation_pre = transformation_pre_cell;

object_cell{4}.Attributes.name = 'zombie';
object_cell{4}.Attributes.type = 'mesh';
object_cell{4}.Attributes.mesh_geometry = 'zombie_mesh';
object_cell{4}.Attributes.material = 'zombiemat'; % can also be name
object_cell{4}.Attributes.transform_matrix = NaN; % if not empty, search for right matrix, if empty, create.
transformation_pre_cell = cell(5, 1);
transformation_pre_cell{1}.Attributes.type = 'translate';
transformation_pre_cell{1}.Attributes.value = [0, 2, -0.53];
transformation_pre_cell{2}.Attributes.type = 'uniformscale';
transformation_pre_cell{2}.Attributes.value = 0.025;
transformation_pre_cell{3}.Attributes.type = 'rotatex';
transformation_pre_cell{3}.Attributes.value = pi/2;
transformation_pre_cell{4}.Attributes.type = 'rotatez';
transformation_pre_cell{4}.Attributes.value = -pi/16;
transformation_pre_cell{5}.Attributes.type = 'rotatezaxis';
transformation_pre_cell{5}.Attributes.value = pi;
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

skybox_cell{1}.Attributes.name = 'beach';
skybox_cell{1}.Attributes.type = 'skybox_texture_sun';
skybox_cell{1}.Attributes.texture = '.\assets\Ocean from horn.jpg';
skybox_cell{1}.Attributes.light_position = [0.6209296, 1-0.2292542];
skybox_cell{1}.Attributes.light_colour = [0.996, 0.941, 0.918] * 1.586010 * 8;
skybox_cell{1}.Attributes.light_radius = 0.035;

scene_struct.scene.skyboxes.skybox = skybox_cell;

%% Image buffers
res_x = 180;
res_y = 120;
imgbuffer_cell = cell(2, 1);

imgbuffer_cell{1}.Attributes.name = 'bufferR';
imgbuffer_cell{1}.Attributes.type = 'imgbuffer';
imgbuffer_cell{1}.Attributes.resx = res_x;
imgbuffer_cell{1}.Attributes.resy = res_y;

imgbuffer_cell{2}.Attributes.name = 'bufferL';
imgbuffer_cell{2}.Attributes.type = 'imgbuffer';
imgbuffer_cell{2}.Attributes.resx = res_x;
imgbuffer_cell{2}.Attributes.resy = res_y;

scene_struct.scene.imgbuffers.imgbuffer = imgbuffer_cell;

%% Camera
aspect_ratio = res_x/res_y;
fov(2) = 80 * pi/180;
fov(1) = fov(2)/aspect_ratio;

camera_cell = cell(1, 1);

camera_cell{1}.Attributes.name = 'camera1';
camera_cell{1}.Attributes.type = 'cam_3d_aperture';
camera_cell{1}.Attributes.transform_matrix = NaN;
camera_cell{1}.Attributes.filename = NaN; % if is empty, use next available with scene name
camera_cell{1}.Attributes.up = [0, 0, 1];
camera_cell{1}.Attributes.fov = fov;
camera_cell{1}.Attributes.subpix = [1, 1];
camera_cell{1}.Attributes.imgbuffer = 1; % can be index or name
camera_cell{1}.Attributes.imgbuffer_R = 2;
camera_cell{1}.Attributes.eye_dist = 0.065;
camera_cell{1}.Attributes.medium_list = 'air; air'; % can be index array, or names with ;
camera_cell{1}.Attributes.skybox = 1; % can be index or name
camera_cell{1}.Attributes.max_bounces = 8;
camera_cell{1}.Attributes.focal_length = NaN;
camera_cell{1}.Attributes.focus_position = [0.5, 0.5];
camera_cell{1}.Attributes.aperture = 0.025;
camera_cell{1}.Attributes.gammaind = 1;
camera_cell{1}.Attributes.rendermode = 'accumulation';
camera_cell{1}.Attributes.n_iter = inf;
transformation_pre_cell = cell(1, 1);
transformation_pre_cell{1}.Attributes.type = 'rotatezaxis';
transformation_pre_cell{1}.Attributes.value = pi;
camera_cell{1}.transformations_pre.transformation_pre = transformation_pre_cell;

scene_struct.scene.cameras.camera = camera_cell;

%% Output
struct2xml(scene_struct, ['.', filesep, 'scenes', filesep, scene_name, '.xml']);