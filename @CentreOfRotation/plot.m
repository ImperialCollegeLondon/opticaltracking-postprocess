function plots = plot(self)
    arguments
        self CentreOfRotation
    end
    direction = [self.direction];
    origin = [self.origin];
    intersection = [self.intersection];
    angles_all = [self.angle];
    states_all = [self.state];
    loading_conditions_all = [self.loading_condition];

    states = unique(states_all);
    loading_conditions = unique(loading_conditions_all);
    angles = unique(angles_all);

    colours = lines(numel(loading_conditions) + 2);
    linestyles = {'-', '--', ':', '-.'};
    markers = {'o', 's', '^', 'd', 'v', 'p', 'h', 'x'};

    t = [-60; 60];



    for ang = 1:numel(angles)
        angle = angles(ang);
        fig(ang) = figure; hold on;

        %% Create colour and linestyle handles
        for st = 1:numel(states)
            ls = linestyles{mod(st-1, 4) + 1};
            mk = markers{st};
            ls_handles(st) = plot(NaN, NaN, mk, Color='k', MarkerSize=4);
            % ls_handles(st) = plot(NaN, NaN, [ls mk], Color='k', MarkerSize=4);
        end

        for lc = 1:numel(loading_conditions)
            colour_handles(lc) = plot(NaN, NaN, 's', Color=colours(lc,:), MarkerFaceColor=colours(lc,:), MarkerSize=8);

        end
        %%

        sgtitle(sprintf('%.0f°', angles(ang)));
        is_angle = angles_all == angle;

        for st = 1:numel(states)
            state = states(st);
            is_state = states_all == state;

            % Create styles
            ls = linestyles{mod(st-1, 4) + 1};
            mk = markers{st};

            for lc = 1:numel(loading_conditions)
                loading_condition = loading_conditions(lc);
                is_lc = loading_conditions_all == loading_condition;

                is_datum = is_angle & is_state & is_lc;
                if ~any(is_datum), continue; end

                colour = colours(lc, :);



                dx = direction(1, is_datum);
                dy = direction(2, is_datum);
                x0 = origin(1, is_datum);
                y0 = origin(2, is_datum);

                x = x0 + t .* dx;
                y = y0 + t .* dy;

                % plots = plot(x, y, [ls mk], Color=colour, MarkerSize=4, MarkerIndices=round(linspace(1,size(x,1),5)), HandleVisibility="off");
    %             semilogx(intersection(1, is_datum), intersection(2, is_datum), mk, ...
    % Color=colour, MarkerFaceColor=colour, MarkerSize=6, ...
    % HandleVisibility='off');
                scatter(intersection(1, is_datum), intersection(2, is_datum), 40, colour, mk, 'filled', HandleVisibility="off");
            axis equal; grid on;
            end
        end

           % State/colour legend

           ax = gca;
           states_clean = replace(string(states), '_', ' ');
           leg1 = legend(ax, ls_handles, states_clean, Location='northeast');
           title(leg1, 'State');

           % LC/linestyle legend — black so colour doesn't interfere
           ax2 = axes('position',get(gca,'position'),'visible','off');
           lc_clean = replace(string(loading_conditions), '_', ' ');
           leg2 = legend(ax2, colour_handles, lc_clean, Location='northeast');
           title(leg2, 'Loading condition');

           drawnow;  % flush so Position is populated
           leg1_pos = leg1.Position;
           leg2_pos = leg2.Position;
           leg2.Position = [leg1_pos(1) - leg2_pos(3) - 0.01, ...
               leg1_pos(2) + leg1_pos(4) - leg2_pos(4), ...
               leg2_pos(3), leg2_pos(4)];

           % Return handle back to axis with all the data
           set(fig(ang), 'CurrentAxes', ax);
    end




    % [label_x, end_idx] = max(x, [], 1);
    % label_y = y(sub2ind(size(y), end_idx, 1:size(y,2)));
    % text(label_x, label_y, arrayfun(@(v) sprintf('%.0f°', v), flexion(n), UniformOutput=false));

end
