function plot_centre_of_rotation(self)
keyboard
datum = self(88);
origin = datum.Transform.origin;
direction = datum.Transform.direction;
flexion = datum.Kinematics.tibiofemoral.flexion;
n = [31 37 44 48 53 59 66 77 88];

dx = direction(1, n);
dy = direction(2, n);
x0 = origin(1, n);
y0 = origin(2, n);

% x_range = [-50; 60];
% t = (x_range - x0) ./ dx;  % 2x16

t = [-60; 60];
x = x0 + t .* dx;
y = y0 + t .* dy;           % 2x16

% plot(x_range .* ones(size(y)), y, 'r-');
plot(x, y, 'r-');
% text(x_range(2) .* ones(1, numel(n)), y(2, :), arrayfun(@(x) sprintf('%.0f°', x), flexion(n), UniformOutput=false));

[label_x, end_idx] = max(x, [], 1);
label_y = y(sub2ind(size(y), end_idx, 1:size(y,2)));
text(label_x, label_y, arrayfun(@(v) sprintf('%.0f°', v), flexion(n), UniformOutput=false));

scatter(x0, y0, 5, 'r', 'filled');
end