function [H] = get_H(a,node,X1,X2)
%Get diffractions point, OPL, IPL, OPL dir vec, IPL dir vec from anchor,
%node positions and window height dimensions
%note w is upper edge x coordinate (vertical coordinate)
Na = size(a,2);
H = zeros(Na,3);
for aidx = 1:Na
[df_dxn,df_dyn,df_dzn] = df_dn(a(:,aidx),node,X1,X2);
H(aidx,:) = [df_dxn,df_dyn,df_dzn];
end


end