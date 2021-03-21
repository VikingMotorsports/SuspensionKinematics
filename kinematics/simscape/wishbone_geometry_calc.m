function [AB_len, BC_len, AB_dim, BC_dim] = wishbone_geometry_calc(A, B, C)
%WISHBONE_GEOMETRY_CALC Summary of this function goes here
%   Detailed explanation goes here

    AB_len = norm(A - B);
    BC_len = norm(B - C);

    AB_dim = [AB_len, AB_len/100, AB_len/100];
    BC_dim = [BC_len, BC_len/100, BC_len/100];
end

