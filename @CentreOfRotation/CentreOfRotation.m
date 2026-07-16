classdef CentreOfRotation
    properties
        specimen
        loading_condition
        is_right_knee
        angle
        state
        direction
        origin
        intersection
    end

    methods
        function self = CentreOfRotation(specimen, loading_condition, angle, state, oTf, is_right_knee)
            % Uses tsTorigin to calculate the transform from tsTf 
            % arguments
            %     loading_condition string
            %     angle
            %     state
            %     oTf (4, 4, :) %femur relative to origin (identity matrix)
            % end

            if nargin == 0
                return
            end


            self.specimen = specimen;
            self.loading_condition = loading_condition;
            self.state = state;
            self.angle = angle;
            self.is_right_knee = is_right_knee;

            if all(isnan(oTf), "all")
                self.intersection = [NaN; NaN];
                self.direction = [NaN; NaN];
                self.origin = [NaN; NaN];
                return
            end

            intersects_with = eye(4);

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

        end
    end
end






function y = get_ml(x)
    y = squeeze(x(1:2, 1, :));
end
function y = get_origin(x)
    y = squeeze(x(1:2, 4, :));
end
