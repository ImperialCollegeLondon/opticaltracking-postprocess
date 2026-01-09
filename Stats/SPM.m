classdef SPM
    properties
        inference
        within_subject
        between_subject
    end
    properties(Access = private)
        Data
        States
        Specimens
        LoadingConditions
    end

    methods
        function self = SPM(data)
            signals = fields(data);
            for sg = 1:numel(signals)
                signal = signals{sg};

                if isempty(data.(signal))
                    continue
                end
                states = findgroups([data.(signal).state]);
                loading_conditions = findgroups([data.(signal).loading_condition]);
                specimens = findgroups([data.(signal).specimen]);

                datum = data.(signal);
                headers = datum(1).kinematics.Properties.VariableNames;
                quantised = quantise({datum.kinematics});

                h = min(cellfun(@height, quantised));
                val = nan(h, numel(unique(specimens)) * numel(unique(states)) * numel(unique(loading_conditions)), numel(headers));

                for i = 1:numel(datum)
                    arr = table2array(quantised{i});
                    val(1:size(arr,1), i, 1:size(arr, 2)) = arr;
                end

                val = fillmissing(val, "makima", "EndValues", "none");

                for h = 1:numel(headers)
                    header = headers{h};
                    self.between_subject.(signal).(header) = spm1d.stats.anova2(val(:, :, h)', states, loading_conditions);
                    spm = spm1d.stats.anova2rm(val(:, :, h)', states, loading_conditions, specimens);
                    self.inference.(signal).(header) = spm.inference(0.05);
                end
            end
            for sg = 1:numel(signals)
                signal = signals{sg};
                datum = data.(signal);
                self.Data.(signal) = data;
                self.States = categories([datum.state]);
                self.Specimens = categories([datum.specimen]);
                self.LoadingConditions = categories([datum.loading_condition]);
            end
        end

        function o = dunnett(self, control)
            if nargin < 2
                error("Missing control group. options: %s", strjoin(self.States, ', '))
            end
            if ~ismember(control, self.States)
                error("Not a valid control. options: %s", strjoin(self.States, ', '))
            end

            alpha = 0.05;
            n_tests = numel(self.States) - 1;

            p_critical = spm1d.util.p_corrected_bonf(alpha, n_tests);


            o = Dunnett(self, control, p_critical);
        end

        function o = states(self)
            o = self.States;
        end

        function o = specimens(self)
            o = self.Specimens;
        end

        function o = loading_conditions(self)
            o = self.LoadingConditions;
        end

        function o = data(self)
            o = self.data;
        end


    end
end
