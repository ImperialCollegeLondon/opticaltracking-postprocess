function plots = plot_by_loading_condition(self, DOFs, reordered_states, root)
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

    kinematics_all = [self.Kinematics];
    signals = string(fields(kinematics_all));

    if ~isempty(reordered_states)
        states = [string(reordered_states) setdiff(states, reordered_states)];
    end

    for sg = 1:numel(signals)
        vals.(signals(sg)) = vertcat(kinematics_all.(signals(sg)));
        maxima.(signals(sg)) = max(vals.(signals(sg)));
        minima.(signals(sg)) = min(vals.(signals(sg)));

        if ~isempty(DOFs)
            dofs = cellstr(DOFs);
        else
            dofs.(signals(sg)) = vals.(signals(sg)).Properties.VariableNames;
            dofs.(signals(sg)) = setdiff(dofs.(signals(sg)), 'flexion');
        end
    end

    for sg = 1:numel(signals)
        signal = signals(sg);
        dof = dofs.(signal);

        fig = [];
        i = 1;

        for o = 1:numel(dof)
            for lc = 1:numel(loading_conditions)
                loading_condition = loading_conditions(lc);
                is_lc = [self.LoadingCondition] == loading_condition;

                if loading_condition ~= "SPS" | ~strcmp(dof{o}, 'varus')
                    continue
                end
                if loading_condition == "SPS" && strcmp(dof{o}, 'varus')
                    keyboard
                end

                if ~isempty(vals.(signal)) && numel(loading_conditions) > 1
                    fig(i) = figure(Name=strjoin([loading_condition ':' dof{o}], ''));
                end
                i = i + 1;

                tiledlayout(2, round(numel(specimens) + 1/2));
                hold on;

                % ── Global legend state: one handle per state ──────────────
                global_legend_handles = gobjects(numel(states), 1);
                global_legend_labels  = strings(numel(states), 1);
                % ──────────────────────────────────────────────────────────

                for sp = 1:numel(specimens)
                    specimen = specimens(sp);
                    is_specimen = [self.Specimen] == specimen;
                    nexttile(sp); hold on;

                    for s = 1:numel(states)
                        state = states(s);
                        is_state = [self.State] == state;
                        colour = colours(s, :);
                        is_datum = is_specimen & is_lc & is_state;

                        datum = self(is_datum);
                        if isempty(datum), continue; end

                        kinematics = datum.Kinematics;
                        if isempty(kinematics) || isempty(kinematics.(signal))
                            continue
                        end

                        ls = linestyles{mod(s-1, 4) + 1};
                        mk = markers{mod(s-1, 8) + 1};

                        x = kinematics.(signal).flexion;
                        y = kinematics.(signal).(dof{o});

                        h = plot(x, y, [ls mk], ...
                            'Color', colour, ...
                            'MarkerIndices', 1:10:numel(x));

                        plots.(signal).(loading_condition).(specimen)(s) = h;

                        % ── Register first valid handle for this state ─────
                        if isa(global_legend_handles(s), 'matlab.graphics.GraphicsPlaceholder') ...
                                || ~isvalid(global_legend_handles(s))
                            global_legend_handles(s) = h;
                            global_legend_labels(s)  = state_regex_inv(state);
                        end
                        % ──────────────────────────────────────────────────

                        xlim(1.1 * [minima.(signal).flexion    maxima.(signal).flexion]);
                        ylim(1.1 * [minima.(signal).(dof{o})   maxima.(signal).(dof{o})]);
                        grid on;
                        % axis square;
                        xlabel("Flexion angle");
                        ylabel(replace(dof{o}, '_', ' '));
                        title(specimen);
                    end
                end

                if ~isempty(fig)
                    sgtitle([replace(loading_condition, '_', ' ') ' ' replace(signal, '_', ' ')]);

                    % ── Use global handles for the legend ──────────────────
                    valid_mask = arrayfun(@(h) ...
                        ~isa(h, 'matlab.graphics.GraphicsPlaceholder') && isvalid(h), ...
                        global_legend_handles);

                    lg_ax = nexttile(numel(specimens) + 1);
                    axis(lg_ax, 'off');

                    legend(lg_ax, ...
                        global_legend_handles(valid_mask), ...
                        global_legend_labels(valid_mask), ...
                        'Location', 'northwest');
                    % ──────────────────────────────────────────────────────

                    if ~isempty(root)
                        path = fullfile(root, 'results', 'kinematics', signal, loading_condition);
                        mkdir(path);
                        filename = [dof{o}, '.png'];
                        exportgraphics(gcf, fullfile(path, filename));
                    end
                end
            end
        end
    end
end
