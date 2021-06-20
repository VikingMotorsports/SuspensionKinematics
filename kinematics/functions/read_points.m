function [front, rear] = read_points(front_f, rear_f)
%READ_POINTS Summary of this function goes here
%   Detailed explanation goes here
    extract_pt = @(data, pt) table2array(data(cell2mat(data.Pt) == pt, 2:4));

    % rear left import
    rear.left.A = extract_pt(rear_f, 'A') / 1000;
    rear.left.B = extract_pt(rear_f, 'B') / 1000;
    rear.left.C = extract_pt(rear_f, 'C') / 1000;
    rear.left.D = extract_pt(rear_f, 'D') / 1000;
    rear.left.E = extract_pt(rear_f, 'E') / 1000;
    rear.left.F = extract_pt(rear_f, 'F') / 1000;

    rear.left.M = extract_pt(rear_f, 'M') / 1000;
    rear.left.N = extract_pt(rear_f, 'N') / 1000;
    rear.left.P = extract_pt(rear_f, 'P') / 1000;
    rear.left.R = extract_pt(rear_f, 'R') / 1000;

    rear.left.H = extract_pt(rear_f, 'H') / 1000;
    rear.left.J = extract_pt(rear_f, 'J') / 1000;
    rear.left.K = extract_pt(rear_f, 'K') / 1000;

    rear.left.L = extract_pt(rear_f, 'L') / 1000;
    rear.left.G = extract_pt(rear_f, 'G') / 1000;
    
    % rear right import
    rear.right.A = rear.left.A .* [-1 1 1];
    rear.right.B = rear.left.B .* [-1 1 1];
    rear.right.C = rear.left.C .* [-1 1 1];
    rear.right.D = rear.left.D .* [-1 1 1];
    rear.right.E = rear.left.E .* [-1 1 1];
    rear.right.F = rear.left.F .* [-1 1 1];

    rear.right.M = rear.left.M .* [-1 1 1];
    rear.right.N = rear.left.N .* [-1 1 1];
    rear.right.P = rear.left.P .* [-1 1 1];
    rear.right.R = rear.left.R .* [-1 1 1];

    rear.right.H = rear.left.H .* [-1 1 1];
    rear.right.J = rear.left.J .* [-1 1 1];
    rear.right.K = rear.left.K .* [-1 1 1];

    rear.right.L = rear.left.L .* [-1 1 1];
    rear.right.G = rear.left.G .* [-1 1 1];


    % front left import
    front.left.A = extract_pt(front_f, 'A') / 1000;
    front.left.B = extract_pt(front_f, 'B') / 1000;
    front.left.C = extract_pt(front_f, 'C') / 1000;
    front.left.D = extract_pt(front_f, 'D') / 1000;
    front.left.E = extract_pt(front_f, 'E') / 1000;
    front.left.F = extract_pt(front_f, 'F') / 1000;

    front.left.M = extract_pt(front_f, 'M') / 1000;
    front.left.N = extract_pt(front_f, 'N') / 1000;
    front.left.P = extract_pt(front_f, 'P') / 1000;
    front.left.R = extract_pt(front_f, 'R') / 1000;

    front.left.H = extract_pt(front_f, 'H') / 1000;
    front.left.J = extract_pt(front_f, 'J') / 1000;
    front.left.K = extract_pt(front_f, 'K') / 1000;

    front.left.L = extract_pt(front_f, 'L') / 1000;
    front.left.G = extract_pt(front_f, 'G') / 1000;
    
    % front right import
    front.right.A = front.left.A .* [-1 1 1];
    front.right.B = front.left.B .* [-1 1 1];
    front.right.C = front.left.C .* [-1 1 1];
    front.right.D = front.left.D .* [-1 1 1];
    front.right.E = front.left.E .* [-1 1 1];
    front.right.F = front.left.F .* [-1 1 1];

    front.right.M = front.left.M .* [-1 1 1];
    front.right.N = front.left.N .* [-1 1 1];
    front.right.P = front.left.P .* [-1 1 1];
    front.right.R = front.left.R .* [-1 1 1];

    front.right.H = front.left.H .* [-1 1 1];
    front.right.J = front.left.J .* [-1 1 1];
    front.right.K = front.left.K .* [-1 1 1];

    front.right.L = front.left.L .* [-1 1 1];
    front.right.G = front.left.G .* [-1 1 1];
end

