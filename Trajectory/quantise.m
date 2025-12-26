function out = quantise(data)
    headers = data{1}.Properties.VariableNames;
    is_flexion = strcmpi(headers, 'flexion');
    flexion = headers{is_flexion};

    first = cellfun(@(x) x.(flexion)(1), data);
    last = cellfun(@(x) x.(flexion)(end), data);
    [peak, peak_idx] = cellfun(@(x) max(x.(flexion)), data);

    flexion_arc = min(first):1:max(peak);
    extension_arc = max(peak):-1:min(last);
    for r = 1:numel(data)
        run = data{r};
        run_flex = run(1:peak_idx(r), :);
        run_ext = run(peak_idx(r)+1:end, :);

        for n = 1:numel(flexion_arc)
            ang = flexion_arc(n);
            out_flex(n, :) = mean(run_flex(int32(run_flex.(flexion)) == int32(ang), :));
        end
        for n = 1:numel(extension_arc)
            ang = extension_arc(n);
            out_ext(n, :) = mean(run_ext(int32(run_ext.(flexion)) == int32(ang), :));
        end

        out{r} = [out_flex; out_ext];
    end
end
