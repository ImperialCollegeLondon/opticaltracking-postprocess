function env = envelope(self, envelopes)
    arguments
        self PathNormalisedAverage
        envelopes StabilityEnvelope
    end
    loading_conditions = [self.LoadingCondition];

    has_anterior  = contains(loading_conditions, "anterior", "IgnoreCase", true);
    has_posterior = contains(loading_conditions, "posterior", "IgnoreCase", true);

    has_varus  = contains(loading_conditions, "varus", "IgnoreCase", true);
    has_valgus = contains(loading_conditions, "valgus", "IgnoreCase", true);

    has_external = contains(loading_conditions, "external", "IgnoreCase", true);
    has_internal = contains(loading_conditions, "internal", "IgnoreCase", true);

    switch envelopes
        case StabilityEnvelope.AnteriorPosterior
            mask = (has_anterior | has_posterior) & ~(has_varus | has_valgus | has_external | has_internal);
        case StabilityEnvelope.VarusValgus
            mask = (has_varus | has_valgus) & ~(has_anterior | has_posterior | has_external | has_internal);
        case StabilityEnvelope.InternalExternal
            mask = (has_external | has_internal) & ~(has_anterior | has_posterior | has_varus | has_valgus);
    end

    env = EnvelopeAverage(self(mask), envelopes);
end
