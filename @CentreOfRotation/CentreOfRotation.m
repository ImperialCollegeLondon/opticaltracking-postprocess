classdef CentreOfRotation
    properties
        loading_condition
        angle
        state
        direction
        origin
        intersection
    end

    methods
        function self = CentreOfRotation(loading_condition, angle, state, tsTf, tsTorigin)
            arguments
                loading_condition string
                angle
                state
                tsTf (4, 4, :)
                tsTorigin (4, 4)
            end

            self.loading_condition = categorical(loading_condition);
            self.angle = angle;
            self.state = categorical(state);

            intersects_with = eye(4);

            if all(isnan(tsTorigin), "all")
                self.intersection = [NaN; NaN];
                self.direction = [NaN; NaN];
                self.origin = [NaN; NaN];
                return
            end

            oTf = tsTorigin \ tsTf; %femur relative to origin (identity matrix)

            if all(oTf - intersects_with < 1e-5, "all")
                self.intersection = [0; 0];
                self.direction = oTf(1:2, 1, :);
                self.origin = oTf(1:2, 4, :);
                return
            end
                

            d1 = get_ml(oTf);
            d2 = get_ml(intersects_with);
            p1 = get_origin(oTf);
            p2 = get_origin(intersects_with);

            % Two lines intersect when p1 + d1*t == p2 + d2*s
            % d1*t - d2*s = p2 - p1
            % written in matrix form: [d1, -d2] * [t;s] = p2 - p1
            %                         ^^^^^^^^    ^^^^    ^^^^^^^
            %                            A         x         b

            A = [d1, -d2];
            b = p2 - p1;
            x = A \ b;
            t = x(1);

            self.intersection = d1*t + p1;
            self.direction = d1;
            self.origin = p1;



% origin = datum.Transform.origin;
% direction = datum.Transform.direction;
% flexion = datum.Kinematics.tibiofemoral.flexion;
% n = [31 37 44 48 53 59 66 77 88];
%
% dx = direction(1, n);
% dy = direction(2, n);
% x0 = origin(1, n);
% y0 = origin(2, n);
%
% % x_range = [-50; 60];
% % t = (x_range - x0) ./ dx;  % 2x16
%
% t = [-60; 60];
% x = x0 + t .* dx;
% y = y0 + t .* dy;           % 2x16
%
% % plot(x_range .* ones(size(y)), y, 'r-');
% plot(x, y, 'r-');
% % text(x_range(2) .* ones(1, numel(n)), y(2, :), arrayfun(@(x) sprintf('%.0f°', x), flexion(n), UniformOutput=false));
%
% [label_x, end_idx] = max(x, [], 1);
% label_y = y(sub2ind(size(y), end_idx, 1:size(y,2)));
% text(label_x, label_y, arrayfun(@(v) sprintf('%.0f°', v), flexion(n), UniformOutput=false));
%
% scatter(x0, y0, 5, 'r', 'filled');
% end

        end
    end
end






function y = get_ml(x)
    y = squeeze(x(1:2, 1, :));
end
function y = get_origin(x)
    y = squeeze(x(1:2, 4, :));
end
