clear; clc;

%front = readtable('../geometries/VMS_front_rear.xlsx', 'Sheet', 'VMS Front Suspension');
rear = readtable('../geometries/VMS_front_rear.xlsx', 'Sheet', 'VMS Rear Suspension');

tire_od = 18 * 25.4 / 1000; % meters
tire_width = 7 * 25.4 / 1000; % meters

extract_pt = @(data, pt) table2array(data(cell2mat(data.Pt) == pt, 2:4));

A = extract_pt(rear, 'A') / 1000;
B = extract_pt(rear, 'B') / 1000;
C = extract_pt(rear, 'C') / 1000;
D = extract_pt(rear, 'D') / 1000;
E = extract_pt(rear, 'E') / 1000;
F = extract_pt(rear, 'F') / 1000;

M = extract_pt(rear, 'M') / 1000;
%N = [100, 255, -180] / 1000; % fake point at the chassis, just for testing
N = extract_pt(rear, 'N') / 1000;
P = extract_pt(rear, 'P') / 1000;
R = extract_pt(rear, 'R') / 1000;

% [BpB_len, BpB_dim, Bp] = simplified_wishbone_geometry_calc(A, B, C);
% [EpE_len, EpE_dim, Ep] = simplified_wishbone_geometry_calc(D, E, F);
rear_lca = wishbone_geometry_calc(A, B, C);
rear_uca = wishbone_geometry_calc(D, E, F);

[upright_dim, BE_len, BMp_x, BMp_y] = upright_geometry_calc(B, E, M);

MN_len = norm(M - N);
toelink_dim = [MN_len, MN_len / 100, MN_len / 100];