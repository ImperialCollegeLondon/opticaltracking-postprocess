function out = quantise(data)
    headers = data{1}.Properties.VariableNames;
    is_flexion = strcmpi(headers, 'flexion');
    flexion = headers{is_flexion};

    first = round(cellfun(@(x) x.(flexion)(1), data));
    last = round(cellfun(@(x) x.(flexion)(end), data));
    [peak, peak_idx] = cellfun(@(x) max(x.(flexion)), data);

    peak = round(peak);
    flexion_arc = min(first):1:max(peak);
    extension_arc = max(peak):-1:min(last);


    % idx_flex = find(strcmpi(headers, 'flexion'));
    % X = cellfun(@table2array, data, 'UniformOutput', false);
    for r = 1:numel(data)
        run = data{r};
        run_flex = run(1:peak_idx(r), :);
        run_ext = run(peak_idx(r)+1:end, :);

        out_flex = array2table(nan(numel(flexion_arc), size(run_flex, 2)), "VariableNames", headers);

        out_ext = array2table(nan(numel(extension_arc), size(run_ext, 2)), "VariableNames", headers);
        for n = 1:numel(flexion_arc)
            ang = flexion_arc(n);
            out_flex(n, :) = mean(run_flex(round(run_flex.(flexion)) == ang, :));
        end
        for n = 1:numel(extension_arc)
            ang = extension_arc(n);
            out_ext(n, :) = mean(run_ext(round(run_ext.(flexion)) == ang, :));
        end

        out{r} = [out_flex; out_ext];
    end
end
