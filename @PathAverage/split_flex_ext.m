function [flex, ext] = split_flex_ext(self)
    directions = self.Directions;
    states = self.States;
    signals = self.Signals;

    flex = self;
    ext = self;

    for st = 1:numel(states)
        state = states(st);
        for sg = 1:numel(signals)
            signal = signals(sg);
            datum = self.Data.(state).(signal);
            headers = datum.Properties.VariableNames;
            is_flexion = strcmpi(headers, 'flexion');
            flexion = headers{is_flexion};
            [~, n] = max(flexion);

            flex.Data.(state).(signal).mean = datum.mean(1:n, :);
            flex.Data.(state).(signal).std = datum.std(1:n, :);
            ext.Data.(state).(signal).mean = datum.mean(n:end, :);
            ext.Data.(state).(signal).std = datum.std(n:end, :);
        end
    end
end
