function selves = save_to_file(selves, root)
    arguments
        selves Trajectory
        root
    end
% % Prepare the folders
fp_results = fullfile(root, "results");
for n = 1:numel(selves)
    self = selves(n);


end
states = unique(selves.states);
signals = unique(selves.signals);
specimens = unique(selves.specimen);
loading_conditions = unique([selves.LoadingCondition]);
for sg = 1:numel(signals)
    signal = signals(sg);
    for sp = 1:numel(specimens)
        specimen = specimens(sp);
        for st = 1:numel(states)
            state = states(st);
            for lc = 1:numel(loading_conditions)
                loading_condition = loading_conditions(lc);

                is_specimen = specimen == [selves.specimen];
                is_state = state == [selves.states];
                is_lc = loading_condition == [selves.LoadingCondition];


                is_current = is_specimen & is_state & is_lc;
                current_specimen = [selves(is_current).Kinematics];
                for n = 1:numel(current_specimen)
                    if n > 1
                        keyboard
                    end
                    if ~ismember(signal, fields(current_specimen))
                        continue
                    end
                    datum = current_specimen(n).(signal);
                    if isempty(datum)
                        continue
                    end

                    filepath = fullfile(fp_results, signal, state, loading_condition);
                    mkdir(filepath);

                    writetable(datum, strcat(fullfile(filepath, specimen), '.csv'));
                end
            end
        end
    end
end
end
