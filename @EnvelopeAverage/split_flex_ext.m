function [flex, ext] = split_flex_ext(self)
directions = self.Directions;
states = self.States;
signals = self.Signals;

flex = self;
ext = self;

for d = 1:numel(directions)
    direction = directions(d);
    for st = 1:numel(states)
        state = states(st);

        for sg = 1:numel(signals)
            signal = signals(sg);
            datum = self.Data.(state).(signal).(direction);
            headers = fieldnames(datum);

            for h = 1:numel(headers)
                header = headers{h};
                n = round(height(datum.(header))/2);
                flex.Data.(state).(signal).(direction).(header) = datum.(header)(1:n, :);
                ext.Data.(state).(signal).(direction).(header) = datum.(header)(n:end, :);
            end
        end
    end
end
end
