clc;
clear;
close all;

%% ---------------- NETWORK SETUP ----------------
N = 21;
area = 100;
sink_id = N;
source_id = 1;

rng(3);
nodes = area * rand(N,2);

node_names = cell(N,1);
for i = 1:N-1
    node_names{i} = ['n' num2str(i)];
end
node_names{N} = 'sink';

%% ---------------- ENERGY PARAMETERS ----------------
V = 5;                  
I_tx = 0.02;            
t_tx = 0.01;            
E_elec = V * I_tx * t_tx;   % Basic transmit energy

alpha = 0.0005;         
E_init = 5 * 500;       

E_nodes = ones(N,1) * E_init;

%% ---------------- BUILD ENERGY COST MATRIX ----------------
A = zeros(N);

for i = 1:N
    for j = 1:N
        if i ~= j                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              
            
            0
            0
            0
            
            0
            
            
            
            
            
            
            
            
                      
            d = sqrt((nodes(i,1)-nodes(j,1))^2 + ...
                     (nodes(i,2)-nodes(j,2))^2);

            E_tx = E_elec + alpha * d^2;
            A(i,j) = E_tx;
        else
            A(i,j) = inf;
        end
    end
end

% Remove direct source-sink link
A(source_id, sink_id) = inf;
A(sink_id, source_id) = inf;

fprintf('=========== CASE 1: NORMAL ROUTING ===========\n');

%% ================= DIJKSTRA (CASE 1) =================
visited = false(1,N);
dist = inf(1,N);
prev = zeros(1,N);
dist(source_id) = 0;

for i = 1:N
    temp = dist;
    temp(visited) = inf;
    [~, u] = min(temp);
    visited(u) = true;

    for v = 1:N
        if ~visited(v)
            alt = dist(u) + A(u,v);
            if alt < dist(v)
                dist(v) = alt;
                prev(v) = u;
            end
        end
    end
end

path = [];
target = sink_id;
while target ~= 0
    path = [target path];
    target = prev(target);
end

fprintf('Shortest Energy Path:\n');
for i = 1:length(path)-1
    fprintf('%s -> ', node_names{path(i)});
end
fprintf('%s\n', node_names{path(end)});

%% ---------------- ENERGY REDUCTION ----------------
fprintf('\nEnergy Consumption:\n');

for i = 1:length(path)-1
    sender = path(i);
    receiver = path(i+1);

    d = sqrt((nodes(sender,1)-nodes(receiver,1))^2 + ...
             (nodes(sender,2)-nodes(receiver,2))^2);

    E_tx = E_elec + alpha * d^2;
    E_nodes(sender) = E_nodes(sender) - E_tx;

    fprintf('%s Remaining Energy: %.2f mWh\n', ...
            node_names{sender}, E_nodes(sender));
end

%% ================= GRAPH CASE 1 =================
figure;
hold on; grid on;
title('Case 1: Normal Energy-Aware Routing');

for i = 1:N
    for j = i+1:N
        plot([nodes(i,1) nodes(j,1)], ...
             [nodes(i,2) nodes(j,2)], 'k:');
    end
end

scatter(nodes(1:N-1,1), nodes(1:N-1,2), 80, 'b', 'filled');
scatter(nodes(sink_id,1), nodes(sink_id,2), 150, 'r', 'filled');

for i = 1:length(path)-1
    plot([nodes(path(i),1) nodes(path(i+1),1)], ...
         [nodes(path(i),2) nodes(path(i+1),2)], ...
         'g','LineWidth',3);
end

text(nodes(:,1)+1, nodes(:,2)+1, node_names);
hold off;

%% ================= CASE 2: DAMAGED NODE =================
fprintf('\n=========== CASE 2: DAMAGED NODE ===========\n');

damaged_node = path(2);   % assume second node damaged
fprintf('Damaged Node: %s\n', node_names{damaged_node});

A(damaged_node,:) = inf;
A(:,damaged_node) = inf;

%% ================= DIJKSTRA (CASE 2) =================
visited = false(1,N);
dist = inf(1,N);
prev = zeros(1,N);
dist(source_id) = 0;

for i = 1:N
    temp = dist;
    temp(visited) = inf;
    [~, u] = min(temp);
    visited(u) = true;

    for v = 1:N
        if ~visited(v)
            alt = dist(u) + A(u,v);
            if alt < dist(v)
                dist(v) = alt;
                prev(v) = u;
            end
        end
    end
end

new_path = [];
target = sink_id;
while target ~= 0
    new_path = [target new_path];
    target = prev(target);
end

fprintf('Alternative Path:\n');
for i = 1:length(new_path)-1
    fprintf('%s -> ', node_names{new_path(i)});
end
fprintf('%s\n', node_names{new_path(end)});

%% ================= GRAPH CASE 2 =================
figure;
hold on; grid on;
title('Case 2: Alternative Path After Damage');

for i = 1:N
    for j = i+1:N
        if A(i,j) < inf
            plot([nodes(i,1) nodes(j,1)], ...
                 [nodes(i,2) nodes(j,2)], 'k:');
        end
    end
end

scatter(nodes(1:N-1,1), nodes(1:N-1,2), 80, 'b', 'filled');
scatter(nodes(sink_id,1), nodes(sink_id,2), 150, 'r', 'filled');

% Damaged node in black
scatter(nodes(damaged_node,1), nodes(damaged_node,2), ...
        200, 'k', 'filled');

% New path in magenta
for i = 1:length(new_path)-1
    plot([nodes(new_path(i),1) nodes(new_path(i+1),1)], ...
         [nodes(new_path(i),2) nodes(new_path(i+1),2)], ...
         'm','LineWidth',3);
end

text(nodes(:,1)+1, nodes(:,2)+1, node_names);
hold off;

%% ---------------- FINAL ENERGY DISPLAY ----------------
fprintf('\nFinal Energy of Nodes:\n');
for i = 1:N
    fprintf('%s : %.2f mWh\n', node_names{i}, E_nodes(i));
end