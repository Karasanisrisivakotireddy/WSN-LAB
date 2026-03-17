clc;
clear;
close all;

n = 10;                 % total nodes including sink
sink = [0, 0];          % sink at center
radius = 5;             % distance of nodes from sink

% Generate star-shaped node positions (uniformly on a circle)
theta = linspace(0, 2*pi, n);  
theta(end) = [];        % remove duplicate 2? point
nodes = radius * [cos(theta)', sin(theta)'];

figure;
hold on;
grid on;
axis equal;

% Plot nodes and sink
scatter(nodes(:,1), nodes(:,2), 100, 'b', 'filled');
scatter(sink(1), sink(2), 250, 'yellow', 'filled');

% Draw star topology links
for i = 1:size(nodes,1)
    plot([sink(1), nodes(i,1)], [sink(2), nodes(i,2)], '-k', 'LineWidth', 1.5);
end

% Parameters
numPackets = 100;
packetSizeBytes = 1;
numNodes = size(nodes,1);

% Packet distribution
basePacketsPerNode = floor(numPackets / numNodes);
remainder = mod(numPackets, numNodes);
packetsPerNode = basePacketsPerNode * ones(numNodes,1);
packetsPerNode(1:remainder) = packetsPerNode(1:remainder) + 1;

dataPerNodeBytes = packetsPerNode * packetSizeBytes;

% Simulate packet transmission (random loss example)
lossProbability = 0.1;  % 10% chance packet is lost
packetsReceived = zeros(numNodes,1);
packetsLost = zeros(numNodes,1);

for i = 1:numNodes
    for p = 1:packetsPerNode(i)
        if rand() > lossProbability
            packetsReceived(i) = packetsReceived(i) + 1;
        else
            packetsLost(i) = packetsLost(i) + 1;
        end
    end
end

% Annotate nodes
for i = 1:numNodes
    txt = sprintf('%d pkt\n%d B', packetsPerNode(i), dataPerNodeBytes(i));
    text(nodes(i,1)*1.08, nodes(i,2)*1.08, txt, ...
        'Color', 'k', 'FontSize', 8, 'HorizontalAlignment','center');
end

title(sprintf('Star Topology WSN (Sink ? %d Nodes, %d Packets)', ...
      numNodes, numPackets));
xlabel('X-axis');
ylabel('Y-axis');
hold off;

% Print data for Star Topology
fprintf('--- Star Topology Packet Stats ---\n');
fprintf('Node\tTransmitted\tReceived\tLost\n');
for i = 1:numNodes
    fprintf('%d\t%d\t\t%d\t\t%d\n', i, packetsPerNode(i), packetsReceived(i), packetsLost(i));
end

%% Mesh Topology
figure;
hold on;
grid on;
axis equal;

% Plot nodes and sink
scatter(nodes(:,1), nodes(:,2), 100, 'b', 'filled');
scatter(sink(1), sink(2), 250, 'yellow', 'filled');

% Create all pairwise links between nodes + sink
for i = 1:numNodes
    for j = i+1:numNodes
        plot([nodes(i,1), nodes(j,1)], [nodes(i,2), nodes(j,2)], '-k', 'LineWidth', 0.8);
    end
    plot([sink(1), nodes(i,1)], [sink(2), nodes(i,2)], '-k', 'LineWidth', 1.0);
end

% Simulate packet transmission for Mesh (you can adjust lossProbability if needed)
packetsReceivedMesh = zeros(numNodes,1);
packetsLostMesh = zeros(numNodes,1);

for i = 1:numNodes
    for p = 1:packetsPerNode(i)
        if rand() > lossProbability
            packetsReceivedMesh(i) = packetsReceivedMesh(i) + 1;
        else
            packetsLostMesh(i) = packetsLostMesh(i) + 1;
        end
    end
end

% Annotate nodes
for i = 1:numNodes
    txt = sprintf('%d pkt\n%d B', packetsPerNode(i), dataPerNodeBytes(i));
    text(nodes(i,1)*1.08, nodes(i,2)*1.08, txt, ...
        'Color', 'k', 'FontSize', 8, 'HorizontalAlignment','center');
end

title(sprintf('Mesh Topology WSN (Sink + %d Nodes, %d Packets)', ...
      numNodes, numPackets));
xlabel('X-axis');
ylabel('Y-axis');
hold off;

% Print data for Mesh Topology
fprintf('--- Mesh Topology Packet Stats ---\n');
fprintf('Node\tTransmitted\tReceived\tLost\n');
for i = 1:numNodes
    fprintf('%d\t%d\t\t%d\t\t%d\n', i, packetsPerNode(i), packetsReceivedMesh(i), packetsLostMesh(i));
end
