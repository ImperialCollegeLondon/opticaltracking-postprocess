function res = ap(self)
    arguments
        self PathNormalised
    end

    res = self.envelope(StabilityEnvelope.AnteriorPosterior);
end
