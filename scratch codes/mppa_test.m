clear all
close all
clc



% a = [0,1,0;
%     -1/sqrt(2),-1/sqrt(2),0;
%     1/sqrt(2),-1/sqrt(2),0];

Na = 10;
for aidx = 1:Na
 a(1,aidx) = 10*cosd(360/Na*aidx);
 a(2,aidx) = 10*sind(360/Na*aidx);
end

% a = a';

np = [0;35];

Na = size(a,2);

r = zeros(Na,1);
for aidx = 1:Na
r(aidx) = sqrt(sum((a(:,aidx)-np).^2)); 
end
% r = r + 1;
nlos_flag=zeros(size(r));
r(1) = r(1)+10;
nlos_flag(1) = 1; 

np_start = 10*randn(2,1);

[theta,phi] = mppa_floor(np_start, 1e-4, a,r, nlos_flag);

np,theta
