function self = intraspecimen_mean(self)
    for t = 1:numel(self)
        data = self(t);
        signals = data.signals;
        for sg = 1:numel(signals)
            signal = signals(sg);
            datum = data.Kinematics.(signal);
            if isempty(datum)
                continue
            end

            self(t).Kinematics.(signal) = quantise_runs(self(t).Kinematics.(signal));
        end

        %% Sensors
        sensors = [self(t).Sensors];
        if isempty(sensors)
            continue
        end
        sensor_names = fields(sensors);
        for s = 1:numel(sensor_names)
            sensor_name = sensor_names{s};
            sensor = sensors.(sensor_name);
            self(t).Sensors.(sensor_name) = quantise_runs(sensor);
        end

    end
end

