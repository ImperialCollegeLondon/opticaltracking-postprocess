classdef Assignments
    properties
        starts_with
        ends_with
        end_range
        start_range
    end

    methods
        function self = Assignments(ends_with, starts_with, end_range, start_range)
            % Creates an assignment of how Trajectories should be split.
            % ENDS_WITH: the name of the loading condition
            % STARTS_WITH: the starting loading condition
            % END_RANGE: [start n]. Skips the last `start` elements of the list. Going backwards, assigns `n` elements to the ending list.
            %     i.e. `my_arr(end-start:-1:end-n)
            % START_RANGE: [start n]. After `start` elements, the next `n` will be assigned to the starting loading condition.
            %     i.e. `my_arr(start:n)
            arguments
                ends_with
                starts_with
                end_range = [10 30]
                start_range = [10 30]
            end

            self.ends_with = ends_with;
            self.starts_with = starts_with;
            self.end_range = end_range;
            self.start_range = start_range;
        end

        function assignment = is(self, loading_condition)
            loading_conditions = string([self.ends_with]);
            is_lc = loading_conditions == loading_condition;
            assignment = self(is_lc);
        end
    end
end
