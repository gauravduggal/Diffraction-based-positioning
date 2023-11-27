function [np_est,res] = LLS_snapped_algo(r,a, x_floor)
Na = size(a,2);
A = zeros(Na-1,2);
b = zeros(Na-1,1);
for aidx = 2:Na
    for idm = 2:3
        A(aidx-1,idm-1) = -2*(a(idm,aidx)-a(idm,1));
         
    end
    b(aidx-1) = r(aidx)^2-r(1)^2-sum(a(:,aidx).^2)+sum(a(:,1).^2);
end

np_est = [x_floor;pinv(A)*b];
res = 0;
for aidx = 1:Na
    res = res + 1/Na*sum((a(:,aidx)-np_est).^2);
end
end