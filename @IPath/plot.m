function plots = plot(self, DOFs, reordered_states, root)
    arguments
        self IPath
        DOFs = []
        reordered_states = []
        root = []
    end

loading_conditions = self.loading_conditions();
states = self.states();
specimens = self.specimens();
colours = lines(numel(states));
linestyles = {'-', '--', ':', '-.'};
markers = {'o', 's', '^', 'd', 'v', 'p', 'h', 'x'};

signals = string(fields([self.Kinematics]));

if ~isempty(reordered_states)
    states = [string(reordered_states) setdiff(states, reordered_states)];
end


for sg = 1:numel(signals)
    signal = signals(sg);

    fig = [];
    i = 1;
    for sp = 1:numel(specimens)
        specimen = specimens(sp);

        is_specimen = [self.Specimen] == specimen;

        for lc = 1:numel(loading_conditions)
            loading_condition = loading_conditions(lc);

            is_lc = [self.LoadingCondition] == loading_condition;

            if numel(loading_conditions) > 1
                fig(i) = figure;
            end
            i = i + 1;
            for s = 1:numel(states)
                state = states(s);
                is_state = [self.State] == state;
                colour = colours(s, :);

                is_datum = is_specimen & is_lc & is_state;

                datum = self(is_datum);
                if isempty(datum)
                    continue
                end
                kinematics = datum.Kinematics;
                if isempty(kinematics) || isempty(kinematics.(signal))
                    continue
                end

                if ~isempty(DOFs)
                    dof = cellstr(DOFs);
                else
                    dof = kinematics.(signal).Properties.VariableNames;
                    dof = setdiff(dof, 'flexion');
                end

                ls = linestyles{mod(s-1, 4) + 1};
                mk = markers{mod(s-1, 8) + 1};

                for o = 1:numel(dof)

                    nexttile(o); hold on;
                    x = kinematics.(signal).flexion;
                    y = kinematics.(signal).(dof{o});
                    try
                    plots.(signal).(loading_condition).(specimen)(s) = plot(x, y, [ls mk], 'Color', colour, 'MarkerIndices', 1:10:numel(x));
                    catch me
                        keyboard
                    end

                    grid on;
                    axis square;
                    xlabel("Flexion angle");
                    ylabel(replace(dof{o}, '_', ' '));
                end
            end
            if ~isempty(fig)
                sgtitle([specimen loading_condition replace(signal, '_', ' ')]);
                try
                has_data = ~arrayfun(@(o) isa(o, 'matlab.graphics.GraphicsPlaceholder'), plots.(signal).(loading_condition).(specimen));
                catch
                    continue
                end
                
                lg_ax = nexttile(numel(dof) + 1);
                axis(lg_ax, 'off');

                legend(lg_ax, plots.(signal).(loading_condition).(specimen)(has_data), state_regex_inv(states(has_data)), 'Location', 'northwest');

                if ~isempty(root)
                    path = fullfile(root, 'results', 'kinematics', signal, loading_condition);
                    mkdir(path)
                    filename = strjoin([specimen, '.png'], '');
                    exportgraphics(gcf, fullfile(path, filename));
                end
            end
        end
    end
end
end
