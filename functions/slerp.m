function [ phi_out ] = slerp( phi_1, phi_2, t )
%SLERP Summary of this function goes here
%   Detailed explanation goes here
    phi_1 = phi_1 + 2 * pi * ((phi_2 - phi_1) > pi);
    phi_out = phi_2 * t + phi_1 * (1 - t);
    phi_out = phi_out - 2 * pi * (phi_out > (2 * pi));
end

