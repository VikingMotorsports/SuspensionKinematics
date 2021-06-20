function [front_s, rear_s] = calculate_geometries(front_p, rear_p)
%CALCULATE_GEOMETRIES Summary of this function goes here
%   Detailed explanation goes here

    % rear left calculations
    rear_s.left.lca = wishbone_geometry_calc(rear_p.left.A, rear_p.left.B, rear_p.left.C);
    rear_s.left.uca = rear_uca_calc(rear_p.left.D, rear_p.left.E, rear_p.left.F, rear_p.left.N);

    rear_s.left.upright = upright_geometry_calc(rear_p.left.B, rear_p.left.E, rear_p.left.M, rear_p.left.P, rear_p.left.R);

    rear_s.left.MN_len = norm(rear_p.left.M - rear_p.left.N);
    rear_s.left.toelink_dim = [rear_s.left.MN_len, rear_s.left.MN_len / 100, rear_s.left.MN_len / 100];

    rear_s.left.bellcrank = rear_bellcrank_calc(rear_p.left.H, rear_p.left.J, rear_p.left.K);

    rear_s.left.GH_len = norm(rear_p.left.G - rear_p.left.H);
    rear_s.left.pushrod_dim = [rear_s.left.GH_len, rear_s.left.GH_len / 100, rear_s.left.GH_len / 100];

    rear_s.left.L_cylinder_len = norm(rear_p.left.L - rear_p.left.J) / 2;
    rear_s.left.cylinder_dim = [rear_s.left.L_cylinder_len, rear_s.left.L_cylinder_len / 20, rear_s.left.L_cylinder_len / 20];

    rear_s.left.J_piston_len = norm(rear_p.left.L - rear_p.left.J) / 2;
    rear_s.left.piston_dim = [rear_s.left.J_piston_len, rear_s.left.J_piston_len / 20, rear_s.left.J_piston_len / 20];
    
    % rear right calculations
    rear_s.right.lca = wishbone_geometry_calc(rear_p.right.A, rear_p.right.B, rear_p.right.C);
    rear_s.right.uca = rear_uca_calc(rear_p.right.D, rear_p.right.E, rear_p.right.F, rear_p.right.N);

    rear_s.right.upright = upright_geometry_calc(rear_p.right.B, rear_p.right.E, rear_p.right.M, rear_p.right.P, rear_p.right.R);

    rear_s.right.MN_len = norm(rear_p.right.M - rear_p.right.N);
    rear_s.right.toelink_dim = [rear_s.right.MN_len, rear_s.right.MN_len / 100, rear_s.right.MN_len / 100];

    rear_s.right.bellcrank = rear_bellcrank_calc(rear_p.right.H, rear_p.right.J, rear_p.right.K);

    rear_s.right.GH_len = norm(rear_p.right.G - rear_p.right.H);
    rear_s.right.pushrod_dim = [rear_s.right.GH_len, rear_s.right.GH_len / 100, rear_s.right.GH_len / 100];

    rear_s.right.L_cylinder_len = norm(rear_p.right.L - rear_p.right.J) / 2;
    rear_s.right.cylinder_dim = [rear_s.right.L_cylinder_len, rear_s.right.L_cylinder_len / 20, rear_s.right.L_cylinder_len / 20];

    rear_s.right.J_piston_len = norm(rear_p.right.L - rear_p.right.J) / 2;
    rear_s.right.piston_dim = [rear_s.right.J_piston_len, rear_s.right.J_piston_len / 20, rear_s.right.J_piston_len / 20];

    % front left calculations
    front_s.left.lca = wishbone_geometry_calc(front_p.left.A, front_p.left.B, front_p.left.C);
    front_s.left.uca = wishbone_geometry_calc(front_p.left.D, front_p.left.E, front_p.left.F);

    front_s.left.upright = upright_geometry_calc(front_p.left.B, front_p.left.E, front_p.left.M, front_p.left.P, front_p.left.R);

    front_s.left.MN_len = norm(front_p.left.M - front_p.left.N);
    front_s.left.steering_rod_dim = [front_s.left.MN_len, front_s.left.MN_len / 100, front_s.left.MN_len / 100];

    front_s.left.bellcrank = rear_bellcrank_calc(front_p.left.H, front_p.left.J, front_p.left.K);

    front_s.left.GH_len = norm(front_p.left.G - front_p.left.H);
    front_s.left.pushrod_dim = [front_s.left.GH_len, front_s.left.GH_len / 100, front_s.left.GH_len / 100];

    front_s.left.L_cylinder_len = norm(front_p.left.L - front_p.left.J) / 2;
    front_s.left.cylinder_dim = [front_s.left.L_cylinder_len, front_s.left.L_cylinder_len / 20, front_s.left.L_cylinder_len / 20];

    front_s.left.J_piston_len = norm(front_p.left.L - front_p.left.J) / 2;
    front_s.left.piston_dim = [front_s.left.J_piston_len, front_s.left.J_piston_len / 20, front_s.left.J_piston_len / 20];
    
    % front right calculations
    front_s.right.lca = wishbone_geometry_calc(front_p.right.A, front_p.right.B, front_p.right.C);
    front_s.right.uca = wishbone_geometry_calc(front_p.right.D, front_p.right.E, front_p.right.F);

    front_s.right.upright = upright_geometry_calc(front_p.right.B, front_p.right.E, front_p.right.M, front_p.right.P, front_p.right.R);

    front_s.right.MN_len = norm(front_p.right.M - front_p.right.N);
    front_s.right.steering_rod_dim = [front_s.right.MN_len, front_s.right.MN_len / 100, front_s.right.MN_len / 100];

    front_s.right.bellcrank = rear_bellcrank_calc(front_p.right.H, front_p.right.J, front_p.right.K);

    front_s.right.GH_len = norm(front_p.right.G - front_p.right.H);
    front_s.right.pushrod_dim = [front_s.right.GH_len, front_s.right.GH_len / 100, front_s.right.GH_len / 100];

    front_s.right.L_cylinder_len = norm(front_p.right.L - front_p.right.J) / 2;
    front_s.right.cylinder_dim = [front_s.right.L_cylinder_len, front_s.right.L_cylinder_len / 20, front_s.right.L_cylinder_len / 20];

    front_s.right.J_piston_len = norm(front_p.right.L - front_p.right.J) / 2;
    front_s.right.piston_dim = [front_s.right.J_piston_len, front_s.right.J_piston_len / 20, front_s.right.J_piston_len / 20];
end
