function plot_centre_of_rotation(self, model_path)
    arguments
        self
        model_path = [];
    end

    datum = self(6);
flexion = datum.Kinematics.tibiofemoral.flexion - 87.7191 + 100;
cor = datum.Transform.centre_of_rotation;
direction = datum.Transform.direction;
n = false(size(flexion));
n([1 28 32 35]) = true;

cor = cor(:, :, n);
direction = direction(:, :, n)
flexion = flexion(n, :);
hold on;

for m = 1:size(cor, 3)
    cx = cor(1, 1, m);
    cy = cor(2, 1, m);
    dy = direction(1, 1, m);
    dx = direction(2, 1, m);

    if cx > 60
        t = ([-60, cx] - cx) / dx;
    elseif cx < -60
        t = ([cx, 60] - cx) / dx;
    else
        t = ([-40, cx + 10] - cx) / dx;
    end

    x_line = cx + dx * t;
    y_line = cy + dy * t;
    plot(x_line, y_line, 'r-', 'LineWidth', 1.5);
    text(x_line(1), y_line(1), sprintf('%.0f°', flexion(m)), ...
        'FontSize', 8, 'HorizontalAlignment', 'right');
end

    if isempty(model_path)
        fp_this = mfilename("fullpath");
        folder_structure = split(fp_this, filesep);
        fp_models = fullfile(strjoin(folder_structure(1:end-2), filesep), 'models');
        models = dir(fp_models);
        is_right_tibia = contains({models.name}, 'tibia', 'IgnoreCase', true) & contains({models.name}, 'right', 'IgnoreCase', true);
        fp_right_tibia = models(is_right_tibia);
        if isempty(fp_right_tibia)
            error("Missing right tibia model");
        end
        fp_right_tibia = fp_right_tibia(1);
        model_path = fullfile(fp_right_tibia.folder, fp_right_tibia.name);
    end

    tibia = stlread(model_path);
    figure;
    patch('Vertices', tibia.Points, 'Faces', tibia.ConnectivityList, 'FaceColor', '#eadfc3', 'EdgeColor', 'none');
    camlight; lighting gouraud; axis equal;
    grid on;  xlabel("x"), ylabel("y"); zlabel("z"); hold on;
    view(0, 90);


    specimens = unique([self.SpecimenName]);
    states = unique([self.SpecimenState]);

    colours = lines(numel(states));
    for sp = 1:numel(specimens)
        figure; hold on;
        specimen = specimens(sp);
        for st = 1:numel(states)
            state = states(st);
            mask = [self.SpecimenName] == specimen & [self.SpecimenState] == state;
            transforms = self(mask).Transform;
            for t = 1:numel(transforms)
                headers = fields(transforms(t));
                for h = 1:numel(headers)
                    header = headers{h};


                end
            end
        end
    end
end
