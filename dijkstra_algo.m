function [dist, prev] = dijkstra_algo(A, source)

N = size(A,1);
visited = false(1,N);
dist = inf(1,N);
prev = zeros(1,N);

dist(source) = 0;

for i = 1:N
    temp = dist;
    temp(visited) = inf;
    [~, u] = min(temp);
    visited(u) = true;

    for v = 1:N
        if ~visited(v) && A(u,v) < inf
            alt = dist(u) + A(u,v);
            if alt < dist(v)
                dist(v) = alt;
                prev(v) = u;
            end
        end
    end
end

end
