
% So images are always the same. Comment to merge rendered images later.
%RandStream.setDefaultStream(RandStream('mt19937ar','seed',19950420));

%load scene.mat ascene
%load camera.mat camera

%% Render

render_mode = 'motion';

figure();

switch lower(render_mode)
    case 'normal'
        % Normal render

        tic
        camera.raytrace(ascene);
        toc
        imshow(camera.image.img);
        imwrite16(camera.image.img, '.\images\output.png');
    
    case 'accumulation'
        % Accumulation render

        accum = imgbuffer(camera.image.sizex, camera.image.sizey);
        i = 0;
        while 1 
            i = i + 1;
            tic
            camera.raytrace(ascene);
            fprintf('\nIteration %i done.\n', i);
            toc

            accum.update(camera.image.img);
            imshow(accum.img);
            drawnow;
            
            imwrite16(accum.img, '.\images\output.png');
        end

    case 'motion'
        % Motion render

        %camera.transformation.rotatez(-pi/30);

        for i = 1:61

            thetastep = pi/30;
            theta = (i - 1) * thetastep;

            %pos = [2 * sin(theta), -2 * cos(theta), 0];
            %camera.transformation.rotatez(thetastep);
            %camera.transformation.translate(pos - camera.origin);
            %camera.update;

            earth.transformation.rotatez(thetastep);
            earth.update;
            
            disp(earth.direction_sph);
            disp(earth.direction_sphlast);
            
%             cube.transformation.rotatez(thetastep);
%             cube.update;
            

            %cube.transformation.rotatex(pi/30);
            %cube.update;
            %ascene.buildacc;
            
            %glass_fuzz.diffusivity = sin((i - 1) * pi/60)^8;

            %goomat.scattering.emission_vol = -log(turquoise)/dist(i);

            tic
            camera.raytrace(ascene);
            imshow(camera.image.img);
            imwrite16(camera.image.img, ['.\images\move\earth_mb\earth_mb', num2str(i, '%2.2u'), '.png']);
            drawnow

            fprintf('\nImage %i done.\n', i);
            toc
        end
        fprintf('\nAll done.\n');
end


%% TO IMPLEMENT
%
% - Chromatic aberration.
%           % Maybe refraction angle could be relative to ray color? Problem: doesn't work with reverse path tracing.
% - Automatic aperture: trace a ray in the middle, use t as focal length.
% - Scene should maybe just have meshes and split them when building the acc structure.
% - Pre-multiply the rotation and translation matrices, so it has only one matrix multiply to do.
% - Shear.
% - Animation.
% - Normal maps.
%           % Have two channels, u and v, for disruption to both axes. Should be in object space, because u and v
%           % are normally relative to ray direction. This doesn't work with how motion blur is done currently.
%           % Could probably work, as u and v when getitng coord are always the same, relative to v1v2 and v1v2.
% - Maybe, for motion blur, have two transformation matrices, and switch them on update?
%           % Sounds slower, but would fix normal mapping and motion blur, and sphere texture lookup with motion blur.
% - Have nothing on the rendering side access transform matrices, which won't be on the gpu. 
%           % This includes shphere texture lookup and possible normal map solution.
% - Add refractive portal.
%
%% KNOWN ISSUES
%
% - Weird black circle when a refractive object meets other objects. Possibly because of epsilon on normal, pushes the ray inside the other object.
% - Refraction sometimes gives black result when max number of bounces
% - What to do in refraction when set direction to 0 0 0? Put mask to 0, 0, 0 so stops bouncing?
% - No experimentation with triangle face side, aka when is the normal negative? Useful with refractive, to find out in or out.
% - Is_in is a bad solution to the getting out of a refractive medium problem.
%           % Maybe don't refract when coming out of medium if isn't is_in?
% - Transformed normals should be scaled outside of the transformmatrix class.
% - In metal shader (and all fuzz shaders), reject normals that face away from the ray.
% - In grid structure, gridcells are in a cell array. Should be an array of handles.
% - Make the dirlight take an angle as an input, and set its dot property itself.
% - In reality there is always some light reflected inside when leaving a refractive material. Right now is al or nothing.
% - Maybe intersect code should give normal? 
% - Due to the way spheres handle texture "rotation", they can't have motion blur on rotation. Should maybe have an orientation vector.
% - Scene should have list of meshes, not uber-list of triangles.
% - New issue with light-emitting absorbers, easy to see in goo06, where near the ground there's a bright spot.
% - Sphere texture lookup doesn't work with motion blur.
% - Have spheres have a rotation angle instead oh a transformation matrix.
%           % Will help avoid getting transform matrix, and work with motion blur.
% - There seems to be an issue with portals, not sure if about transformation matrix. Maybe should translate to portal?
% - Spheres with textures are slower, due to the uv calculations. Montionblur versions are worse, because of slerp.
%           % Maybe find a better system than offset.
%
%% DONE
%
% - Triangle texture coordinates interpolation is wrong, possibly affects normal interpolation. 
%           % Now uses barycentric cordinates, not dist. Possibly needs more optimisation, and reuse of u and v.
% - Also, a bunch of coordinates are extrapolated to 0 I think, why would that be? 
%           % That was the ground, with no tex coord.
% - To_sph is maybe wrong, in any case tranformation is wrong, easy to see when mapping a texture to a sphere. 
%           % Replaced atan(y/x) by atan2(y,x).
% - Not everything is using transformation matrices, and not properly.
%           % Now most, only dir light left and some.
% - All the fuzz doesn't work, probably about the random normal generation, either use a cone and no normal distribution, or something else.
%           % Was somehow linked to normal law use and clamping values. Now using constant distribution.
% - Can't rotate or transform textures on spheres. 
%           % Rotates normal with transform matrix before giving uv.
% - Acceleration structure is done, a bit slower on simple scenes.
%           % Get faster.
% - Plane shape & box.
%           % Both implemented, don't have all functions and can't be put in acceleration structures.
% - Obj importer doesn't work when normals are present but not uv, and doesn't work with non-triangles.
%           % Now skips missing data, and triangulates everything. 
% - Skybox, texture or simulated.
%           % Texture skybox, texture with sun, flat color with sun(s) created.
% - Adaptable materials.
%           % Diffuse now have roughness, goes from perf diffuse to lambert. Metal has cone angle and distribution.
% - Bunch materials together, ex: replace metal_coated by fresnel mix material that takes two materials and an input, and random mix of two.
%           % Two new materials: fresnel_mix and random_mix, replacing metal_coated and such.
% - Scattering shaders. Have the scatter() function called before the bounce function. 
%           % Now calls the medium's scattering function before the bounce function, works properly.
% - Weird halo on all refractive shaders.
%           % Was due to wrong refraction indice being given to the outgoing ray, neglecting total internal reflection.
% - In refractive non-scattering shader, the absorbed light should follow an exponential curve, not linear.
%           % Is now: exp(-m_absorptionCoefficient * distance);
% - Dirlight (and possibly sphere) scaling doesn't work, test rotatingthem. 
%           % The radius(or intensity) is now norm(transformation(1:3, 1:3))
% - Issue when rotating camera, only covers half the hemisphere. 
%           % Was related to aperture ray generation, now works in xyz. Other effect: slightly faster.
% - Depth of field.
%           % Implemented via aperture simulation. 
% - Motion blur.
%           % Implemented via motion blur capable primitives, rays and cameras. For now tested only on moving spheres.
% - Motion blur should interpolate normals. This means that the normal and normaluv functions should have time as au input somehow.
%           % Ray is fed to the normal and normaluv function. Probably a bit slower in general. Should be removed if no motion blur.
% - Weird issue when rotating camera, one frame will be blurred.
%           % When passes pi, will go to -pi. Those points are neighbors, but will interpolate blindy between them. Now interpolates on xyz coordinates.
% - There is an issue when (for ex) scaling a cube to be very big, after some point it will have a max size for some reason.
%           % Wow this is embarrasing. The box was getting further, so it looked smaller. It wa shuge. Kinda feel dumb now.
% - Scaling should probably be done like rotation.
%           % Now two sets of scaling functions, axis based and centroid based.
% - Transformation matrices don't work as expected.
%           % Rotation and scaling were around axis. Now translates to origin before transforming for centroid based transforms.
% - Scaling spheres doesn't work properly, moves them further or closer to the camera proportionnaly to size, always looks the same effective size.
%           % See above.
% - Camera seems to have its translation reversed.
%           % See above.
% - Transpose 3x3 part of rotation matrices, to get right hand coordinate system.
%           % Coordinate system is now right hand!
% - Save as uint16. 
%           % Function, multiplies by 65535, uint16() it, and save as png.
% - Add isometric projection.
%           % Done, fov is the distance covered.
% - Add a more traditional camera projection, through a plane.
%           % Done, looks like traditional projection, same inputs as normal camera.
% - Obj importer fails when some faces have missing data but others not.
%           % Should work now, also is much faster for big meshes. Needs more testing. Also uses more memory for single objects.
% - Multi-material meshes.
%           % Now works, mesh constructor can take either one material or a structure. Names should be identical to ones in the obj.
% - Instanciation.
%           % Meshes now have a reference to the geometry. Triangle_mesh class created, has a pointer to geometry and an index.
% - Separate scatterers from materials.
%           % Scatterers are now objects, material take one as input. Fewer materials now.
% - Create back-scatterer.
%           % Now exists a scatterer with distribution and angle input. Useful for bacl-scatterers and cloudy materials.
% - Maybe make scatterers and fuzz objects have a distribution object instead of the two variables? maybe faster.
%           % Not implemented, replaced beta funcitons by exponents.
% - There is an issue with light-emitting absorbers, for ex. "room" scene. Too much light is emitted. 
%           % Prob not an issue with absorber, but with reflective_refractive_fuzz. There was one term too many in the colour calculation.
% - Iso camera doesn't seem to have AA.
%           % It did.
% - There is an issue with light-emitting absorbers, possibly also scatterers.
%           % Now has a different curve than absorbtion, that goes sqrt instead of exp. Maybe causes new bright spot issue.
%           % If causing issues go back to linear or something.
% - Portal can give all black results.
%           % Portal was setting noew ray origin as ray origin translated, not as hitpoint translated as it should have.
% - Portal, when going around, sometimes has black spots.
%           % Related to issue above.
% - Add portal scatterer.
%           % Added, works well but should be tested with non-infinite stuff.
% - Add fresnel mix / random mix as medium, defaults to one entry when coming out.
%           % Both exist now, and only mix if comint into the material.