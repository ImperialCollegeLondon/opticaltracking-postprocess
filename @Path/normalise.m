function path_normalised = normalise(self, neutral, intact)
    arguments
        self Path
        neutral = "Neutral";
        intact = "Intact";
    end

    intact_neutrals = self.neutral(neutral).intact(intact);
    path_normalised = PathNormalised(self, intact_neutrals);
end
