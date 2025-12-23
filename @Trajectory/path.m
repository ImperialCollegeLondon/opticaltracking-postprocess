function path = path(self)
    names = unique([self.SpecimenName]);
    states = unique([self.SpecimenState]);
    directions = unique([self.LoadingCondition]);

    path = Path(self, names, states, directions);
end
