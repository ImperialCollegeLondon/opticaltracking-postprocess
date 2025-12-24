function [self, interp_idx] = interpolate(self, func)
    arguments
        self Trajectory
        func = @(x) fillmissing(x, "pchip");
    end
    signals = self.signals;
    for sg = 1:numel(signals)
        signal = signals(sg);
        for t = 1:numel(self)
            datum = self(t).Kinematics.(signal);
            if isempty(datum)
            interp_idx(t).(signal) = [];
            continue
            end
            headers = datum.Properties.VariableNames;
            is_flexion = strcmpi(headers, 'flexion');
            flexion = headers{is_flexion};
            flex_arc = datum.(flexion);
            vals = table2array(datum(:, ~is_flexion));

            mat = add_nan_to_gaps(flex_arc, vals);


            tab = array2table(mat, "VariableNames", headers);


            [self(t).Kinematics.(signal), idx ] = func(tab);
            interp_idx(t).(signal) = any(idx, 2);
        end
    end
end

function mat = add_nan_to_gaps(X, Y)
    dx = diff(X);
    gap = abs(dx) - 1;
    gap(gap < 0) = 0;


    n = numel(X) + sum(gap);
    x = zeros(n, 1);
    y = NaN(n, size(Y, 2));

    i = 1;
    for k = 1:numel(dx)
        x(i) = X(k);
        y(i, :) = Y(k, :);
        i = i + 1;
        if gap(k) > 0
            step = sign(dx(k));
            x(i:i+gap(k)-1) = X(k) + step*(1:gap(k));
            i = i + gap(k);
        end
    end

    x(i) = X(end);
    y(i,:) = Y(end, :);
    mat = [x y];
end
