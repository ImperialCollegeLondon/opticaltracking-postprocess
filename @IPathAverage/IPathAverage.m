classdef IPathAverage
    properties
        State
        LoadingCondition
        Kinematics
        Stdev
    end
    methods
        function self = IPathAverage(paths)
            arguments
                paths = IPath.empty()
            end

            if isempty(paths)
                return
            end

            loading_conditions = paths.loading_conditions();
            states = paths.states();
            signals = string(fields([paths.Kinematics]));

            i = 1;

            % self(numel(loading_conditions) * numel(states)) = IPathAverage();
            self(numel(loading_conditions) * numel(states)) = feval(class(self));

            for lc = 1:numel(loading_conditions)
                loading_condition = loading_conditions(lc);

                is_lc = [paths.LoadingCondition] == loading_condition;

                for s = 1:numel(states)
                    state = states(s);
                    is_state = [paths.State] == state;

                    is_datum = is_lc & is_state;
                    if ~any(is_datum)
                        continue
                    end
                    specimens = [paths(is_datum)];
                    kinematics = [specimens.Kinematics];

                    self(i).State = state;
                    self(i).LoadingCondition = loading_condition;

                    for sg = 1:numel(signals)
                        signal = signals(sg);

                        tables = {kinematics.(signal)};
                        is_empty = cellfun(@isempty, tables);
                        tables = tables(~is_empty);
                        if isempty(tables)
                            continue
                        end

                        tables = quantise(tables);
                        headers = tables{1}.Properties.VariableNames;

                        tables = cellfun(@table2array, tables, "UniformOutput", false);
                        if isscalar(numel(tables))
                            stacked = tables{:};
                        else
                            stacked = cat(3, tables{:});
                        end
                        
                        stacked = fillmissing(stacked, "pchip", "EndValues", "none");
                        avg = mean(stacked, 3);
                        stdev = std(stacked, 0, 3);

                        self(i).Kinematics.(signal) = array2table(avg, "VariableNames", headers);
                        self(i).Stdev.(signal) = array2table(stdev, "VariableNames", headers);

                    end

                    i = i+1;

                end
            end

            self = self(1:i-1);

        end
    end
    methods
        function res = neutral(self, neutral)
            arguments
                self Path
                neutral = "Neutral"
            end
            is_neutral = [self.LoadingCondition] == neutral;
            if ~any(is_neutral)
                error("No specimens have the loading condition %s. Should be one of %s", neutral, strjoin(unique([self.LoadingCondition]), ", "))
            end
            res = self(is_neutral);
        end
        function res = intact(self, intact)
            arguments
                self Path
                intact = "Intact"
            end

            is_intact = [self.State] == intact;
            if ~any(is_intact)
                error("No specimens have the state %s. Should be one of %s", intact, strjoin(unique([self.State]), ", "))
            end
            res = self(is_intact);
        end
        function o = average(self)
            o = PathAverage(self);
        end
        function o = exclude_specimens(self, specimen)
            o = self;
            mask = contains([o.Specimen], specimen);
            o = o(~mask);
        end

        function o = exclude_state(self, state)
            o = self;
            mask = contains([o.State], state);
            o = o(~mask);
        end

        function o = exclude_specimen_exact(self, specimen)
            o = self;
            mask = [o.Specimen] == specimen;
            o = o(~mask);
        end

        function res = specimens(self)
            res = unique([self.Specimen]);
        end

        function res = states(self)
            res = unique([self.State]);
        end

        function res = loading_conditions(self)
            res = unique([self.LoadingCondition]);
        end
    end
end
