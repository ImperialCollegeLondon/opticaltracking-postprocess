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
            error("This should be impossible!")
        end
        means = array2table(quantised_runs{:}, "VariableNames", headers);
        return
    end

    quantised = quantise(runs);
    mat_stack = cat(3, quantised{:});

    mat_means = mean(mat_stack, 3, "omitmissing");
    mat_means = fillmissing(mat_means, "pchip");
    means = array2table(mat_means, "VariableNames",headers);
end
