function res = stdev(self)
    arguments
        self Path
    end

    signals = fields(self.Kinematics);
    for sg = 1:numel(signals)
        signal = signals{sg};
        
        kinematics_all = [self.Kinematics];
        kinematics = {kinematics_all.(signal)};
        is_empty = cellfun(@isempty, kinematics);
        kinematics = kinematics(~is_empty);

        if isempty(kinematics)
            continue
        end

        quantised = quantise(kinematics);
        tables = cellfun(@table2array, quantised, "UniformOutput", false);
        stacked = cat(3, tables{:});
        stacked = fillmissing(stacked, "pchip", "EndValues", "none");
        stdev = std(stacked, 0, 3);
        is_nan = all(isnan(stdev), 2);
        res.(signal) = stdev(~is_nan, :);
    end
end
