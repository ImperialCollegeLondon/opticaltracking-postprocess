classdef Trajectory < handle
    properties
        SpecimenName
        SpecimenState
        LoadingCondition
        Kinematics struct = struct()
        Transform
        Sensors
        IsOptimised
        IsRightKnee
    end

    methods 
        function self = Trajectory(name, state, loading_condition, is_optimised, is_right_knee)
            if nargin > 0
            self.SpecimenState = string(state);
            % warning("Removing the letter a from all tests. if you see this, you probably want to remove this.")
            self.SpecimenName = string(name);
            self.LoadingCondition = string(loading_condition);
            self.IsOptimised = is_optimised;
            self.IsRightKnee = is_right_knee;
            end
        end
    end

    % Convenience functions
    methods
        function out = signals(self)
            kinematics = {self.Kinematics};
            field_names = cellfun(@fields, kinematics, "UniformOutput", false);
            all_signals = vertcat(field_names{:});
            out = string(unique(all_signals));
        end
        function out = specimen(self, arg)
            if nargin > 1
                self.SpecimenName = arg;
                out = self;
            else
                out = [self.SpecimenName];
            end
        end
        function out = states(self)
            out = [self.SpecimenState];
        end
        function out = loading_conditions(self)
            out = [self.LoadingCondition];
        end
        function out = is_optimised(self)
            out = [self.IsOptimised];
        end


    end
end

