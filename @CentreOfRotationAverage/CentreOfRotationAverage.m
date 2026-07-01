classdef CentreOfRotationAverage
    properties
        loading_condition
        angle
        state
        direction
        direction_std
        origin_std
        intersection_std
    end

    methods
        function self = CentreOfRotationAverage(cor)
            self.loading_condition = loading_condition;
            self.angle = angle;
            self.state = state;
        end
    end
end
