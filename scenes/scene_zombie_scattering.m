%% Scene
scene_name = 'zombie scattering';
scene_struct = struct();
scene_struct.scene.Attributes.name = scene_name;
scene_struct.scene.Attributes.primitive_list = 'planegrey1, planegrey2';
scene_struct.scene.Attributes.mesh_list = 'zombie';

%% Textures
texture_cell = cell(0);

texture_cell{end+1}.Attributes.name = 'zombie_texture';
texture_cell{end}.Attributes.type = 'texture';
texture_cell{end}.Attributes.filename = '.\assets\Zombie beast_texture5.jpg';

texture_cell{end+1}.Attributes.name = 'beach_texture';
texture_cell{end}.Attributes.type = 'texture';
texture_cell{end}.Attributes.filename = '.\assets\Ocean from horn.jpg';

scene_struct.scene.textures.texture = texture_cell;

%% Scattering
scatterer_cell = cell(0);

scatterer_cell{end+1}.Attributes.name = 'air_absorber';
scatterer_cell{end}.Attributes.type = 'nonabsorber';

scatterer_cell{end+1}.Attributes.name = 'zombie_scatterer';
scatterer_cell{end}.Attributes.type = 'scatterer';
scatterer_cell{end}.Attributes.emission = 'black';
scatterer_cell{end}.Attributes.colour = 'green';
scatterer_cell{end}.Attributes.emission_distance = 0.5;
scatterer_cell{end}.Attributes.absorption_distance = 0.5;
scatterer_cell{end}.Attributes.scattering_distance = 0.05;

scene_struct.scene.scatterers.scatterer = scatterer_cell;

%% Materials
material_cell = cell(0);

material_cell{end+1}.Attributes.name = 'difgrey';
material_cell{end}.Attributes.type = 'diffuse';
material_cell{end}.Attributes.emission = 'black'; % can also be array
material_cell{end}.Attributes.colour = 'grey1'; % can also be array
material_cell{end}.Attributes.roughness = 1;

material_cell{end+1}.Attributes.name = 'air';
material_cell{end}.Attributes.type = 'refractive';
material_cell{end}.Attributes.emission = 'black'; % can also be array
material_cell{end}.Attributes.colour = 'white'; % can also be array
material_cell{end}.Attributes.ind = 1.001;
material_cell{end}.Attributes.priority = 0;
material_cell{end}.Attributes.scattering_fn = 'air_absorber'; % can be index or name

material_cell{end+1}.Attributes.name = 'zombiemat';
material_cell{end}.Attributes.type = 'reflective_refractive';
material_cell{end}.Attributes.emission = 'black'; % can also be array
material_cell{end}.Attributes.colour = 'white'; % can also be array
material_cell{end}.Attributes.ind = 1.5;
material_cell{end}.Attributes.priority = 10;
material_cell{end}.Attributes.scattering_fn = 'zombie_scatterer';

scene_struct.scene.materials.material = material_cell;

%% Transform matrices

%% Meshes
mesh_geometry_cell = cell(0);

mesh_geometry_cell{end+1}.Attributes.name = 'zombie_mesh';
mesh_geometry_cell{end}.Attributes.type = 'mesh_geometry';
mesh_geometry_cell{end}.Attributes.filename = 'assets\Zombie_Beast4_test.obj';

scene_struct.scene.mesh_geometries.mesh_geometry = mesh_geometry_cell;

%% Objects
object_cell = cell(0);

object_cell{end+1}.Attributes.name = 'planegrey1';
object_cell{end}.Attributes.type = 'triangle';
object_cell{end}.Attributes.material = 'difgrey'; % can also be name
object_cell{end}.Attributes.points = [-2, 2, -0.5; -2, -2, -0.5; 2, -2, -0.5];
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
object_cell{end}.Attributes.points = [-2, 2, -0.5; 2, -2, -0.5; 2, 2, -0.5];
object_cell{end}.Attributes.normals = NaN;
object_cell{end}.Attributes.texture_coordinates = NaN;
object_cell{end}.Attributes.transform_matrix = NaN; % if not empty, search for right matrix, if empty, create.
transformation_pre_cell = cell(0);
transformation_pre_cell{end+1}.Attributes.type = 'rotatezaxis';
transformation_pre_cell{end}.Attributes.value = pi;
object_cell{end}.transformations_pre.transformation_pre = transformation_pre_cell;

object_cell{end+1}.Attributes.name = 'zombie';
object_cell{end}.Attributes.type = 'mesh';
object_cell{end}.Attributes.mesh_geometry = 'zombie_mesh';
object_cell{end}.Attributes.material = 'zombiemat'; % can also be name
object_cell{end}.Attributes.transform_matrix = NaN; % if not empty, search for right matrix, if empty, create.
transformation_pre_cell = cell(0);
transformation_pre_cell{end+1}.Attributes.type = 'translate';
transformation_pre_cell{end}.Attributes.value = [0, 0, -0.53];
transformation_pre_cell{end+1}.Attributes.type = 'uniformscale';
transformation_pre_cell{end}.Attributes.value = 0.025;
transformation_pre_cell{end+1}.Attributes.type = 'rotatex';
transformation_pre_cell{end}.Attributes.value = pi/2;
transformation_pre_cell{end+1}.Attributes.type = 'rotatez';
transformation_pre_cell{end}.Attributes.value = -pi/16;
transformation_pre_cell{end+1}.Attributes.type = 'rotatezaxis';
transformation_pre_cell{end}.Attributes.value = pi;
object_cell{end}.transformations_pre.transformation_pre = transformation_pre_cell;

scene_struct.scene.objects.object = object_cell;

%% Directional lights

%% Skyboxes
skybox_cell = cell(0);

skybox_cell{end+1}.Attributes.name = 'beach';
skybox_cell{end}.Attributes.type = 'skybox_texture_sun';
skybox_cell{end}.Attributes.texture = 'beach_texture';
skybox_cell{end}.Attributes.light_position = [0.6209296, 1-0.2292542];
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
camera_cell{end}.Attributes.up = [0, 0, 1];
camera_cell{end}.Attributes.fov = fov;
camera_cell{end}.Attributes.subpix = [1, 1];
camera_cell{end}.Attributes.imgbuffer = 1; % can be index or name
camera_cell{end}.Attributes.medium_list = 'air, air'; % can be index array, or names with ;
camera_cell{end}.Attributes.skybox = 'beach'; % can be index or name
camera_cell{end}.Attributes.max_bounces = 32;
camera_cell{end}.Attributes.focal_length = NaN;
camera_cell{end}.Attributes.focus_position = [0.5, 0.5];
camera_cell{end}.Attributes.aperture = 0.005;
camera_cell{end}.Attributes.gammaind = 1;
camera_cell{end}.Attributes.rendermode = 'accumulation';
camera_cell{end}.Attributes.n_iter = inf;
transformation_pre_cell = cell(0);
transformation_pre_cell{end+1}.Attributes.type = 'translate';
transformation_pre_cell{end}.Attributes.value = [0, -2, 0];
transformation_pre_cell{end+1}.Attributes.type = 'rotatezaxis';
transformation_pre_cell{end}.Attributes.value = pi;
camera_cell{end}.transformations_pre.transformation_pre = transformation_pre_cell;

scene_struct.scene.cameras.camera = camera_cell;

%% Output
struct2xml(scene_struct, ['.', filesep, 'scenes', filesep, scene_name, '.xml']);