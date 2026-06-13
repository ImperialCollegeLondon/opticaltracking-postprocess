function cor = piecewise_centre_of_rotation(self, assignments, neutral)
    % looks for folder names (states) that include COR_STRING to create a
    % piecewise centre of rotation. "COR" by default.
    arguments
        self Trajectory
        assignments Assignments
        neutral string
    end
    words = split(self.states, "_COR");
    states = words(:, :, 1);
    states_unique = unique(states);
    angles = str2double(replace(words(:, :, 2), "_", ""));
    angles_unique = unique(angles);

    i = 1;
    for ang = 1:numel(angles_unique)
        angle = angles_unique(ang);
        is_ang = angles == angle;

        for st = 1:numel(states_unique)
            state = states_unique(st);
            is_state = states == state;
            tsTorigin = [];
            for ass = 1:numel(assignments)
                ends_with = assignments(ass).ends_with;
                starts_with = assignments(ass).starts_with;
                is_lc = lower(self.loading_condition) == lower(ends_with);

                is_current = is_lc & is_state & is_ang;
                trajectories = self(is_current);

                for traj = 1:numel(trajectories)

                    trajectory = trajectories(traj);
                    fTts = trajectory.Transform.fTts;

                    tsTf = pageinv(fTts);
                    tsTf_start = mean(tsTf(:, :, 10:30), 3, "omitmissing");
                    tsTf_end = mean(tsTf(:, :, end-30:end-10), 3, "omitmissing");

                    if all(isnan(tsTf_start), "all")
                        warning("Trackers were not visible during the BEGINNING of %s/%i/%s.\nIf this is Neutral, other loading conditions might give you the information anyway", state, angle, ends_with);
                    elseif all(isnan(tsTf_end), "all")
                        warning("Trackers were not visible during the ENDING of %s/%i/%s.YOU MUST RECORD AGAIN.", state, angle, ends_with);
                    end

                    % if isempty(intact_neutral) && (starts_with == neutral)
                    %     intact_neutral = tsTf_start;
                    %     oTf_start = eye(4);
                    %     cor(i) = CentreOfRotation(starts_with, angle, state, oTf_start, eye(4));
                    % else
                    %     oTf_start = intact_neutral \ tsTf_start; % Femur in origin frame of reference
                    %     cor(i) = CentreOfRotation(starts_with, angle, state, oTf_start, intact_neutral);
                    % end

                    if (isempty(tsTorigin) || all(isnan(tsTorigin), "all")) && (starts_with == neutral)
                        tsTorigin = tsTf_start;

                    end

                    cor(i) = CentreOfRotation(starts_with, angle, state, tsTf_start, tsTorigin);

                    i = i + 1;

                    cor(i) = CentreOfRotation(ends_with, angle, state, tsTf_end, tsTorigin);

                    i = i + 1;

                end

            end
        end
    end

end
