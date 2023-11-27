function [sd_cap,sd] = get_sd(anchor_pos, Q_E)

temp = Q_E - anchor_pos;
sd = sqrt(sum(temp.^2));

sd_cap = temp/norm(temp);

end


