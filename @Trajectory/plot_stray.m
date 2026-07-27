function plots = plot_stray(self)
    i = 1;
    for n = 1:numel(self)
        kinematics = self(n).Kinematics;
        signals = fields(kinematics);
        is_strays = contains(signals, 'stray');
        strays = signals(is_strays);
        
        figure
        hold on;
        for s = 1:numel(strays)
            datum = kinematics.(strays{s});
            x = datum.lateral;
            y = datum.anterior;
            z = datum.superior;
            h(i) = scatter3(x, y, z);
            i = i + 1;
        end
        hold off;
        axis equal; grid on;
        sgtitle([self(n).SpecimenName, self(n).SpecimenState, self(n).LoadingCondition]);
    end
end
