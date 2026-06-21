classdef StabilityEnvelope
    enumeration
        AnteriorPosterior
        VarusValgus
        InternalExternal
    end

    methods
        function txt = get_title(self)
            switch self
                case StabilityEnvelope.AnteriorPosterior
                    txt = "Anterior Posterior";
                case StabilityEnvelope.VarusValgus
                    txt = "Varus Valgus";
                case StabilityEnvelope.InternalExternal
                    txt = "Internal External";
            end
        end
    end
end
