classdef Path < IPath
    % Acts as a thin wrapper for Trajectory to provide pathing plotting instead of raw data plotting
    % properties
    %     Specimen
    %     State
    %     LoadingCondition
    %     Kinematics
    % end

    methods
        function self = Path(trajectory)
            arguments
                trajectory Trajectory = Trajectory.empty()
            end

            if nargin == 0
                return
            end
            if numel(trajectory) > 1
                n = numel(trajectory);
                self(n) = Path(trajectory(n));   % preallocate by constructing last element
                for i = 1:n-1
                    self(i) = Path(trajectory(i));
                end
                self = reshape(self, size(trajectory));
                return
            end

            self.Specimen = trajectory.SpecimenName;
            self.State = trajectory.SpecimenState;
            self.LoadingCondition = trajectory.LoadingCondition;
            self.Kinematics = trajectory.Kinematics;
        end
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
            mask = contains([o.Specimen], specimen, "IgnoreCase", true);
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

