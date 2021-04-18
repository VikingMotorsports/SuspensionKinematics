function [wishbone] = wishbone_geometry_calc(A, B, C)
%WISHBONE_GEOMETRY_CALC Summary of this function goes here
%   Detailed explanation goes here
    
    % create extrusion shape
    AC = C - A;
    AB = B - A;
    ABp = AC .* (dot(AB, AC)./norm(AC)^2);
    Bp = A + ABp;
    BpB = B - Bp;
    
    i = (-AC) / norm(AC);
    j = BpB / norm(BpB);
    k = cross(i, j);
    offset = A;
    
    A_extr = [0, 0];
    B_extr = [-norm(ABp), norm(BpB)];
    C_extr = [-norm(AC), 0];
    t = norm(AB) / 100; % "thickness" of the outline
    
    outline = [A_extr - [t, 0]; A_extr; A_extr + [t, 0];
               B_extr + [t, 0]; B_extr; B_extr - [t, 0];
               C_extr - [t, 0]; C_extr; C_extr + [t, 0];
               B_extr - [0, t]];
      
    wishbone.A = A;
    wishbone.B = B;
    wishbone.Bp = Bp;
    wishbone.C = C;
    wishbone.AB = AB;
    wishbone.AC = AC;
    wishbone.ABp = ABp;
    wishbone.BpB = BpB;
    
    wishbone.A_extr = A_extr;
    wishbone.B_extr = B_extr;
    wishbone.C_extr = C_extr;
    wishbone.outline = outline;
    
    wishbone.basis = [offset; i; j; k];
end

