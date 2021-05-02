clear; clc; close all;

front = readtable('../geometries/VMS_front_rear.xlsx', 'Sheet', 'VMS Front Suspension');
rear = readtable('../geometries/VMS_front_rear.xlsx', 'Sheet', 'VMS Rear Suspension');

tire_od = 17.4 * (25.4 / 1000); % meters
tire_width = 7 * (25.4 / 1000); % meters

extract_pt = @(data, pt) table2array(data(cell2mat(data.Pt) == pt, 2:4));
plot_pt = @(pt) plot3(pt(1), pt(2), pt(3), 'o');

% sanity check
% front_pts = [front_A; front_B; front_C; front_D; front_E; front_F; front_M; front_N; front_P; front_R; front_H; front_J; front_K; front_L; front_G];
% front_names = 'ABCDEFMNPRHJKLG';
% figure
% hold on
% for i = 1:length(front_pts)
%     plot_pt(front_pts(i,:));
%     text(front_pts(i,1)+0.01, front_pts(i,2)+0.01, front_pts(i,3)+0.01, front_names(i));
% end
% hold off

% rear import
rear_A = extract_pt(rear, 'A') / 1000;
rear_B = extract_pt(rear, 'B') / 1000;
rear_C = extract_pt(rear, 'C') / 1000;
rear_D = extract_pt(rear, 'D') / 1000;
rear_E = extract_pt(rear, 'E') / 1000;
rear_F = extract_pt(rear, 'F') / 1000;

rear_M = extract_pt(rear, 'M') / 1000;
rear_N = extract_pt(rear, 'N') / 1000;
rear_P = extract_pt(rear, 'P') / 1000;
rear_R = extract_pt(rear, 'R') / 1000;

rear_H = extract_pt(rear, 'H') / 1000;
rear_J = extract_pt(rear, 'J') / 1000;
rear_K = extract_pt(rear, 'K') / 1000;

rear_L = extract_pt(rear, 'L') / 1000;
rear_G = extract_pt(rear, 'G') / 1000;

% front import
front_A = extract_pt(front, 'A') / 1000;
front_B = extract_pt(front, 'B') / 1000;
front_C = extract_pt(front, 'C') / 1000;
front_D = extract_pt(front, 'D') / 1000;
front_E = extract_pt(front, 'E') / 1000;
front_F = extract_pt(front, 'F') / 1000;

front_M = extract_pt(front, 'M') / 1000;
front_N = extract_pt(front, 'N') / 1000;
front_P = extract_pt(front, 'P') / 1000;
front_R = extract_pt(front, 'R') / 1000;

front_H = extract_pt(front, 'H') / 1000;
front_J = extract_pt(front, 'J') / 1000;
front_K = extract_pt(front, 'K') / 1000;

front_L = extract_pt(front, 'L') / 1000;
front_G = extract_pt(front, 'G') / 1000;

% rear calculations
rear_lca = wishbone_geometry_calc(rear_A, rear_B, rear_C);
rear_uca = rear_uca_calc(rear_D, rear_E, rear_F, rear_N);

rear_upright = upright_geometry_calc(rear_B, rear_E, rear_M, rear_P, rear_R);

rear_MN_len = norm(rear_M - rear_N);
rear_toelink_dim = [rear_MN_len, rear_MN_len / 100, rear_MN_len / 100];

rear_bellcrank = rear_bellcrank_calc(rear_H, rear_J, rear_K);

rear_GH_len = norm(rear_G - rear_H);
rear_pushrod_dim = [rear_GH_len, rear_GH_len / 100, rear_GH_len / 100];

rear_L_cylinder_len = norm(rear_L - rear_J) / 2;
rear_cylinder_dim = [rear_L_cylinder_len, rear_L_cylinder_len / 100, rear_L_cylinder_len / 100];

rear_J_piston_len = norm(rear_L - rear_J) / 2;
rear_piston_dim = [rear_J_piston_len, rear_J_piston_len / 100, rear_J_piston_len / 100];

% front calculations
front_lca = wishbone_geometry_calc(front_A, front_B, front_C);
front_uca = wishbone_geometry_calc(front_D, front_E, front_F);

front_upright = upright_geometry_calc(front_B, front_E, front_M, front_P, front_R);

front_MN_len = norm(front_M - front_N);
front_steering_rod_dim = [front_MN_len, front_MN_len / 100, front_MN_len / 100];