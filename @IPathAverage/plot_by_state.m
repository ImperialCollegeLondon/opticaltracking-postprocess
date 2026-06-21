function plots = plot_by_state(self, DOFs, reordered_states)
    arguments
        self IPathAverage
        DOFs = []
        reordered_states = []
    end
    states = self.states;
    loading_conditions = self.loading_conditions;
    colours = lines(numel(states));

    fig = [];

    signals = fields(self(1).Kinematics);

    if ~isempty(reordered_states)
        states = [string(reordered_states) setdiff(states, reordered_states)];
    end

    means = get_means(self, DOFs);

    for sg = 1:numel(signals)
        signal = signals{sg};

        for st = 1:numel(states)
            fig(st) = figure;
            state = states(st);
            is_state = [self.State] == state;
            means_st = means(is_state, :);

            for lc = 1:numel(loading_conditions)
                loading_condition = loading_conditions(lc);
                is_lc = [self.LoadingCondition] == loading_condition;
                colour = colours(lc, :);
                mask = is_lc & is_state;

                if ~any(mask)
                    continue
                end

                trajectory = self(mask);

                if isempty(DOFs)
                    headers = trajectory.Kinematics.(signal).Properties.VariableNames;
                    headers = setdiff(headers, 'flexion');
                else
                    headers = cellstr(DOFs);
                end

                for h = 1:numel(headers)
                    header = headers{h};
                    nexttile(h); hold on;

                    datum = trajectory.Kinematics.(signal);
                    x = datum.flexion;
                    y = datum.(header);
                    y = smoothdata(y, "gaussian", 5);
                    plots.(signal).(state)(lc) = plot(x, y, 'Color', colour, "DisplayName", state_regex_inv(loading_condition));

                    y_std = trajectory.Stdev.(signal).(header);

                    [~, idx_max] = max(means_st.(header));
                    [~, idx_min] = min(means_st.(header));

                    idx = 1:10+2*st:numel(x);
                    if idx_max == st
                        errorbar(x(idx), y(idx), 0, y_std(idx), 'LineStyle', 'none', 'Color', colour*0.7);
                    elseif idx_min == st
                        errorbar(x(idx), y(idx), y_std(idx), 0,  'LineStyle', 'none', 'Color', colour*0.7);
                    end


                    xlabel("Flexion")
                    ylabel(state_regex_inv(header));
                    grid on;
                end
            end
            has_data = ~arrayfun(@(o) isa(o, 'matlab.graphics.GraphicsPlaceholder'), plots.(signal).(state));
            lg_ax = nexttile(numel(headers) + 1);
            axis(lg_ax, 'off');

            legend(lg_ax, plots.(signal).(state)(has_data), state_regex_inv(loading_conditions(has_data)), 'Location', 'northwest');
            sgtitle(state_regex_inv(state))
        end
    end
end

function vals = get_means(self, orientations)
    signals = fields(self(1).Kinematics);

    vals = [];
    for sg = 1:numel(signals)
        signal = signals{sg};
        kinematics = [self.Kinematics];
        data = {kinematics.(signal)};

        if isempty(orientations)
            DOFs = data{1}.Properties.VariableNames;
            DOFs = setdiff(DOFs, 'flexion');
        end

        vals = cellfun(@(x) mean(x, "omitmissing"), data, "UniformOutput", false);
        vals = vertcat(vals{:});

    end
end
