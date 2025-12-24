classdef PathAverage
    properties
        Specimens
        States
        Directions
        Signals
        Kinematics
    end
    methods 
        function self = PathAverage(paths)
            states = paths.States;
            signals = paths.Signals;
            for st = 1:numel(states)
                state = states(st);
                data = [paths.Kinematics.(state).Kinematics];
                for sg = 1:numel(signals)
                    signal = signals(sg);
                    
                    tables = {data.(signal)};
                    tables = cellfun(@table2array, tables, "UniformOutput", false);
                    stacked = cat(3, tables{:});
                    avg = mean(stacked, 3);
                    stdev = std(stacked, 0, 3);

                    headers = data(1).(signal).Properties.VariableNames;

                    self.Kinematics.(state).(signal).mean = array2table(avg, "VariableNames", headers);
                    self.Kinematics.(state).(signal).std = array2table(stdev, "VariableNames", headers);
                end
            end
            self.Directions = paths.Directions;
            self.Signals = paths.Signals;
            self.States = paths.States;
        end
    end
end
