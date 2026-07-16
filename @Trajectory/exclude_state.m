function trajectories = exclude_state(self, state)
    if isempty(self)
        trajectories = self;
        return
    end
    is_states = contains(self.states, state, "IgnoreCase", true);
    trajectories = self(~is_states);
end
