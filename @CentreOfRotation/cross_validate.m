function self = cross_validate(self)
    arguments
        self CentreOfRotation
    end

    intersections = {self.intersection};
    is_missing_neutral = cellfun(@(x) any(isnan(x), "all"), intersections);
    missing_neutral = self(is_missing_neutral);

    missing_loading_conditions = [missing_neutral.loading_condition];
    missing_states = [missing_neutral.state];
    missing_angles = [missing_neutral.angle];

    missing_state = unique(missing_states);
    missing_angle = unique(missing_angles);
    missing_lc = unique(missing_loading_conditions);

    for ang = 1:numel(missing_angle)
        angle = missing_angle(ang);
        is_angle = [self.angle] == angle;
        for st = 1:numel(missing_state)
            state = missing_state(st);
            is_state = [self.state] == state;

            for lc = 1:numel(missing_lc)
                loading_condition = missing_lc(lc);
                is_lc = [self.loading_condition] == loading_condition;

                is_current = is_angle & is_state & is_lc;
                data = self(is_current);

                find_alternative_to_missing_value(data);
                compare_similar_loading_conditions();

            end
        end
    end
end

function find_alternative_to_missing_value(data)
    keyboard
end

function compare_similar_loading_conditions()
    error("todo");
end
