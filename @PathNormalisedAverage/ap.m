function res = ap(self)
    arguments
        self PathNormalisedAverage
    end

    res = self.envelope(StabilityEnvelope.AnteriorPosterior);
end
