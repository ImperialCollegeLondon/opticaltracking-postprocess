function cor_average = average(self)
    arguments
        self CentreOfRotation
    end

    states_all = [self.state];
    angles_all = [self.angle];
    loading_conditions_all = [self.loading_condition];

    states = unique(states_all);
    angles = unique(angles_all);
    loading_conditions = unique(loading_conditions_all);

    for ag = 1:numel(angles)
        angle = angles(ag);
        is_angle = angles == angle;
        for st = 1:numel(states)
            state = states(st);
            is_state = states == state;
            for lc = 1:numel(loading_conditions)
                loading_condition = loading_conditions(lc);
                is_lc = loading_conditions == loading_condition;

            end
        end
    end

end
