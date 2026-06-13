classdef Assignments
    properties
        starts_with
        ends_with
    end

    methods
        function self = Assignments(ends_with, starts_with)
            self.ends_with = ends_with;
            self.starts_with = starts_with;
        end
    end
end
