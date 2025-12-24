function [flex, ext] = split_flex_ext(self)
    directions = self.Directions;
    states = self.States;
    signals = self.Signals;
    specimens = self.Specimens;
    flex = self;
    ext = self;

    flex.Kinematics = [];
    ext.Kinematics = [];

    for sp = 1:numel(specimens)
        specimen = specimens(sp);
        for st = 1:numel(states)
            state = states(st);
            is_specimen = [self.Kinematics.(state).SpecimenName] == specimen;

            for sg = 1:numel(signals)
                signal = signals(sg);
                data = [self.Kinematics.(state).Kinematics];
                try
                    datum = data(is_specimen).(signal);
                catch
                    keyboard
                end
                headers = datum.Properties.VariableNames;
                is_flexion = strcmpi(headers, 'flexion');
                flexion = headers{is_flexion};
                [~, n] = max(flexion);

                flex.Kinematics.(specimen).(state).(signal) = datum(1:n, :);
                ext.Kinematics.(specimen).(state).(signal) = datum(n:end, :);
            end
        end
    end
end
