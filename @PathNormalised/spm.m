function spmlist = spm(self)
    arguments
        self PathNormalised
    end
    error("Needs to be reimplemented")
    flattened = self.flatten();
    spmlist = [SPM(flattened)];
end
