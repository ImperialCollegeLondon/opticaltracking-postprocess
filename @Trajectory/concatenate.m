function trajectory = concatenate(self)
    arguments
        self Trajectory
    end

    signals = self.signals();

    trajectory = Trajectory();
    trajectory.SpecimenName = strjoin(unique([self.SpecimenName]), ' => ');
    trajectory.SpecimenState = strjoin(unique([self.SpecimenState]), ' => ');
    trajectory.LoadingCondition = strjoin(unique([self.LoadingCondition]), ' => ');
    trajectory.IsRightKnee = any([self.IsRightKnee]);
    for sg = 1:numel(signals)
        signal = signals{sg};
        datum = [self.Kinematics];
        trajectory.Kinematics.(signal) = vertcat(datum.(signal));
    end
end
