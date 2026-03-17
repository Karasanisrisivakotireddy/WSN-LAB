function path = get_path(prev, target)

path = [];

while target ~= 0
    path = [target path];
    target = prev(target);
end

if length(path) == 1
    path = [];
end

end
