function res = ie(self)
    arguments
        self PathNormalised
    end

    res = self.envelope(StabilityEnvelope.InternalExternal);
end
