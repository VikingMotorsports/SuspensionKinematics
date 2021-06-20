clear; clc; close all;
addpath 'functions'
addpath 'subsystems'

fprintf("Running\n");

front_f = readtable('geometries/VMS_front_rear.xlsx', 'Sheet', 'VMS Front Suspension');
rear_f = readtable('geometries/VMS_front_rear.xlsx', 'Sheet', 'VMS Rear Suspension');

tire_od = 17.4 * (25.4 / 1000); % outer diameter of the tire in meters
tire_width = 7 * (25.4 / 1000); % width of the tire in meters

plot_pt = @(pt) plot3(pt(3), pt(1), pt(2), 'o');

[front_p, rear_p] = read_points(front_f, rear_f);

[front_s, rear_s] = calculate_geometries(front_p, rear_p);

fprintf("Done\n");

% % sanity check
% front_names = 'ABCDEFMNPRHJKLG';
% figure
% hold on
% for i = 1:length(front_names)
%     pt = front_p.left.(front_names(i));
%     plot_pt(pt);
%     text(pt(3)+0.01, pt(1)+0.01, pt(2)+0.01, front_names(i));
% end
% hold off