function plots = plot(self, model, root)
    arguments
        self CentreOfRotationAverage
        model triangulation
        root
    end
    direction = [self.direction];
    origin = [self.origin];
    intersection = [self.intersection];
    intersection_std = [self.intersection_std];
    angles_all = [self.angle];
    states_all = [self.state];
    loading_conditions_all = [self.loading_condition];

    states = unique(states_all);
    loading_conditions = unique(loading_conditions_all);
    angles = unique(angles_all);

    colours = lines(numel(states));
    linestyles = {'-', '--', ':', '-.'};
    markers = {'o', 's', '^', 'd', 'v', 'p', 'h', 'x'};

    t = [-1; 1];


    for ang = 1:numel(angles)
        angle = angles(ang);

        is_angle = angles_all == angle;

        % tiledlayout(round(numel(loading_conditions)/2), 2)
        for lc = 1:numel(loading_conditions)
            figure;
            % nexttile(lc);
            hold on; grid on;
            loading_condition = loading_conditions(lc);
            is_lc = loading_conditions_all == loading_condition;

            for st = 1:numel(states)
                state = states(st);
                if state == "Intact"
                    keyboard
                end
                is_state = states_all == state;

                % Create styles
                ls = linestyles{mod(st-1, 4) + 1};
                mk = markers{st};


                is_datum = is_angle & is_state & is_lc;
                if ~any(is_datum), continue; end

                colour = colours(st, :);



                dx = direction(1, is_datum);
                dy = direction(2, is_datum);
                x0 = origin(1, is_datum);
                y0 = origin(2, is_datum);

                x = x0 + t .* dx;
                y = y0 + t .* dy;

                plots = plot(mean(x, 2), mean(y, 2), [ls mk], 'Color', colour, 'MarkerSize', 4, 'MarkerIndices', round(linspace(1,size(x,1),5)), 'DisplayName', replace(state, '_', ' '));
                scatter(intersection(1, is_datum), intersection(2, is_datum), 40, colour, mk, 'filled', 'HandleVisibility', "off");
                errorbar(intersection(1, is_datum), intersection(2, is_datum), intersection_std(1, is_datum), 'horizontal', 'Color', colour, 'HandleVisibility', "off");
                % plots = plot(x, y, [ls mk], 'Color', colour, 'MarkerSize', 4, 'MarkerIndices', round(linspace(1,size(x,1),5)), 'HandleVisibility', "off");
                % scatter(intersection(1, is_datum), intersection(2, is_datum), 40, colour, mk, 'filled', 'DisplayName', state);
            end
            legend('Location', 'northoutside', 'NumColumns', 4);

            place_model(model);

            xlabel('\leftarrow Medial    Lateral \rightarrow')
            ylabel('\leftarrow Anterior    Posterior \rightarrow')
            axis equal; grid on;
            xlim([-2 2]);
            title(replace(loading_condition, '_', ' '));

            sgtitle(strjoin([string(angles(ang)) 'degrees'], ' '));

            path = fullfile(root, 'results', 'cor_average', string(angles(ang)));
            mkdir(path)
            filename = strjoin([loading_condition, '.png'], '');
            exportgraphics(gcf, fullfile(path, filename));
        end

    end
end


function place_model(model)
    patch('Vertices', model.Points, 'Faces', model.ConnectivityList, 'FaceColor', '#eadfc3', 'EdgeColor', 'none', 'HandleVisibility', 'off');
    zlim([-100, 5])
    camlight("right", "infinite");
    % shape = alphaShape(model.Points);
    % plot(shape, EdgeAlpha=0.1)
end
