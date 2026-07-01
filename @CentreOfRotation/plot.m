function plots = plot(self, digitisation)
    arguments
        self CentreOfRotation
        digitisation Digitisation
    end
    direction = [self.direction];
    origin = [self.origin];
    intersection = [self.intersection];
    angles_all = [self.angle];
    states_all = [self.state];
    specimens_all = [self.specimen];
    loading_conditions_all = [self.loading_condition];

    states = unique(states_all);
    loading_conditions = unique(loading_conditions_all);
    angles = unique(angles_all);
    specimens = unique(specimens_all);

    colours = lines(numel(states));
    linestyles = {'-', '--', ':', '-.'};
    markers = {'o', 's', '^', 'd', 'v', 'p', 'h', 'x'};

    t = [-60; 60];


    i = 0;
    for sp = 1:numel(specimens)
        specimen = specimens(sp);
        i = i+1;
        is_specimen = specimens_all == specimen;
        digitisation_spec = digitisation.find(string(specimen));
        for ang = 1:numel(angles)
            angle = angles(ang);

            sgtitle([specimen angles(ang)]);
            is_angle = angles_all == angle;

            for lc = 1:numel(loading_conditions)
                loading_condition = loading_conditions(lc);
                is_lc = loading_conditions_all == loading_condition;

                fig(i) = figure; hold on;

                for st = 1:numel(states)
                    state = states(st);
                    is_state = states_all == state;

                    % Create styles
                    ls = linestyles{mod(st-1, 4) + 1};
                    mk = markers{st};


                    is_datum = is_angle & is_state & is_lc & is_specimen;
                    if ~any(is_datum), continue; end

                    colour = colours(st, :);



                    dx = direction(1, is_datum);
                    dy = direction(2, is_datum);
                    x0 = origin(1, is_datum);
                    y0 = origin(2, is_datum);

                    x = x0 + t .* dx;
                    y = y0 + t .* dy;

                    plots = plot(mean(x, 2), mean(y, 2), [ls mk], 'Color', colour, 'MarkerSize', 4, 'MarkerIndices', round(linspace(1,size(x,1),5)), 'DisplayName', replace(string(state), '_', ' '));
                    scatter(intersection(1, is_datum), intersection(2, is_datum), 40, colour, mk, 'filled', 'HandleVisibility', "off");

                    axis equal;
                    % plots = plot(x, y, [ls mk], 'Color', colour, 'MarkerSize', 4, 'MarkerIndices', round(linspace(1,size(x,1),5)), 'HandleVisibility', "off");
                    % scatter(intersection(1, is_datum), intersection(2, is_datum), 40, colour, mk, 'filled', 'DisplayName', string(state));
                end
                digitisation_spec.visualise_surfaces();
                xlabel('\leftarrow Lateral    Medial \rightarrow')
                ylabel('\leftarrow Posterior    Anterior \rightarrow')
                xlim([-150 150]);
                axis equal; grid on;
                sgtitle([specimen loading_condition])
                states_clean = replace(string(states), '_', ' ');
                legend;
                keyboard
            end

            % State/colour legend


        i = i+1;
        end
        i = i+1;




        % [label_x, end_idx] = max(x, [], 1);
        % label_y = y(sub2ind(size(y), end_idx, 1:size(y,2)));
        % text(label_x, label_y, arrayfun(@(v) sprintf('%.0f°', v), flexion(n), UniformOutput=false));
    end

end
