function self = start_flexion_at(self, angle)
    arguments
        self Trajectory
        angle (1,1) {mustBeNumeric} = 0
    end
    signals = self.signals;
    for sg = 1:numel(signals)
        signal = signals(sg);
        for t = 1:numel(self)
            datum = self(t).Data.(signal);
            if isempty(datum)
                continue
            end
            headers = datum.Properties.VariableNames;
            is_flexion = strcmpi(headers, 'flexion');
            flexion = headers{is_flexion};


            delta = angle - datum.(flexion)(1);
            self(t).Data.(signal).(flexion) = datum.(flexion) + delta;
        end
    end
end
