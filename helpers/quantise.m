function [out, headers] = quantise(data)
    out = cell(numel(data), 1);
    headers = data{1}.Properties.VariableNames;
    idx_flexion = find(strcmpi(headers, 'flexion'));
    X = cellfun(@table2array, data, 'UniformOutput', false);
    X = cellfun(@(c) c(all(~isnan(c), 2), :), X, 'UniformOutput', false);

    % first = round(cellfun(@(x) x(1, idx_flexion), X));
    is_empty = cellfun(@isempty, X);
    X(is_empty) = [];
    first = round(cellfun(@(x) min(x(:, idx_flexion)), X));
    last = round(cellfun(@(x) x(end, idx_flexion), X));
    [peak, peak_idx] = cellfun(@(x) max(x(:, idx_flexion)), X);
    peak = round(peak);

    flexion_arc = min(first):1:max(peak);
    if peak == last
        extension_arc = [];
    else
        extension_arc = max(peak):-1:min(last);
    end

    arc = [flexion_arc, extension_arc];

    all_groups = cellfun(@(x, pk_idx) compute_groups(x, pk_idx, idx_flexion, flexion_arc, peak), ...
                     X, num2cell(peak_idx), 'UniformOutput', false);

    n_rows = max([numel(arc) cellfun(@max, all_groups)]);
    for r = 1:numel(X)
        run = X{r};
        groups = all_groups{r};
        % quantised = accumarray(groups, (1:size(run,1))', [n_rows 1], @(x) {mean(run(x, :), 1)}, {nan(size(headers))});
        

        n_samples = size(run, 1);

        S = sparse(groups, 1:n_samples, 1, n_rows, n_samples);
        counts = full(sum(S, 2));

        quantised = (S * run) ./ counts;
        quantised(counts == 0, :) = NaN;
        
        % out{r} = array2table(vertcat(quantised{:}), "VariableNames", headers);
        % out{r} = array2table(quantised, "VariableNames", headers);
        out{r} = quantised;
    end
end

function groups = compute_groups(run, pk_idx, idx_flexion, flexion_arc, peak)
    flexion = round(run(:, idx_flexion));
    is_flexion = (1:size(run, 1))' <= pk_idx;
    groups = max(peak) - flexion + numel(flexion_arc);
    groups(1:pk_idx) = flexion(is_flexion) - min(flexion_arc) + 1;
end
