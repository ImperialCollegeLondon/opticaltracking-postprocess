function plots = plot(self, DOFs, reordered_states)
    arguments
        self Envelope
        DOFs = []
        reordered_states = []
    end

    loading_conditions = self.paths.loading_conditions();

    for st = 1:numel(loading_conditions)
        loading_condition = loading_conditions(st);
        is_lc = [self.paths.LoadingCondition] == loading_condition;
        plots = self.paths(is_lc).plot(DOFs, reordered_states);

    end
    title_txt = self.envelope.get_title();
    sgtitle(strjoin([title_txt, "stability envelope"], " "))

end
