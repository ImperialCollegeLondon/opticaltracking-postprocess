function res = vv(self)
    arguments
        self PathNormalised
    end

    res = self.envelope(StabilityEnvelope.VarusValgus);
end
