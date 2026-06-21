classdef EnvelopeAverage
    properties
        paths
        envelope
    end

    methods

        function self = EnvelopeAverage(paths, envelope)
            arguments
                paths PathNormalisedAverage
                envelope StabilityEnvelope
            end

            self.paths = paths;
            self.envelope = envelope;

        end

    end

end
