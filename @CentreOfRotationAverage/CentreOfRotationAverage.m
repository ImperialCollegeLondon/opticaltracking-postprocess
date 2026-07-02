classdef CentreOfRotationAverage
    properties
        loading_condition
        angle
        state
        direction
        direction_std
        origin
        origin_std
        intersection
        intersection_std
    end

    methods
        function self = CentreOfRotationAverage(cor)
            if nargin == 0
                return
            end

            states_all = [cor.state];
            angles_all = [cor.angle];
            loading_conditions_all = [cor.loading_condition];

            states = unique(states_all);
            angles = unique(angles_all);
            loading_conditions = unique(loading_conditions_all);

            i = 1;
            self(numel(states) * numel(angles) * numel(loading_conditions)) = CentreOfRotationAverage();

            for ag = 1:numel(angles)
                angle = angles(ag);
                is_angle = angles_all == angle;
                for st = 1:numel(states)
                    state = states(st);
                    is_state = states_all == state;
                    for lc = 1:numel(loading_conditions)
                        loading_condition = loading_conditions(lc);
                        is_lc = loading_conditions_all == loading_condition;

                        mask = is_angle & is_state & is_lc;

                        data = cor(mask);

                        origin = median([data.origin], 2, "omitmissing");
                        origin_std = std([data.origin], 0, 2, "omitmissing");

                        direction = median([data.direction], 2, "omitmissing");
                        direction_std = std([data.direction], 0, 2, "omitmissing");

                        intersection = median([data.intersection], 2, "omitmissing");
                        intersection_std = std([data.intersection], 0, 2, "omitmissing");

                        self(i).loading_condition = loading_condition;
                        self(i).angle = angle;
                        self(i).state = state;
                        self(i).direction = direction;
                        self(i).direction_std = direction_std;
                        self(i).origin = origin;
                        self(i).origin_std = origin_std;
                        self(i).intersection = intersection;
                        self(i).intersection_std = intersection_std;

                        i = i + 1;

                    end
                end
            end
        end
    end
end
