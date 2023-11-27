function [beta] = get_beta1(Qe,a,evec)
svec = Qe-a;
s = sqrt(sum(svec.^2));
e = sqrt(sum(evec.^2));
beta = acosd(dot(svec,evec)/(s*e));
end