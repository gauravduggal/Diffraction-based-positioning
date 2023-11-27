close all
clear all
clc

wh = 1;
anchor = [0;0;20];
node1 = [26.2500;6.2100;-4.6300];
dir = [1,0,0;
       0,1,0;
       0,0,1];
X1 = [node1(1)+wh/2;-10;0];
X2 = [node1(1)+wh/2;10;0];
delta = 0.1;
for idx = 1:3
node2 = node1 + delta*dir(:,idx);

[Qe1,~,~,beta1,beta2] = get_qe(anchor,node1,X1,X2);
% [beta1,beta2]
[~,sd1] = get_sd(anchor, Qe1);
[~,s1] = get_s(node1, Qe1);
f1 = sd1+s1;

[Qe2,~,~,~,~] = get_qe(anchor,node2,X1,X2);
[~,sd2] = get_sd(anchor, Qe2);
[~,s2] = get_s(node2, Qe2);
f2 = sd2+s2;

df_dnt = (f2-f1)/delta
[idx,df_dnt]
end


[df_dxn_test,df_dyn_test,df_dzn_test] = df_dn(anchor,node1,X1,X2);