function res = vv(self)
    arguments
        self PathNormalisedAverage
    end

    res = self.envelope(StabilityEnvelope.VarusValgus);
end
