clc; clear; close all;
sn = 30; mn = 20; rad = 2;
areax = 30; areay = 30;
x = rand(1,sn) * areax;
y = rand(1,sn) * areay;
m = randperm(sn, mn);
n = setdiff(1:sn, m);
figure; hold on; axis equal;
scatter(x(n), y(n), 150, 'r', 'filled');
scatter(x(m), y(m), 80, 'm', 'filled');
theta = linspace(0,2*pi,120);
for k = 1:numel(m)
    xc = x(m(k)) + rad*cos(theta);
    yc = y(m(k)) + rad*sin(theta);
    plot(xc, yc, 'g', 'LineWidth', 0.8);
end
xlabel('X-axis'); ylabel('Y-axis');
title('Sensor Deployment');
legend('Malicious','Sensor');
grid on;

# WSN-LAB
%{
clear;
close all;

totalPackets = 1000;      
coverage_radius = 50
;     


nodes_x = [0 5 10];
nodes_y = [0 0 0];

d_source_nth  = sqrt((nodes_x(2)-nodes_x(1))^2 + (nodes_y(2)-nodes_y(1))^2);
d_source_sink = sqrt((nodes_x(3)-nodes_x(1))^2 + (nodes_y(3)-nodes_y(1))^2);

if d_source_nth <= coverage_radius
    p_source_to_nth = 1 - (d_source_nth / coverage_radius);
else
    p_source_to_nth = 0;
end

if d_source_sink <= coverage_radius
    p_source_to_sink = 1 - (d_source_sink / coverage_radius);
else
    p_source_to_sink = 0;
end

received_nth = 0;
received_sink = 0;

for pkt = 1:totalPackets
    if rand <= p_source_to_nth
        received_nth = received_nth + 1;
    end
    if rand <= p_source_to_sink
        received_sink = received_sink + 1;
    end
end
fprintf('Total Packets Sent by Source : %d\n', totalPackets);
fprintf('Packets Received by Normal Node : %d\n', received_nth);
fprintf('Packets Received by Sink Node   : %d\n', received_sink);
figure;
hold on;
plot(nodes_x(1), nodes_y(1), 'ro', 'MarkerSize', 10, 'LineWidth', 2);
plot(nodes_x(2), nodes_y(2), 'go', 'MarkerSize', 10, 'LineWidth', 2);
plot(nodes_x(3), nodes_y(3), 'ko', 'MarkerSize', 10, 'LineWidth', 2);

for i = 1:length(nodes_x)
    rectangle('Position', ...
        [nodes_x(i)-coverage_radius, nodes_y(i)-coverage_radius, ...
         2*coverage_radius, 2*coverage_radius], ...
        'Curvature', [1 1], ...
        'EdgeColor', 'b', ...
        'LineStyle', '--');
end

text(nodes_x(1), nodes_y(1)+0.5, 'Source');
text(nodes_x(2), nodes_y(2)+0.5, 'Normal Node');
text(nodes_x(3), nodes_y(3)+0.5, 'Sink');

title('Distance-Based Packet Reception with Coverage Constraint');
xlabel('X Position');
ylabel('Y Position');
axis equal;
grid on;
hold off;
%}
% Node positions (make sure these are numeric vectors)
source = [0, 0];
normal = [5, 0];
sink   = [10, 0];

% Make nodes matrix (Nx2)
nodes = double([normal; sink]);  

coverage_radius = 25;
total_packets = 1000;

% Initialize received count
received_packets = zeros(size(nodes,1),1);

for pkt = 1:total_packets
    % Compute distances from source to all nodes
    distances = zeros(size(nodes,1),1);  % initialize
    for n = 1:size(nodes,1)
        distances(n) = sqrt((nodes(n,1) - source(1))^2 + (nodes(n,2) - source(2))^2);
    end
    
    % Find nodes in range
    in_range_nodes = find(distances <= coverage_radius);
    
    if ~isempty(in_range_nodes)
        % Pick one node randomly to receive the packet
        selected_node = in_range_nodes(randi(length(in_range_nodes)));
        received_packets(selected_node) = received_packets(selected_node) + 1;
    end
end

disp(['Total Packets Sent by Source : ', num2str(total_packets)]);
for n = 1:size(nodes,1)
    disp(['Packets Received by Node ', num2str(n), ' : ', num2str(received_packets(n))]);
end

disp(['Sum of received packets : ', num2str(sum(received_packets))]);

