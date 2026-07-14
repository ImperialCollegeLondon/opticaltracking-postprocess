function trajectories = include_state(self, state)
    if isempty(self)
        trajectories = self;
        return
    end
    if isscalar(state)
        has_state = contains(self.states, state, "IgnoreCase", true);
        trajectories = self(has_state);
        return
    end

    is_member = ismember(self.states, state);
    trajectories = self(is_member);
end
