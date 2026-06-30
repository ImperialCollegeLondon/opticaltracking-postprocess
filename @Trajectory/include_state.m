function trajectories = include_state(self, state)
    has_state = contains(self.states, state, "IgnoreCase", true);
    trajectories = self(has_state);
end
