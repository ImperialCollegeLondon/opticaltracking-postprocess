function self = smooth(self, fn)
    arguments
        self IPath
        fn = @(x) smoothdata(x, "gaussian", 4, "omitmissing")
    end

    for n = 1:numel(self)
        kinematics = self(n).Kinematics;

        signals = fields(kinematics);
        for sg = 1:numel(signals)
            signal = signals{sg};

            self(n).Kinematics.(signal) = fn(kinematics.(signal));
        end
    end
end
