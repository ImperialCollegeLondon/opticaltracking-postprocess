function split_trajectories = split_piecewise(self, assignments)
    arguments
        self Trajectory
        assignments Assignments
    end

    if isempty(self)
        split_trajectories = self;
        return
    end

    % Find preallocation size
    has_conditions_to_split = ismember([self.LoadingCondition], string([assignments.ends_with]));
    prealloc_size = sum(has_conditions_to_split + 1);

    split_trajectories(prealloc_size) = Trajectory;

    i = 1;
    for n = 1:numel(self)
        assignment = assignments.is(self(n).LoadingCondition);
        if isempty(assignment)
            split_trajectories(i) = self(n);
            i = i +1;
            continue;
        end

        ends_with = assignment.ends_with;
        starts_with = assignment.starts_with;
        end_range = assignment.end_range;
        start_range = assignment.start_range;

        trajectory = self(n);

        split_trajectories(i) = copy(trajectory);
        split_trajectories(i).LoadingCondition = starts_with;

        split_trajectories(i+1) = copy(trajectory);

        transforms = fields(trajectory.Transform);
        for t = 1:numel(transforms)
            transform = transforms{t};
            curr_transf = trajectory.Transform.(transform);
            if isempty(curr_transf) || size(curr_transf, 3) < sum([start_range(:) end_range(:)], "all")
                split_trajectories(i).Transform.(transform) = [];
                split_trajectories(i+1).Transform.(transform) = [];
            else
                split_trajectories(i).Transform.(transform) = split_trajectories(i).Transform.(transform)(:, :, start_range(1):start_range(2));
                split_trajectories(i+1).Transform.(transform) = split_trajectories(i+1).Transform.(transform)(:, :, end-end_range(2):end-end_range(1));
            end
        end

        signals = fields(trajectory.Kinematics);
        for sg = 1:numel(signals)
            signal = signals{sg};
            curr_sig = trajectory.Kinematics.(signal);
            if isempty(curr_sig) || size(curr_sig, 3) < sum([start_range(:) end_range(:)], "all")
                split_trajectories(i).Kinematics.(signal) = [];
                split_trajectories(i+1).Kinematics.(signal) = [];
            else
                split_trajectories(i).Kinematics.(signal) = split_trajectories(i).Kinematics.(signal)(start_range(1):start_range(2), :);
                split_trajectories(i+1).Kinematics.(signal) = split_trajectories(i+1).Kinematics.(signal)(end-end_range(2):end-end_range(1), :);
            end
        end

        i = i + 2;


    end
end
