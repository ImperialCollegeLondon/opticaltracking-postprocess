function trajectories = include_loading_condition(self, loading_condition)
    if isempty(self)
        trajectories = copy(self);
        return
    end
    if isscalar(loading_condition)
        has_lc = contains(self.loading_conditions, loading_condition, "IgnoreCase", true);
        trajectories = self(has_lc);
        return
    end

    is_member = ismember(self.loading_conditions, loading_condition);
    trajectories = self(is_member);
end
