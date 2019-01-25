function xyz = to_xyzoffset(sph, reference)
    xyz = [sph(1)*sin(sph(2))*cos(sph(3)), sph(1)*sin(sph(2))*sin(sph(3)), sph(1)*cos(sph(2))] * reference;
end