close all
clear all
clc
%% Using the diffraction law to solve for the diffraction point Qe
% Z-axis is the vertical axis, X-axis along the horizontal window edge

syms p x1 x2 xn y1 y2 yn z1 z2 zn xa ya za real

numerator_LHS = (xa-p*x1-x2+p*x2)^2;

denominator_LHS = ((xa-p*x1-x2+p*x2)^2+(ya)^2+(za-z1)^2);


numerator_RHS = (p*x1+x2-p*x2-xn)^2;

denominator_RHS = ((p*x1+x2-p*x2-xn)^2+(yn)^2+(z1-zn)^2);

% LHS = expand(expand(numerator_LHS)*expand(denominator_RHS));
% RHS = expand(expand(numerator_RHS)*expand(denominator_LHS));
LHS = numerator_LHS*denominator_RHS;
RHS = numerator_RHS*denominator_LHS;
poly = simplify(collect(LHS-RHS,p),'Steps',1000);

%p is the variable of the quadratic
eq = collect(poly,p);

