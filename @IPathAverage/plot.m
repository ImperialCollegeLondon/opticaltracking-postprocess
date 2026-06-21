function plots = plot(self, DOFs, reordered_states)
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
        for lc = 1:numel(loading_conditions)
            loading_condition = loading_conditions(lc);
            is_lc = [self.LoadingCondition] == loading_condition;

            means_lc = means(is_lc, :);

            fig(lc) = figure;
            for st = 1:numel(states)
                state = states(st);
                is_state = [self.State] == state;
                colour = colours(st, :);
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
                    plots.(signal).(loading_condition)(st) = plot(x, y, 'Color', colour, "DisplayName", state_regex_inv(state));

                    y_std = trajectory.Stdev.(signal).(header);

                    [~, idx_max] = max(means_lc.(header));
                    [~, idx_min] = min(means_lc.(header));

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
            has_data = ~arrayfun(@(o) isa(o, 'matlab.graphics.GraphicsPlaceholder'), plots.(signal).(loading_condition));
            lg_ax = nexttile(numel(headers) + 1);
            axis(lg_ax, 'off');

            legend(lg_ax, plots.(signal).(loading_condition)(has_data), state_regex_inv(states(has_data)), 'Location', 'northwest');
            sgtitle(state_regex_inv(loading_condition))
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

    %
    %     for s = 1:numel(states)
    %         state = states(s);
    %         colour = colours(s, :);
    %
    %         if ~ismember(state, fields(self.Kinematics.(signal)))
    %             continue
    %         end
    %
    %         if isempty(orientations)
    %             DOFs = self.Kinematics.(signal).(state).(loading_condition).mean.Properties.VariableNames;
    %             DOFs = setdiff(DOFs, 'flexion');
    %         end
    %
    %         for o = 1:numel(DOFs)
    %             dof = DOFs{o};
    %             ax(o) = nexttile(o); hold on;
    %             x = self.Kinematics.(signal).(state).(loading_condition).mean.flexion;
    %             y = self.Kinematics.(signal).(state).(loading_condition).mean.(dof);
    %             y = smoothdata(y, "gaussian", 5);
    %             p = plot(x, y, 'Color', colour);
    %
    %
    %             idx = 1:10+2*s:numel(x);
    %             y_std = self.Kinematics.(signal).(state).(loading_condition).std.(dof);
    %             if s == idx_top(:, o)
    %                 errorbar(x(idx), y(idx), 0, y_std(idx), 'LineStyle', 'none', 'Color', colour*0.7);
    %             elseif s == idx_bottom(:, o)
    %                 errorbar(x(idx), y(idx), y_std(idx), 0,  'LineStyle', 'none', 'Color', colour*0.7);
    %             end
    %
    %             grid on;
    %             axis square;
    %             xlabel("Flexion angle");
    %             ylabel(replace(dof, '_', ' '));
    %             title(['Loading condition: ' replace(loading_condition, '_', ' ')]);
    %         end
    %         plots.(signal).(loading_condition)(s) = p;
    %
    %     end
    %     % sgtitle(replace(loading_condition, '_', ' '));
    %
    %     for o = 1:numel(DOFs)
    %         nexttile(o);
    %         has_data = ~arrayfun(@(x) isa(x, 'matlab.graphics.GraphicsPlaceholder'), plots.(signal).(loading_condition));
    %         legend(plots.(signal).(loading_condition)(has_data), state_regex_inv(states(has_data)));
    %
    %         path = fullfile(self.Root, 'results', 'plots', loading_condition);
    %         mkdir(path);
    %         exportgraphics(ax(o), fullfile(path, [DOFs{o} '.svg']) ,"ContentType", "vector")
    %     end
    % end
    %
