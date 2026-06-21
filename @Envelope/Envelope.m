classdef Envelope
    properties
        paths
        envelope
    end

    methods

        function self = Envelope(paths, envelope)
            arguments
                paths PathNormalised
                envelope StabilityEnvelope
            end

            self.paths = paths;
            self.envelope = envelope;

        end

    end

end
