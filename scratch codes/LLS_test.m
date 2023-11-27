clear all
close all
clc



% a = [0,1,0;
%     -1/sqrt(2),-1/sqrt(2),0;
%     1/sqrt(2),-1/sqrt(2),0];

Na = 5;
for aidx = 1:Na
 a(1,aidx) = 10*cosd(360/Na*aidx);
 a(2,aidx) = 10*sind(360/Na*aidx);
 a(3,aidx) = aidx;
end

% a = a';

np = [27;-1;-74];

Na = size(a,2);

r = zeros(Na,1);
n = 0.1*randn(Na,1);
for aidx = 1:Na
r(aidx) = sqrt(sum((a(:,aidx)-np).^2)); 
end
% r = r + n;

np_est = LLS_algo(r,a);
[np,np_est]

