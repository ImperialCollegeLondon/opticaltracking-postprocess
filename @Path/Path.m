classdef Path
    properties
        Specimens
        States
        Directions
        Data
        Signals
    end

    methods
        function self = Path(data, names, states, directions)
            self.Specimens = names;
            self.States = setdiff(unique(states), ["UKA_w_pACL", "Unoptimised"]);
            self.Directions = directions;
            self.Signals = string(fieldnames([data.Data]));

            is_neutral = contains([data.LoadingCondition], "neutral", "IgnoreCase", true);
            for st = 1:numel(states)
                state = states(st);
                is_state = [data.SpecimenState] == state;
                self.Data.(state) = data(is_state & is_neutral);
            end
        end
        function o = average(self)
            o = PathAverage(self);
        end
        function o = filter_signal(self, signal)
            self.Signals = self.Signals(contains(self.Signals, signal));
            o = self;
        end
        function o = exclude_specimen(self, specimen)
            o = self;
            mask = contains(o.Specimens, specimen, "IgnoreCase", true);
            o.Specimens = o.Specimens(~mask);
        end

        function o = exclude_specimen_exact(self, specimen)
            o = self;
            specimens_remaining = setdiff(o.Specimens, specimen);
            o.Specimens = specimens_remaining;
        end

    end
end

