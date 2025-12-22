function self = add_data(self, label, data)
    headers = data.Properties.VariableNames;
    if ~any(contains(headers, 'flexion'))
        error("Data table must contain field 'flexion'.")
    end
    self.Data.(label) = data;
end
