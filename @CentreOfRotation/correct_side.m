function cor = correct_side(self)
    cor = self;

    mask = ~[cor.is_right_knee];

    for i = find(mask)
        cor(i).intersection(1) = -cor(i).intersection(1);
        cor(i).origin(1)       = -cor(i).origin(1);
        cor(i).direction(1)    = -cor(i).direction(1);
    end
end
