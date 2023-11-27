function [s_cap,s] = get_s(node_pos, Q_E)

temp = node_pos - Q_E;

s = sqrt(sum(temp.^2));

s_cap = temp/norm(temp);

end

