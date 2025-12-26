function self = cp_sensor_to_kinematics(self, sensor_names)
    arguments
        self Trajectory
        sensor_names = []
    end
    for t = 1:numel(self)
        sensors = self(t).Sensors;
        if isempty(sensors)
            continue
        end

        if isempty(sensor_names)
            sensor_names_used = fields(sensors);
        else
            if ismember(fields(sensors), sensor_names)
                sensor_names_used = sensor_names;
            else
                error("%s is not valid. Options: %s", sensor_names, string(fields(sensors)));
            end
        end

        for s = 1:numel(sensor_names_used)
            sensor_name = sensor_names_used{s};
            % self(t).Kinematics.(sensor_name) = sensors.(sensor_name);
            self(t).add_data(sensor_name, sensors.(sensor_name));
        end
    end
end
