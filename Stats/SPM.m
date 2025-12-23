classdef SPM
    properties
        inference
        within_subject
        between_subject
    end
    properties(Access = private)
        States
        Specimens
        Directions
        Signals
        Data
    end

    methods
        function self = SPM(states, directions, specimens, signals, data)

            for sg = 1:numel(signals)
                signal = signals(sg);
                for d = 1:numel(directions)
                    direction = directions(d);
                    i = 1;
                    x = data.(specimens(1)).(states(1)).(direction).(signal);
                    val = nan(height(x), numel(specimens) * numel(states), width(x));

                    state_list = nan(numel(specimens) * numel(states), 1);
                    specimen_list = nan(numel(specimens) * numel(states), 1);
                    for st = 1:numel(states)
                        state = states(st);
                        for sp = 1:numel(specimens)
                            specimen = specimens(sp);
                            datum = data.(specimen).(state).(direction).(signal);
                            val(:, i, :) = table2array(datum);
                            state_list(i) = st-1;
                            specimen_list(i) = sp-1;
                            i = i + 1;
                        end
                    end

                    headers = datum.Properties.VariableNames;
                    for h = 1:numel(headers)
                        header = headers{h};
                        self.between_subject.(signal).(direction).(header) = spm1d.stats.anova1(val(:, :, h)', state_list);
                        spm = spm1d.stats.anova1rm(val(:, :, h)', state_list, specimen_list);
                        % spm = spm1d.stats.anova1(val(:, :, h)', state_list);
                        self.within_subject = spm;
                        self.inference.(signal).(direction).(header) = spm.inference(0.05);
                    end
                end
            end

            self.States = states;
            self.Specimens = specimens;
            self.Directions = directions;
            self.Signals = signals;
            self.Data = data;
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

        function o = directions(self)
            o = self.Directions;
        end

        function o = signals(self)
            o = self.Signals;
        end

        function o = data(self)
            o = self.Data;
        end


    end
end
