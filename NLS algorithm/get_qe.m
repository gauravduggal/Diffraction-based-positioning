function [Qe,lambda,flag,beta1,beta2] = get_qe(anchor,node,X1,X2)
x1 = X1(1);
y1 = X1(2);
x2 = X2(1);
y2 = X2(2);

%z1 and z2 are 0
z1 = X1(3);
z2 = X2(3);

xa = anchor(1);
ya = anchor(2);
za = anchor(3);

xn = node(1);
yn = node(2);
zn = node(3);

a = (y1-y2)^2*(- (y2 - yn)^2 - (x2 - xa)^2 - (z2 - za)^2 + (x2 - xn)^2 + (y2 - yn)^2+ (z2 - zn)^2);
b= 2*(y1-y2)*((y2-ya)*((x2-xn)^2+(z2-zn)^2)-(y2-yn)*((x2-xa)^2+(z2-za)^2));
c = (y2-ya)^2*((x2-xn)^2+(z2-zn)^2) - (y2-yn)^2*((x2-xa)^2+(z2-za)^2);

lambda1 = (-b + sqrt(b^2-4*a*c))/(2*a);
lambda2 = (-b - sqrt(b^2-4*a*c))/(2*a);

Qe1 = lambda1*X1+(1-lambda1)*X2;
beta1 = get_beta1(Qe1,[xa;ya;za],[0;1;0]);
beta2 = get_beta2(Qe1,[xn;yn;zn],[0;1;0]);
Qe2 = lambda2*X1+(1-lambda2)*X2;
beta3 = get_beta1(Qe2,[xa;ya;za],[0;1;0]);
beta4 = get_beta2(Qe2,[xn;yn;zn],[0;1;0]);

if abs(beta1-beta2)< abs(beta3-beta4)
    Qe = Qe1;
    lambda=lambda1;
    flag = 1;
else
    Qe = Qe2;
    lambda = lambda2;
    beta1 = beta3;
    beta2 = beta4;
    flag = 2;
end

lambda = real(lambda);
Qe = real(Qe);


end