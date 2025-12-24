function self = intraspecimen_mean(self)
    signals = self.signals;
    for sg = 1:numel(signals)
        signal = signals(sg);
        for t = 1:numel(self)
            datum = self(t).Data.(signal);
            if isempty(datum)
                continue
            end
            headers = datum.Properties.VariableNames;
            is_flexion = strcmpi(headers, 'flexion');

            minima = find_minima(datum.flexion);
            runs = split_run(datum, minima);
            quantised_runs = runs;

            quantised_runs(:, :, is_flexion) = int32(quantised_runs(:, :, is_flexion));

            if ndims(quantised_runs) == 3
                quantised_means = mean_nonzero(quantised_runs, 2); % 98 x 1 x 6 => 98 x 6 and remove empty quanta
                quantised_means = squeeze(quantised_means);
            else
                quantised_means = quantised_runs;
            end

            self(t).Data.(signal) = array2table(quantised_means, "VariableNames", headers);
        end
    end
end

function M = mean_nonzero(data, D)
% `data` is (recorded data) x (quantised flexion)  x run number x direction (flexion, varus, external,lateral,anterior,superior)
%                  600      x        98            x   3        x    6
% the first 2 dimensions are a big map of how each datum should map to a quantised value
nonzero_sum = sum(data, D);
nonzero_count = sum(data ~= 0, D);
M = nonzero_sum ./ max(nonzero_count, 1); % 98 x 1 x 3 x 6
end


