function [upright] = upright_geometry_calc(B, E, M, P, R)
%UPRIGHT_GEOMETRY_CALC calculates basic properties of uprights

    BE = E - B;
    BM = M - B;
    % Mp is the projection of M onto BE
    BMp = BE .* (dot(BM, BE)./norm(BE)^2);
    Mp = B + BMp;
    MpM = M - Mp;
    
    % basis computation similar to wishbone_geometry_calc
    offset = B;
    i = BE / norm(BE);
    j = MpM / norm(MpM);
    k = cross(i, j);
    basis = [offset; i; j; k];
    
    % calculate rotation required to align the coordinate system at P
    % on the upright side with the PR line
    [~, WheelAxis_XRot, WheelAxis_YRot, ~] = WheelAxisLocator(basis, P, R);

    % extrusion shape points used to create the solid body for the upright
    Be = [0, 0];
    Ee = world2local(E, basis); Ee = Ee(1:2);
    Me = world2local(M, basis); Me = Me(1:2);
    
    % Putting all calculations into a structure to be returned
    upright.dim = [Be; Ee; Me];
    upright.basis = basis;
    upright.WheelAxis_XRot = WheelAxis_XRot;
    upright.WheelAxis_YRot = WheelAxis_YRot;
end

