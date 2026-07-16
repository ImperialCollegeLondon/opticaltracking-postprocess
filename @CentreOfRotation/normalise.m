function normalised = normalise(self, widths)
    arguments
        self CentreOfRotation
        widths
    end
    if numel(self) ~= numel(widths)
        error("Centre of rotation and widths must have the same number of elements");
    end
    
    normalised = self;

    norm_intersection = ([self.intersection]'./widths)';
    norm_origin = ([self.origin]'./widths)';
   

    for n = 1:numel(normalised)
        normalised(n).intersection = norm_intersection(:, n);
        normalised(n).origin = norm_origin(:, n);
    end
end
