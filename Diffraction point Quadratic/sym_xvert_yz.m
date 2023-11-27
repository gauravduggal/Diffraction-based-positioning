close all
clear all
clc
%% Using the diffraction law to solve for the coordinates of the diffraction point Qe
% X-axis is the vertical axis, Y axis is along the horizontal window edge
syms p x1 x2 xn y1 y2 yn z1 z2 zn xa ya za real

numerator_LHS = (ya-p*y1-y2+p*y2)^2;

denominator_LHS = ((xa-p*x1-x2+p*x2)^2+(ya-p*y1-y2+p*y2)^2+(za-p*z1-z2+p*z2)^2);


numerator_RHS = (p*y1+y2-p*y2-yn)^2;

denominator_RHS = ((p*x1+x2-p*x2-xn)^2+(p*y1+y2-p*y2-yn)^2+(p*z1+z2-p*z2-zn)^2);

% LHS = expand(expand(numerator_LHS)*expand(denominator_RHS));
% RHS = expand(expand(numerator_RHS)*expand(denominator_LHS));
LHS = numerator_LHS*denominator_RHS;
RHS = numerator_RHS*denominator_LHS;
poly = simplify(collect(LHS-RHS,p),'Steps',1000);

eq = collect(poly,p);
