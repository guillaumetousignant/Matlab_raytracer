%% Scene
scene_name = 'airplane';
scene_struct = struct();
scene_struct.scene.Attributes.name = scene_name;
%scene_struct.scene.Attributes.primitive_list = 'planegrey1, planegrey2';
scene_struct.scene.Attributes.mesh_list = 'airplane';

%% Textures
texture_cell = cell(8, 1);

texture_cell{1}.Attributes.name = 'b737_800_2_T';
texture_cell{1}.Attributes.type = 'texture';
texture_cell{1}.Attributes.filename = '.\assets\A380\b737_800_2_T.tga';

texture_cell{2}.Attributes.name = 'a380_01';
texture_cell{2}.Attributes.type = 'texture';
texture_cell{2}.Attributes.filename = '.\assets\A380\a380_01.tga';

texture_cell{3}.Attributes.name = 'A380_mw';
texture_cell{3}.Attributes.type = 'texture';
texture_cell{3}.Attributes.filename = '.\assets\A380\A380_mw.tga';

texture_cell{4}.Attributes.name = 'A380_L';
texture_cell{4}.Attributes.type = 'texture';
texture_cell{4}.Attributes.filename = '.\assets\A380\A380_L.tga';

texture_cell{5}.Attributes.name = 'A380_R';
texture_cell{5}.Attributes.type = 'texture';
texture_cell{5}.Attributes.filename = '.\assets\A380\A380_R.tga';

texture_cell{6}.Attributes.name = 'A380_part1';
texture_cell{6}.Attributes.type = 'texture';
texture_cell{6}.Attributes.filename = '.\assets\A380\A380_part1.tga';

texture_cell{7}.Attributes.name = 'A380_part2';
texture_cell{7}.Attributes.type = 'texture';
texture_cell{7}.Attributes.filename = '.\assets\A380\A380_part2.tga';

texture_cell{8}.Attributes.name = 'A380_part3';
texture_cell{8}.Attributes.type = 'texture';
texture_cell{8}.Attributes.filename = '.\assets\A380\A380_part3.tga';

scene_struct.scene.textures.texture = texture_cell;

%% Scattering
scatterer_cell = cell(1, 1);

scatterer_cell{1}.Attributes.name = 'air_absorber';
scatterer_cell{1}.Attributes.type = 'nonabsorber';

scene_struct.scene.scatterers.scatterer = scatterer_cell;

%% Materials
material_cell = cell(14, 1);

material_cell{1}.Attributes.name = 'air';
material_cell{1}.Attributes.type = 'refractive';
material_cell{1}.Attributes.emission = 'black'; % can also be array
material_cell{1}.Attributes.colour = 'white'; % can also be array
material_cell{1}.Attributes.ind = 1.001;
material_cell{1}.Attributes.priority = 0;
material_cell{1}.Attributes.scattering_fn = 'air_absorber'; % can be index or name

material_cell{2}.Attributes.name = 'difgrey';
material_cell{2}.Attributes.type = 'diffuse';
material_cell{2}.Attributes.emission = 'black'; % can also be array
material_cell{2}.Attributes.colour = 'grey1'; % can also be array
material_cell{2}.Attributes.roughness = 1;

material_cell{3}.Attributes.name = 'b737_800_2_t';
material_cell{3}.Attributes.type = 'diffuse_tex';
material_cell{3}.Attributes.emission = 'black'; % can also be array
material_cell{3}.Attributes.texture = 'b737_800_2_T'; % can also be index
material_cell{3}.Attributes.roughness = 1;

material_cell{4}.Attributes.name = 'matte__ffffffff01';
material_cell{4}.Attributes.type = 'diffuse';
material_cell{4}.Attributes.emission = 'black'; % can also be array
material_cell{4}.Attributes.colour = [0.243137, 0.243137, 0.243137]; % can also be index
material_cell{4}.Attributes.roughness = 1;

material_cell{5}.Attributes.name = 'Material__57';
material_cell{5}.Attributes.type = 'diffuse';
material_cell{5}.Attributes.emission = 'black'; % can also be array
material_cell{5}.Attributes.colour = [1, 1, 1]; % can also be index
material_cell{5}.Attributes.roughness = 1;

material_cell{6}.Attributes.name = 'black';
material_cell{6}.Attributes.type = 'diffuse';
material_cell{6}.Attributes.emission = 'black'; % can also be array
material_cell{6}.Attributes.colour = [0.164706, 0.164706, 0.164706]; % can also be index
material_cell{6}.Attributes.roughness = 1;

material_cell{7}.Attributes.name = 'a380_01';
material_cell{7}.Attributes.type = 'diffuse_tex';
material_cell{7}.Attributes.emission = 'black'; % can also be array
material_cell{7}.Attributes.texture = 'a380_01'; % can also be index
material_cell{7}.Attributes.roughness = 1;

material_cell{8}.Attributes.name = 'a380_mw';
material_cell{8}.Attributes.type = 'diffuse_tex';
material_cell{8}.Attributes.emission = 'black'; % can also be array
material_cell{8}.Attributes.texture = 'A380_mw'; % can also be index
material_cell{8}.Attributes.roughness = 1;

material_cell{9}.Attributes.name = 'a380_l_';
material_cell{9}.Attributes.type = 'diffuse_tex';
material_cell{9}.Attributes.emission = 'black'; % can also be array
material_cell{9}.Attributes.texture = 'A380_L'; % can also be index
material_cell{9}.Attributes.roughness = 1;

material_cell{10}.Attributes.name = 'a380_r';
material_cell{10}.Attributes.type = 'diffuse_tex';
material_cell{10}.Attributes.emission = 'black'; % can also be array
material_cell{10}.Attributes.texture = 'A380_R'; % can also be index
material_cell{10}.Attributes.roughness = 1;

material_cell{11}.Attributes.name = 'a380_part1';
material_cell{11}.Attributes.type = 'diffuse_tex';
material_cell{11}.Attributes.emission = 'black'; % can also be array
material_cell{11}.Attributes.texture = 'A380_part1'; % can also be index
material_cell{11}.Attributes.roughness = 1;

material_cell{12}.Attributes.name = 'a380_part2';
material_cell{12}.Attributes.type = 'diffuse_tex';
material_cell{12}.Attributes.emission = 'black'; % can also be array
material_cell{12}.Attributes.texture = 'A380_part2'; % can also be index
material_cell{12}.Attributes.roughness = 1;

material_cell{13}.Attributes.name = 'a380_part3';
material_cell{13}.Attributes.type = 'diffuse_tex';
material_cell{13}.Attributes.emission = 'black'; % can also be array
material_cell{13}.Attributes.texture = 'A380_part3'; % can also be index
material_cell{13}.Attributes.roughness = 1;

material_cell{14}.Attributes.name = 'airplane_mat';
material_cell{14}.Attributes.type = 'aggregate';
material_cell{14}.Attributes.materials_names = 'b737_800_2_t; b737_800_2_t0; matte__ffffffff01; Material__57; b737_800_2_t1; matte__ffffffff010; Material__68; black; black0; a380_01; Material__46; black1; a380_010; a380_mw; a380_l_; a380_r; a380_part1; a380_part2; a380_part3; Material__35';
material_cell{14}.Attributes.materials_list = 'b737_800_2_t; b737_800_2_t; matte__ffffffff01; Material__57; b737_800_2_t; matte__ffffffff01; Material__57; black; black; a380_01; black; black; a380_01; a380_mw; a380_l_; a380_r; a380_part1; a380_part2; a380_part3; black'; % can also be array

scene_struct.scene.materials.material = material_cell;

%% Transform matrices

%% Meshes
mesh_geometry_cell = cell(1, 1);

mesh_geometry_cell{1}.Attributes.name = 'airplane_mesh';
mesh_geometry_cell{1}.Attributes.type = 'mesh_geometry';
mesh_geometry_cell{1}.Attributes.filename = '.\assets\A380\A380.obj';

scene_struct.scene.mesh_geometries.mesh_geometry = mesh_geometry_cell;

%% Objects
object_cell = cell(3, 1);

object_cell{1}.Attributes.name = 'planegrey1';
object_cell{1}.Attributes.type = 'triangle';
object_cell{1}.Attributes.material = 'difgrey'; % can also be name
object_cell{1}.Attributes.points = [-2, 4, -0.5; -2, 0, -0.5; 2, 0, -0.5];
object_cell{1}.Attributes.normals = NaN;
object_cell{1}.Attributes.texture_coordinates = NaN;
object_cell{1}.Attributes.transform_matrix = NaN; % if not empty, search for right matrix, if empty, create.

object_cell{2}.Attributes.name = 'planegrey2';
object_cell{2}.Attributes.type = 'triangle';
object_cell{2}.Attributes.material = 'difgrey'; % can also be name
object_cell{2}.Attributes.points = [-2, 4, -0.5; 2, 0, -0.5; 2, 4, -0.5];
object_cell{2}.Attributes.normals = NaN;
object_cell{2}.Attributes.texture_coordinates = NaN;
object_cell{2}.Attributes.transform_matrix = NaN; % if not empty, search for right matrix, if empty, create.

object_cell{3}.Attributes.name = 'airplane';
object_cell{3}.Attributes.type = 'mesh';
object_cell{3}.Attributes.mesh_geometry = 'airplane_mesh';
object_cell{3}.Attributes.material = 'airplane_mat'; % can also be name
object_cell{3}.Attributes.transform_matrix = NaN; % if not empty, search for right matrix, if empty, create.
transformation_pre_cell = cell(4, 1);
transformation_pre_cell{1}.Attributes.type = 'translate';
transformation_pre_cell{1}.Attributes.value = [0.2, 4, 0.25];
transformation_pre_cell{2}.Attributes.type = 'uniformscale';
transformation_pre_cell{2}.Attributes.value = 0.001;
transformation_pre_cell{3}.Attributes.type = 'rotatex';
transformation_pre_cell{3}.Attributes.value = 0;
transformation_pre_cell{4}.Attributes.type = 'rotatez';
transformation_pre_cell{4}.Attributes.value = pi + pi/8;
object_cell{3}.transformations_pre.transformation_pre = transformation_pre_cell;

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
skybox_cell{1}.Attributes.colour = [0.8040, 0.8825, 0.9765];
skybox_cell{1}.Attributes.lights = 'sun'; % can be array of indices, or cell array of names. Maybe should be another struct?

scene_struct.scene.skyboxes.skybox = skybox_cell;

%% Image buffers
res_x = 180;
res_y = 120;
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
camera_cell{1}.Attributes.skybox = 'day'; % can be index or name
camera_cell{1}.Attributes.max_bounces = 8;
camera_cell{1}.Attributes.gammaind = 1;
camera_cell{1}.Attributes.rendermode = 'accumulation';
camera_cell{1}.Attributes.n_iter = inf;

scene_struct.scene.cameras.camera = camera_cell;

%% Output
struct2xml(scene_struct, ['.', filesep, 'scenes', filesep, scene_name, '.xml']);