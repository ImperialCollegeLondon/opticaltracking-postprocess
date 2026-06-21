function res = ie(self)
    arguments
        self PathNormalisedAverage
    end

    res = self.envelope(StabilityEnvelope.InternalExternal);
end
