function obj = add_sensor(obj, label, data)
    headers = data.Properties.VariableNames;
    if ~any(contains(headers, 'flexion'))
        error("Sensor table must contain field 'flexion'.")
    end
    obj.Sensors.(label) = data;
end
