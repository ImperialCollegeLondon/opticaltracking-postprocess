classdef PathNormalised < IPath
    methods
        function self = PathNormalised(paths, intact_neutrals)
            arguments
                paths Path = Path.empty()
                intact_neutrals = Path.empty()
            end

            if isempty(paths)
                return
            end

            intact_neutral = intact_neutrals(1);

            self(numel(paths)) = PathNormalised();
            
            for n = 1:numel(paths)
                path = paths(n);

                self(n).Specimen = path.Specimen;
                self(n).State = path.State;
                self(n).LoadingCondition = path.LoadingCondition;
                self(n).Root = path.Root;

                % Presumably caching is quicker than rechecking every time?
                if path.Specimen ~= intact_neutral.Specimen
                    is_specimen = [intact_neutrals.Specimen] == path.Specimen;
                    intact_neutral = intact_neutrals(is_specimen);
                end

                signals = fields(path.Kinematics);
                for sg = 1:numel(signals)
                    signal = signals{sg};
                    kinematics = path.Kinematics.(signal);
                    if isempty(kinematics)
                        continue
                    end
                    curr = quantise_runs(kinematics);
                    int_neut = quantise_runs(intact_neutral.Kinematics.(signal));

                    quantised = quantise({curr, int_neut});
                    quantised_current = fillmissing(quantised{1}, "makima", "EndValue", "none");
                    quantised_native_neutral = fillmissing(quantised{2}, "makima", "EndValue", "none");

                    self(n).Kinematics.(signal) = quantised_current - quantised_native_neutral;
                    self(n).Kinematics.(signal).flexion = quantised_current.flexion;
                end
            end
        end
    end
end
