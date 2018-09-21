black = [0, 0, 0];
grey1 = [0.3, 0.3, 0.3];
blue = [0.1, 0.4, 0.9];
purple = [0.8, 0.1, 0.7];
difpurple = diffuse(black, purple);
difblue = diffuse(black, blue);
air = refractive(black, white, 1, 1, black, black, []);
refr1 = refractive(black, white, 0.9, 1.5, [0, 0, 0], [0, 0, 0], air);
triangle1 = triangle(difpurple, [0, 3, 0.8; -1.5, 4, -0.8; 1, 2, 0.5], []);
sphere1 = sphere(difblue, [1, 2, 0.5], 0.5);
sphererefr = sphere(refr1, [0.5, 2, 0.5], 0.5);

ascene = scene(sphererefr, sphere1);

res = [200, 300]; % y, x
aspect_ratio = res(2) / res(1);
fov(2) = 80 * pi /180;
fov(1) = fov(2)/aspect_ratio;
%subpix = [4, 4]; % was 32 32
subpix = [1, 1];
pixel_span = [fov(1)/res(1), fov(2)/res(2)];
background = [0.5, 0.5, 0.5];
background_light = [0.5, 0.5, 0.5];

camera_vec = [0, 1, 0];
image = imgbuffer(res(2), res(1));
camera = cam([0, 0, 0], camera_vec/norm(camera_vec), pixel_span, fov, background, background_light, subpix, image);

figure();
hold on

tot_subpix = camera.subpix(1) * camera.subpix(2);
        
pixel_span_y = camera.pixel_span(1);
pixel_span_x = camera.pixel_span(2);
res_y = camera.resolution(1);
res_x = camera.resolution(2);
subpix_y = camera.subpix(1);
subpix_x = camera.subpix(2);
origin = camera.position;
cam_direction_sph = camera.direction_sph;


j = 50;
i = 200;
col = [0, 0, 0];
pix_vec_sph = cam_direction_sph + [0, (j-res_y/2-0.5)*pixel_span_y, (i-res_x/2-0.5)*-pixel_span_x]; 
% switched the last 2 elements of the +[] vector, and made the last one negative. It works, don't know why

ray_vec_sph = pix_vec_sph;
% switched the last 2 elements of the +[] vector, and made the last one negative. It works, don't know why
aray = ray(origin, to_xyz(ray_vec_sph), [0, 0, 0], [1, 1, 1]);
aray.raycast(ascene, camera);
col = col + aray.colour;



load state.mat state
nbounces = length(state);

%plot3([triangle1.points(:, 1); triangle1.points(1, 1)], [triangle1.points(:, 2); triangle1.points(1, 2)], [triangle1.points(:, 3); triangle1.points(1, 3)], 'b');
%avg = [sum(triangle1.points(:, 1))/3, sum(triangle1.points(:, 2))/3, sum(triangle1.points(:, 3))/3];
%plot3([avg(1), avg(1)+triangle1.normalvec(1)], [avg(2), avg(2)+triangle1.normalvec(2)], [avg(3), avg(3)+triangle1.normalvec(3)], 'm');
%for i = 1:3
%    plot3([triangle1.points(i, 1); triangle1.points(i, 1) + triangle1.normals(i,1)], [triangle1.points(i, 2); triangle1.points(i, 2) + triangle1.normals(i,2)], [triangle1.points(i, 3); triangle1.points(i, 3) + triangle1.normals(i,3)], 'm');
%end

plot3(sphererefr.origin(1), sphererefr.origin(2), sphererefr.origin(3), 'ob');

for i = 1:nbounces-1
    plot3(state(i, 1).origin(1), state(i, 1).origin(2), state(i, 1).origin(3), 'or');
    plot3([state(i, 1).origin(1), state(i+1, 1).origin(1)], [state(i, 1).origin(2), state(i+1, 1).origin(2)], [state(i, 1).origin(3), state(i+1, 1).origin(3)], 'r');
end
plot3(state(nbounces, 1).origin(1), state(nbounces, 1).origin(2), state(nbounces, 1).origin(3), 'or');

for i = 1:nbounces
    plot3([state(i, 1).origin(1), state(i, 1).origin(1) + state(i, 1).direction(1)], [state(i, 1).origin(2), state(i, 1).origin(2) + state(i, 1).direction(2)], [state(i, 1).origin(3), state(i, 1).origin(3) + state(i, 1).direction(3)], 'g');
end

for i = 1:nbounces
    plot3([state(i, 1).origin(1), state(i, 1).origin(1) + state(i, 1).normal(1)], [state(i, 1).origin(2), state(i, 1).origin(2) + state(i, 1).normal(2)], [state(i, 1).origin(3), state(i, 1).origin(3) + state(i, 1).normal(3)], 'b');
end

