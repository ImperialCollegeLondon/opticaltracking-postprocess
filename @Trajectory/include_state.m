function trajectories = include_state(self, state)
    if isempty(self)
        trajectories = self;
        return
    end
    has_state = contains(self.states, state, "IgnoreCase", true);
    trajectories = self(has_state);
end
