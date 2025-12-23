classdef Trajectory < handle
    properties
        SpecimenName
        SpecimenState
        LoadingCondition
        Data struct = struct()
        Transform
        Sensors
        IsOptimised
        IsRightKnee
    end

    methods 
        function self = Trajectory(name, state, loading_condition, is_optimised, is_right_knee)
            self.SpecimenState = string(state);
            % warning("Removing the letter a from all tests. if you see this, you probably want to remove this.")
            self.SpecimenName = replace(string(name), 'a', '');
            self.LoadingCondition = string(loading_condition);
            self.IsOptimised = is_optimised;
            self.IsRightKnee = is_right_knee;
        end

        function out = states(self)
            out = [self.SpecimenState];
        end
    end

    % Convenience functions
    methods
        function out = signals(self)
            out = string(fields(self(1).Data));
        end
        function out = specimen(self, arg)
            if nargin > 1
                self.SpecimenName = arg;
                out = self;
            else
                out = [self.SpecimenName];
            end
        end
        function out = state(self, arg)
            if nargin > 1
                self.SpecimenState = arg;
                out = self;
            else
                out = [self.SpecimenState];
            end
        end
        function out = loading_condition(self, arg)
            if nargin > 1
                self.LoadingCondition = arg;
                out = self;
            else
                out = [self.LoadingCondition];
            end
        end
        function out = is_optimised(self, arg)
            if nargin > 1
                self.IsOptimised = arg;
                out = self;
            else
                out = [self.IsOptimised];
            end
        end

        function envelope = create_ap_envelope(self, name_native, name_neutral_flexion)
            if nargin > 1
                envelope = self.stability_envelope(["ant", "pos"], name_native, name_neutral_flexion);
            else
                envelope = self.stability_envelope(["ant", "pos"]);
            end
        end

        function envelope = create_vv_envelope(self, name_native, name_neutral_flexion)
            if nargin > 1
                envelope = self.stability_envelope(["var", "val"], name_native, name_neutral_flexion);
            else
                envelope = self.stability_envelope(["var", "val"]);
            end
        end

        function envelope = create_ie_envelope(self, name_native, name_neutral_flexion)
            if nargin > 1
                envelope = self.stability_envelope(["int", "ext"], name_native, name_neutral_flexion);
            else
                envelope = self.stability_envelope(["int", "ext"]);
            end
        end

        % Needs to be made considerably more ergonomic
        function o = flip_ie(self, specimen, state, loading_condition, signal_in)

            is_specimen = contains([self.SpecimenName], specimen, "IgnoreCase", true);
            is_state = contains([self.SpecimenState], state, "IgnoreCase", true);
            is_lc = contains([self.LoadingCondition], loading_condition, "IgnoreCase", true);
            mask = is_specimen & is_state & is_lc;

            data = [self.Data];
            signals = fieldnames(data);
            is_field = contains(signals, signal_in, "IgnoreCase", true);
            signals_valid = signals(is_field);
            for f = 1:numel(signals_valid)
                signal = signals_valid{f};
                datum = data(mask).(signal);
                datum.internal_rotation = -datum.internal_rotation;
                self(mask).Data.(signal) = datum;
            end
            
            o = self;
            
        end
    end
end

