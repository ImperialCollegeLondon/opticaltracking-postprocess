function data = split_run(input, minima)
    flex = input.flexion;
    flexions = flex * ones(1, length(minima) + 1);
    runs = false(size(flexions));
    idx_minima = [1 minima length(flex)];
    % offset = diff(idx_minima);
    for j = 2:numel(idx_minima)
        runs(idx_minima(j-1):idx_minima(j)-1, j-1) = true;
    end
    % Separate each run into a different column, all having the same
    % length and starting at different points within that data set.
    % Then find all the valid runs – those that go towards a peak.
    split_runs = flexions .* runs;
    includes_a_peak = any(split_runs > rms(flex, "omitnan"));
    split_runs_idx = nonzero_to_one(split_runs); % Don't use logical() because it gives an error on NaN. Don't use ~isnan() because we need to maintain all the time points.

    input_arr = table2array(input);
    data_reshaped = reshape(input_arr, [height(input_arr), 1, width(input_arr)]); % time, empty, column (flexion, varus, etc). 634 x 1 x 6
    data_masked = data_reshaped .* split_runs_idx .* includes_a_peak; % 634 x 5 x 6 time, runs, column (flexion, varus, etc).
    data = data_masked(:, includes_a_peak, :);
    has_datum = any(data_masked,2);
    has_datum = has_datum(:,1);
    data = data(has_datum, :, :); % 620 x 3 x 6


    % data_arr = input as a matrix
    % no_tails = includes_a_peak;

    % valid_runs = split_runs(:, includes_a_peak);
    % valid_runs = valid_runs(any(valid_runs, 2), :); % Prune the empty rows of data, e.g., long tail or other data that doesn't tend towards a peak in flexion.

    % offset = offset(:, includes_a_peak);
   %  %% Overlap the different runs.
   %  % We need to figure out how to overlap them.
   %  % This method determines the one with the most data points (as a
   %  % percentage) up to the peak so that they all be shifted relative to
   %  % it.
   %  % Useful to do like this because if the first run starts at 5 deg
   %  % flexion and others go to 0, then we need to leave the space before
   %  % the first run.  
   %
   %  [~, idx_maxima] = max(valid_runs);
   %  peak_offsets = idx_maxima - idx_minima(:, includes_a_peak);
   %  peak_offsets_frac = peak_offsets./diff(idx_minima(1:length(peak_offsets)+1));
   %
   %  [~, idx_max_run] = max(peak_offsets_frac);
   %  idx_scaled_maxima = round(peak_offsets_frac(idx_max_run) * offset);
   %  right_shift = max(idx_scaled_maxima) - idx_maxima;
   %  for ll = 1:width(valid_runs)
   %      y(:, ll) = circshift(valid_runs(:,ll), right_shift(ll));
   %  end
   %  y = y(any(y, 2), :); %Prune empty rows
   % subplot(2,1,2); plot(y);
end

function R = nonzero_to_one(input)
    R = zeros(size(input)); 
    R(~isnan(input) & input ~= 0) = 1; 
end
