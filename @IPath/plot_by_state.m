function plots = plot_by_state(self, DOFs, reordered_states)
    arguments
        self IPath
        DOFs = []
        reordered_states = []
    end

loading_conditions = self.loading_conditions();
states = self.states();
specimens = self.specimens();
colours = lines(numel(loading_conditions));

signals = string(fields([self.Kinematics]));

if ~isempty(reordered_states)
    states = [string(reordered_states) setdiff(states, reordered_states)];
end

fig = [];
i = 1;
for sg = 1:numel(signals)
    signal = signals(sg);

    % Think of a better solution:
    a = [self.Kinematics];
    b = {a.(signal)};
    is_empty = cellfun(@isempty, b);
    if isempty(self(~is_empty))
        continue
    end
    
    for sp = 1:numel(specimens)
        specimen = specimens(sp);

        is_specimen = [self.Specimen] == specimen;

        for s = 1:numel(states)
            state = states(s);
            is_state = [self.State] == state;

            fig(i) = figure;
            i = i + 1;
            for lc = 1:numel(loading_conditions)
                loading_condition = loading_conditions(lc);
                is_lc = [self.LoadingCondition] == loading_condition;
                colour = colours(lc, :);

                is_datum = is_specimen & is_lc & is_state;

                datum = self(is_datum);
                if isempty(datum)
                    continue
                end
                kinematics = datum.Kinematics;
                if isempty(kinematics.(signal))
                    continue
                end

                if ~isempty(DOFs)
                    dof = cellstr(DOFs);
                else
                    dof = kinematics.(signal).Properties.VariableNames;
                    dof = setdiff(dof, 'flexion');
                end

                for o = 1:numel(dof)

                    nexttile(o); hold on;
                    x = kinematics.(signal).flexion;
                    y = kinematics.(signal).(dof{o});
                    try
                    plots.(signal).(state).(specimen)(lc) = plot(x, y, 'Color', colour, 'DisplayName', loading_condition);
                    catch
                        keyboard
                    end

                    grid on;
                    axis square;
                    xlabel("Flexion angle");
                    ylabel(replace(dof{o}, '_', ' '));
                end
            end
            if ~isempty(fig)
                sgtitle([specimen state_regex_inv(state) replace(signal, '_', ' ')]);
                has_data = ~arrayfun(@(o) isa(o, 'matlab.graphics.GraphicsPlaceholder'), plots.(signal).(state).(specimen));
                
                lg_ax = nexttile(numel(dof) + 1);
                axis(lg_ax, 'off');

                legend(lg_ax, plots.(signal).(state).(specimen)(has_data), state_regex_inv(loading_conditions(has_data)), 'Location', 'northwest');
            end
        end
    end
end
end
