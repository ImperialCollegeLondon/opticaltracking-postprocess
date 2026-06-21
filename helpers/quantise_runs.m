function means = quantise_runs(datum)
    headers = datum.Properties.VariableNames;
    is_flexion = strcmpi(headers, 'flexion');
    flexion = headers{is_flexion};

    minima = find_minima(datum.(flexion));
    runs = split_run(datum, minima);
    if isempty(runs)
        runs = {datum};
        quantised_runs = quantise(runs);
        if numel(quantised_runs) > 1
            % No idea why this would happen. Requires proper inspection.
            keyboard
        end
        means = quantised_runs{:};
        return
    end

    quantised_runs = quantise(runs);
    mat = cellfun(@table2array, quantised_runs, "UniformOutput", false);
    mat_stack = cat(3, mat{:});

    mat_means = mean(mat_stack, 3, "omitmissing");
    tab_means = array2table(mat_means, "VariableNames",headers);

    means = fillmissing(tab_means, "pchip");
end
