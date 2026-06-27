function self = smooth(self, fn)
    arguments
        self 
        fn = @(x) smoothdata(x, "gaussian", 4, "omitmissing")
    end

    signals = self.signals();
    for n = 1:numel(self)
        kinematics = self(n).Kinematics;

        for sg = 1:numel(signals)
            signal = signals(sg);

            self(n).Kinematics.(signal) = fn(kinematics.(signal));
        end
    end
end
