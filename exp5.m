clc;
clear;
close all;

N = 21;
area = 100;
sink_id = N;

rng(3);

nodes = area * rand(N,2);

node_names = cell(N,1);
for i = 1:N-1
    node_names{i} = ['n' num2str(i)];
end
node_names{N} = 'sink';




















%% -------- COMPLETE GRAPH (ALL CONNECTED) ----------
A = zeros(N);

for i = 1:N
    for j = 1:N
        if i ~= j
            A(i,j) = sqrt((nodes(i,1)-nodes(j,1))^2 + ...
                          (nodes(i,2)-nodes(j,2))^2);
        else
            A(i,j) = inf;
        end
    end
end

source_id = 1;

% ? Remove direct source ? sink link to force multi-hop
A(source_id, sink_id) = inf;
A(sink_id, source_id) = inf;

fprintf('=========== CASE 1: NORMAL ROUTING ===========\n');

%% -------- DIJKSTRA ----------
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

%% -------- GET PATH ----------
path = [];
target = sink_id;

while target ~= 0
    path = [target path];
    target = prev(target);
end

fprintf('Shortest Path:\n');
for i = 1:length(path)-1
    fprintf('%s -> ', node_names{path(i)});
end
fprintf('%s\n', node_names{path(end)});

%% -------- GRAPH ----------
figure;
hold on;
grid on;
title('Fully Interconnected WSN - Case 1');

% Plot all links
for i = 1:N
    for j = i+1:N
        plot([nodes(i,1) nodes(j,1)], ...
             [nodes(i,2) nodes(j,2)], 'k:');
    end
end

% Plot nodes
scatter(nodes(1:N-1,1), nodes(1:N-1,2), 80, 'b', 'filled');
scatter(nodes(sink_id,1), nodes(sink_id,2), 150, 'r', 'filled');

% Highlight shortest path
for i = 1:length(path)-1
    plot([nodes(path(i),1) nodes(path(i+1),1)], ...
         [nodes(path(i),2) nodes(path(i+1),2)], ...
         'g','LineWidth',3);
end

text(nodes(:,1)+1, nodes(:,2)+1, node_names);
hold off;

%% -------- CASE 2: DAMAGE ----------
fprintf('\n=========== CASE 2: DAMAGED NODE ===========\n');

damaged_node = path(2);
fprintf('Damaged Node: %s\n', node_names{damaged_node});

A(damaged_node,:) = inf;
A(:,damaged_node) = inf;

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

fprintf('New Shortest Path:\n');
for i = 1:length(new_path)-1
    fprintf('%s -> ', node_names{new_path(i)});
end
fprintf('%s\n', node_names{new_path(end)});

%% -------- GRAPH AFTER DAMAGE ----------
figure;
hold on;
grid on;
title('Fully Interconnected WSN - After Damage');

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
scatter(nodes(damaged_node,1), nodes(damaged_node,2), 150, 'k', 'filled');

for i = 1:length(new_path)-1
    plot([nodes(new_path(i),1) nodes(new_path(i+1),1)], ...
         [nodes(new_path(i),2) nodes(new_path(i+1),2)], ...
         'm','LineWidth',3);
end

text(nodes(:,1)+1, nodes(:,2)+1, node_names);
hold off;




