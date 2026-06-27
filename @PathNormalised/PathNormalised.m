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

                % Presumably caching is quicker than rechecking every time?
                if path.Specimen ~= intact_neutral.Specimen
                    is_specimen = [intact_neutrals.Specimen] == path.Specimen;
                    intact_neutral = intact_neutrals(is_specimen);

                    if numel(intact_neutral) > 1
                        warning("Specimen %s has more than one intact-neutral path. Defaults to using the first. Check it is correct!", intact_neutral(1).Specimen);
                    end
                    intact_neutral = intact_neutral(1);
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

                    if height(curr) == 1
                        flex = round(int_neut.flexion) == round(curr.flexion);
                        quantised_current = curr;
                        quantised_native_neutral = mean(int_neut(flex, :), 1);
                    else
                        [quantised, headers] = quantise({curr, int_neut});

                        quantised_current = fillmissing(quantised{1}, "makima", "EndValue", "none");
                        quantised_current = array2table(quantised_current, "VariableNames", headers);

                        quantised_native_neutral = fillmissing(quantised{2}, "makima", "EndValue", "none");
                        quantised_native_neutral = array2table(quantised_native_neutral, "VariableNames", headers);
                    end

                    self(n).Kinematics.(signal) = quantised_current - quantised_native_neutral;
                    self(n).Kinematics.(signal).flexion = quantised_current.flexion;
                end
            end
        end
    end
end
