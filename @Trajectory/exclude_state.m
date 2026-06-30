function trajectories = exclude_state(self, state)
    is_states = contains(self.states, state, "IgnoreCase", true);
    trajectories = self(~is_states);
end
