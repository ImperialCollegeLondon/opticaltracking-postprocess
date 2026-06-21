classdef PathTest < matlab.unittest.TestCase
    properties
        Path Path
    end

    methods (TestMethodSetup)
        function create_path(self)
            self.Path = fake_path();
        end
    end

    methods (Test)
        function test_exclude_specimen(self)
            path = self.Path;
            path.exclude_specimen("Spc")
            self.verifyEqual([path.Specimen], "Specimen3");
        end

        function test_exclude_specimen_exact(self)
            path = self.Path;
            path.exclude_specimen_exact("Spc1")
            self.verifyEqual([path.Specimen], ["Spc2", "Specimen3"]);
        end
    end
end

function p = fake_path()
    data(1:3).SpecimenName = ["Spc1", "Spc2", "Specimen3"];
    data(1:3).SpecimenState = ["Intact", "ACLD", "dMCLD"];
    % data(1:2).LoadingCondition = ["Neutral", "Anterior"];
    % data(1:3).Kinematics;
end
