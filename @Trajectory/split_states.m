function [trajectories, secondary_arr] = split_states(self, str)
    arguments
        self Trajectory
        str = "_COR"
    end
    trajectories = copy(self);
    words = split(self.states, str);
    states = words(:, :, 1);
    angles = str2double(replace(words(:, :, 2), "_", ""));

    tmp = num2cell(states); % Can't do it with string array or using deal. Requires converting to cell. what a language...
    [trajectories.SpecimenState] = tmp{:};
    secondary_arr = angles;
end
