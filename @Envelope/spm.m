function spm = spm(self)
    states = self.states;
    directions = self.directions;
    specimens = self.specimens;
    signals = self.signals;
    data = self.Kinematics;
    spm = SPM(states, directions, specimens, signals, data);
end
