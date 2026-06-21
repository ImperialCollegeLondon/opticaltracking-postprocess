function spmi = spm(self)
    arguments
        self Path
    end
    error("Needs to be reimplemented")
    flattened = self.flatten();
    spmi = SPM(flattened);
end
