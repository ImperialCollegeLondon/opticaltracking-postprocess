function [self, interp_idx] = interpolate(self, func)
    signals = self.signals;    
    for t = 1:numel(self)
        for sg = 1:numel(signals)
            signal = signals(sg);
            [self(t).Data.(signal), interp_idx(t).(signal)] = func(self(t).Data.(signal));
        end
    end
end
