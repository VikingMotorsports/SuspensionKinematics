function [upright] = upright_geometry_calc(B, E, M, P, R)
%UPRIGHT_GEOMETRY_CALC Summary of this function goes here
%   Detailed explanation goes here
    BE = E - B;
    BM = M - B;
    BMp = BE .* (dot(BM, BE)./norm(BE)^2);
    Mp = B + BMp;
    MpM = M - Mp;
    
    offset = B;
    i = BE / norm(BE);
    j = MpM / norm(MpM);
    k = cross(i, j);
    basis = [offset; i; j; k];
    
    [~, WheelAxis_XRot, WheelAxis_YRot, ~] = WheelAxisLocator(basis, P, R);

    B = [0, 0];
    E = [norm(BE), 0];
    M = [norm(BMp), norm(MpM)];
    
    upright.dim = [B; E; M];
    upright.basis = basis;
    upright.WheelAxis_XRot = WheelAxis_XRot;
    upright.WheelAxis_YRot = WheelAxis_YRot;
%     BE_len = norm(BE);
%     BMp_x = norm(BMp);
%     BMp_y = norm(MpM);
end

