clc;
clear;
close all;

%% Number of Nodes
numNodes = 15;

%% Generate random node positions
positions = rand(numNodes, 2) * 100;

%% Define Source and Sink
sourceNodeId = 1;
sinkNodeId   = numNodes;

%% Plot Network Topology
figure;
hold on;
grid on;
xlabel('X Coordinate');
ylabel('Y Coordinate');
title('Wireless Sensor Network - Node Distribution');

scatter(positions(:,1), positions(:,2), 100, 'b', 'filled');
scatter(positions(sourceNodeId,1), positions(sourceNodeId,2), ...
        120, 'g', 'filled');
scatter(positions(sinkNodeId,1), positions(sinkNodeId,2), ...
        120, 'r', 'filled');

%% Draw communication links
for i = 1:numNodes
    for j = i+1:numNodes
        plot([positions(i,1), positions(j,1)], ...
             [positions(i,2), positions(j,2)], 'k--');
    end
end

legend('Sensor Nodes', 'Source Node', 'Sink Node');

%% Transmission Parameters
totalPackets      = 50;
packetLossChance  = 0.1;
collisionChance   = 0.2;

successfulTransmissions = 0;
packetLossCount = 0;
collisionCount  = 0;

%% Packet Transmission Simulation
for i = 1:totalPackets

    % Create packet
    packet.sourceId = sourceNodeId;
    packet.message  = sprintf('Packet %d from Source', i);
    packet.timestamp = datetime('now');

    % Random transmitting node
    transmittingNode = randi([2 numNodes]);

    % Distance calculation
    distanceToSink = norm(positions(transmittingNode,:) - ...
                          positions(sinkNodeId,:));

    fprintf('\nNode %d transmitting to Node %d\n', ...
            transmittingNode, sinkNodeId);
    fprintf('Distance: %.2f\n', distanceToSink);
    fprintf('Message: %s\n', packet.message);
    fprintf('Timestamp: %s\n', datestr(packet.timestamp));

    % Collision check
    if rand() < collisionChance
        fprintf('Collision occurred during transmission!\n');
        collisionCount = collisionCount + 1;
        continue;
    end

    % Packet loss check
    if rand() < packetLossChance
        fprintf('Packet lost during transmission!\n');
        packetLossCount = packetLossCount + 1;
    else
        fprintf('Packet successfully transmitted!\n');
        successfulTransmissions = successfulTransmissions + 1;
    end

    pause(0.1); % Visualization delay
end

%% Display Results
fprintf('\n=========== RESULTS ===========\n');
fprintf('Total Packets              : %d\n', totalPackets);
fprintf('Successful Transmissions   : %d\n', successfulTransmissions);
fprintf('Packet Loss Count          : %d\n', packetLossCount);
fprintf('Collision Count            : %d\n', collisionCount);
fprintf('================================\n');

hold off;
