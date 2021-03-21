function [dim, BE_len, BMp_x, BMp_y] = upright_geometry_calc(B, E, M)
%UPRIGHT_GEOMETRY_CALC Summary of this function goes here
%   Detailed explanation goes here
    BE = E - B;
    BM = M - B;
    BMp = BE .* (dot(BM, BE)./norm(BE)^2);
    Mp = B + BMp;
    MpM = M - Mp;

    B = [0, 0];
    E = [norm(BE), 0];
    M = [norm(BMp), norm(MpM)];
    
    dim = [B; E; M];
    BE_len = norm(BE);
    BMp_x = norm(BMp);
    BMp_y = norm(MpM);
end

