function [wishbone] = wishbone_geometry_calc(A, B, C)
%WISHBONE_GEOMETRY_CALC calculates basic properties of wishbones
%   This function is written with letters of the rear LCA in mind (A,B,C),
%   but any letters can be substituted, as long as their meaning is the same.
    
    AC = C - A;
    AB = B - A;
    % Bp is the projection of B onto AC
    ABp = AC .* (dot(AB, AC)./norm(AC)^2);
    Bp = A + ABp;
    BpB = B - Bp;
    
    % x-axis of the basis is along negative AC
    i = (-AC) / norm(AC);
    % y-axis of the basis is parallel to the line joining B with its projection
    j = BpB / norm(BpB);
    % the basis for wishbones has an origin at the rightmost point when
    % looking at it from the top, while sitting inside the car
    k = cross(i, j);
    offset = A;
    
    % The solid shape of the wishbone is created by drawing an extrusion outline 
    % with some thickness around the planar triangle shape of the wishbone
    A_extr = [0, 0];
    B_extr = [-norm(ABp), norm(BpB)];
    C_extr = [-norm(AC), 0];
    t = norm(AB) / 100; % "thickness" of the outline
    
    outline = [A_extr - [t, 0]; A_extr; A_extr + [t, 0];
               B_extr + [t, 0]; B_extr; B_extr - [t, 0];
               C_extr - [t, 0]; C_extr; C_extr + [t, 0];
               B_extr - [0, t]];
    
	% Putting all calculations into a structure to be returned
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