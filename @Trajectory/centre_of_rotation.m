% function cor = centre_of_rotation(self, angles, intact)
%     % looks for folder names (states) that include COR_STRING to create a
%     % piecewise centre of rotation. "COR" by default.
%     arguments
%         self Trajectory
%         angles
%         intact string = "Intact"
%     end
%
%     if numel(angles) ~= numel(self)
%         error("The number of Trajectory must match the number of angles")
%     end
%
%
%     is_intact = self.states == intact;
%     if ~any(is_intact)
%         error("No specimen with %s state", intact);
%     end
%     loading_conditions_all = self.loading_conditions;
%     loading_conditions = unique(loading_conditions_all);
%     specimens_all = self.specimens;
%     specimens = unique(specimens_all);
%     unique_angles = unique(angles);
%
%
%     for a = 1:numel(unique_angles)
%         angle = unique_angles(a);
%         is_angle = angles == angle;
%         for sp = 1:numel(specimens)
%             is_specimen = specimens_all == specimens(sp);
%             for lc = 1:numel(loading_conditions)
%                 is_lc = loading_conditions_all == loading_conditions(lc);
%
%                 mask = is_angle & is_specimen & is_lc & is_intact;
%
%                 transforms_intact = [self(mask).Transform];
%                 fTts_intact = {transforms_intact.fTts};
%                 is_empty = cellfun(@isempty, fTts_intact);
%                 if all(is_empty)
%                     error("Missing implementation for when the tibial surface was not digitised. Will use digitised tibia eventually")
%                 end
%                 fTts_curr = mean(cat(3, fTts_intact{:}), 3, "omitmissing");
%                 oTts(:, :, sp, a, lc) = fTts_curr; % oTf is eye(4)
%             end
%
%         end
%     end
%
%     cor(numel(self)) = CentreOfRotation;
%     for n = 1:numel(self)
%         is_specimen = self(n).specimens == specimens;
%         is_angle = angles(n) == unique_angles;
%         is_lc = self(n).loading_conditions == loading_conditions;
%         if ~any(is_specimen)
%             warning("No intact neutral for specimen %s. Skipping", self(n).specimens);
%         end
%
%         fTts = self(n).Transform.fTts;
%         fTts_mean = mean(fTts, 3, "omitmissing");
%         % Missing 
%         if isempty(fTts_mean) || all(isnan(fTts_mean), "all")
%             oTf = [];
%         else
%             oTf = oTts(:, :, is_specimen, is_angle, is_lc) / fTts_mean;
%         end
%         % if self(n).loading_conditions == neutral && self(n).states == intact
%         %     error("This is supposed to be an identity matrix")
%         % end
%         cor(n) = CentreOfRotation(self(n).specimens, self(n).loading_conditions, angles(n), self(n).states, oTf);
%     end
% end

% Uses intact neutral for every rotation
function cor = centre_of_rotation(self, angles, intact, neutral)
    % looks for folder names (states) that include COR_STRING to create a
    % piecewise centre of rotation. "COR" by default.
    arguments
        self Trajectory
        angles
        intact string = "Intact"
        neutral string = "Neutral"
    end

    if numel(angles) ~= numel(self)
        error("The number of Trajectory must match the number of angles")
    end


    is_intact = self.states == intact;
    is_neutral = self.loading_conditions == neutral;

    if ~any(is_intact)
        error("%s is not a state that exists. Use one of: %s", intact, strjoin(unique(self.states), ', '));
    end
    if ~any(is_neutral)
        error("%s is not a state that exists. Use one of: %s", neutral, strjoin(unique(self.loading_conditions), ', '));
    end


    intacts_neutrals = self(is_intact & is_neutral);
    specimens = unique(self.specimens);
    unique_angles = unique(angles);

    for a = 1:numel(unique_angles)
        angle = unique_angles(a);
        angles_intact_neutral  = angles(is_intact & is_neutral);
        is_angle = angles_intact_neutral == angle;
        for sp = 1:numel(specimens)
            is_specimen = intacts_neutrals.specimens == specimens(sp);
            mask = is_angle & is_specimen;
            transforms_intact_neutral = [intacts_neutrals(mask).Transform];
            fTts_intact = {transforms_intact_neutral.fTts};
            is_empty = cellfun(@isempty, fTts_intact);

            if all(is_empty)
                error("Missing implementation for when the tibial surface was not digitised. Will use digitised tibia")
            end
            fTts_curr = mean(cat(3, fTts_intact{:}), 3, "omitmissing");
            oTts(:, :, sp, a) = fTts_curr; % oTf is eye(4)
        end
    end

    cor(numel(self)) = CentreOfRotation;
    for n = 1:numel(self)
        is_specimen = self(n).specimens == specimens;
        is_angle = angles(n) == unique_angles;
        if ~any(is_specimen)
            warning("No intact neutral for specimen %s. Skipping", self(n).specimens);
        end

        fTts = self(n).Transform.fTts;
        fTts_mean = mean(fTts, 3, "omitmissing");
        tsTf_mean = pageinv(fTts_mean);
        % Missing 
        if isempty(tsTf_mean)
            oTf = [];
        else
            oTf = oTts(:, :, is_specimen, is_angle) * tsTf_mean;
        end
        % if self(n).loading_conditions == neutral && self(n).states == intact
        %     error("This is supposed to be an identity matrix")
        % end
        cor(n) = CentreOfRotation(self(n).specimens, self(n).loading_conditions, angles(n), self(n).states, oTf);
    end
end
