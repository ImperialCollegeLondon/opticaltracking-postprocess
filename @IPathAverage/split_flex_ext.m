function [flex, ext] = split_flex_ext(self)
    flex = self;
    ext = self;

    [flex.Kinematics] = deal([]);
    [ext.Kinematics] = deal([]);

    for n = 1:numel(self)
        kinematics = self(n).Kinematics;
        signals = fields(kinematics);
        for sg = 1:numel(signals)
            signal = signals{sg};
            datum = kinematics.(signal);

            if isempty(datum)
                continue
            end

            [~, i] = max(datum.flexion);
            flex(n).Kinematics.(signal) = datum(1:i, :);
            flex(n).Stdev.(signal) = self(n).Stdev.(signal)(1:i, :);

            ext(n).Kinematics.(signal) = datum(i:end, :);
            ext(n).Stdev.(signal) = self(n).Stdev.(signal)(1:i, :);
        end
    end
end
