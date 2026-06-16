function cor = piecewise_centre_of_rotation(self, assignments, intact, neutral)
    % looks for folder names (states) that include COR_STRING to create a
    % piecewise centre of rotation. "COR" by default.
    arguments
        self Trajectory
        assignments Assignments
        intact string = "Intact"
        neutral string = "Neutral"
    end
    words = split(self.states, "_COR");
    states = words(:, :, 1);
    states_unique = unique(states);
    if ismember(intact, states_unique)
    states_unique = [intact states_unique(states_unique ~= intact)];
    else
        error("%s is not a state in your data. This state sets the origin, so it must exist", intact);
    end
    angles = str2double(replace(words(:, :, 2), "_", ""));
    angles_unique = unique(angles);

    i = 1;

    is_start_neutral = [assignments.starts_with] == neutral;
    assignments_start_neutral = assignments(is_start_neutral);

    start_neutral = [assignments_start_neutral.ends_with];

    contains_neutral = ismember(self.loading_condition, [neutral start_neutral]);
    is_intact = states == intact;

    idx_start = 10:30;
    

    for ang = 1:numel(angles_unique)
        angle = angles_unique(ang);
        is_ang = angles == angle;

        intacts_neutrals = self(contains_neutral & is_intact & is_ang);
        transforms_intact_neutral = [intacts_neutrals.Transform];
        fTts_intact_full = {transforms_intact_neutral.fTts};
        fTts_intact_neutral = cellfun(@(x) x(:, :, idx_start), fTts_intact_full, UniformOutput=false);
        tsTorigin_intact_neutral = cellfun(@pageinv, fTts_intact_neutral, UniformOutput=false);
        tsTorigin = mean(cat(3, tsTorigin_intact_neutral{:}), 3, "omitmissing");

        for st = 1:numel(states_unique)
            state = states_unique(st);
            is_state = states == state;
            % tsTorigin = [];
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
                    tsTf_start = mean(tsTf(:, :, idx_start), 3, "omitmissing");
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
                    
                    
                    % if (isempty(tsTorigin) || all(isnan(tsTorigin), "all")) && (starts_with == neutral)
                    %     tsTorigin = tsTf_start;
                    % 
                    % end
                    oTf_start = tsTorigin \ tsTf_start;
                    % oTf_start = tsTf_start;
                    cor(i) = CentreOfRotation(starts_with, angle, state, oTf_start);

                    i = i + 1;

                    oTf_end = tsTorigin \ tsTf_end; %femur relative to origin (identity matrix)
                   % oTf_end =  tsTf_end;
                    cor(i) = CentreOfRotation(ends_with, angle, state, oTf_end);

                    i = i + 1;

                end

            end
        end
    end

end
