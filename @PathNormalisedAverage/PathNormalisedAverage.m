classdef PathNormalisedAverage < IPathAverage
    % methods
    %     function self = PathNormalisedAverage(paths)
    %         arguments
    %             paths PathNormalised = PathNormalised.empty()
    %         end
    %
    %         if isempty(paths)
    %             return
    %         end
    %
    %         loading_conditions = paths.loading_conditions();
    %         states = paths.states();
    %         signals = string(fields([paths.Kinematics]));
    %
    %         i = 1;
    %
    %         self(numel(loading_conditions) * numel(states)) = PathAverage();
    %
    %         for lc = 1:numel(loading_conditions)
    %             loading_condition = loading_conditions(lc);
    %
    %             is_lc = [paths.LoadingCondition] == loading_condition;
    %
    %             for s = 1:numel(states)
    %                 state = states(s);
    %                 is_state = [paths.State] == state;
    %
    %                 is_datum = is_lc & is_state;
    %                 if ~any(is_datum)
    %                     continue
    %                 end
    %                 specimens = [paths(is_datum)];
    %                 kinematics = [specimens.Kinematics];
    %
    %                 self(i).State = state;
    %                 self(i).LoadingCondition = loading_condition;
    %
    %                 for sg = 1:numel(signals)
    %                     signal = signals(sg);
    %
    %                     tables = {kinematics.(signal)};
    %                     is_empty = cellfun(@isempty, tables);
    %                     tables = tables(~is_empty);
    %                     if isempty(tables)
    %                         continue
    %                     end
    %
    %                     tables = quantise(tables);
    %                     headers = tables{1}.Properties.VariableNames;
    %
    %                     tables = cellfun(@table2array, tables, "UniformOutput", false);
    %                     stacked = cat(3, tables{:});
    %                     stacked = fillmissing(stacked, "pchip", "EndValues", "none");
    %                     avg = mean(stacked, 3);
    %                     stdev = std(stacked, 0, 3);
    %
    %                     self(i).Kinematics.(signal) = array2table(avg, "VariableNames", headers);
    %                     self(i).Stdev.(signal) = array2table(stdev, "VariableNames", headers);
    %
    %                 end
    %
    %                 i = i+1;
    %
    %             end
    %         end
    %
    %         self = self(1:i-1);
    %
    %     end
    % end

end
