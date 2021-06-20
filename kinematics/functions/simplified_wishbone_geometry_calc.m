function [BpB_len, BpB_dim, Bp] = simplified_wishbone_geometry_calc(A, B, C)
%SIMPLIFIED_WISHBONE_GEOMETRY_CALC Summary of this function goes here
%   Detailed explanation goes here

    AC = C - A;
    AB = B - A;
    ABp = AC .* (dot(AB, AC)./norm(AC)^2);
    Bp = A + ABp;
    BpB = B - Bp;

    BpB_len = norm(BpB);
    BpB_dim = [BpB_len, BpB_len/100, BpB_len/100];
end

