function self = end_flexion_at(self, angle)
    arguments
        self Trajectory
        angle (1,1) {mustBeNumeric} = 90
    end
    signals = self.signals;
    for sg = 1:numel(signals)
        signal = signals(sg);
        for t = 1:numel(self)
            datum = self(t).Kinematics.(signal);
            if isempty(datum)
                continue
            end
            headers = datum.Properties.VariableNames;
            is_flexion = strcmpi(headers, 'flexion');
            flexion = headers{is_flexion};


            max_angle = max(datum.(flexion));
            delta = angle - max_angle;
            self(t).Kinematics.(signal).(flexion) = datum.(flexion) + delta;
        end
    end
end
