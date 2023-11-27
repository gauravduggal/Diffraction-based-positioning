function [beta] = get_beta2(Qe,n,evec)
svec = n-Qe;
s = sqrt(sum(svec.^2));
e = sqrt(sum(evec.^2));
beta = acosd(dot(svec,evec)/(s*e));
end