function envelope = create_stability_envelope(self, envelopes, native, neutral)
    arguments
        self
        envelopes
        native = "Native"
        neutral = "Neutral"
    end

    % names = unique([self.SpecimenName]);
    states = unique([self.SpecimenState]);

    is_native = contains([self.SpecimenState], native, "IgnoreCase", true);
    native = self(is_native);
    is_passive_flex = contains([native.LoadingCondition], neutral, "IgnoreCase", true);
    native_passive_flex = native(is_passive_flex);

    if isempty(native_passive_flex)
        error("Native Neutral flexion was not detected")
    end

    envelope = Envelope(self, envelopes, native_passive_flex, states);
end
