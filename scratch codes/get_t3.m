function [t,Qe,sd,sd_cap,s,s_cap,beta,a,b,c] = get_t3(anchor,node,w)
%Get diffractions point, OPL, IPL, OPL dir vec, IPL dir vec from anchor,
%node positions and window height dimensions
%note w is window z coordinate i.e. changes for every floor
xa = anchor(1);
ya = anchor(2);
za = anchor(3);

xn = node(1);
yn = node(2);
zn = node(3);



d = (xn+w)^2+yn^2+zn^2;
e = (xa+w)^2+ya^2+za^2;

a = ya^2+d-yn^2-e;
b = 2*(ya*yn^2+yn*e-yn*ya^2-ya*d);
c = d*ya^2-e*yn^2;
%if quadractic is degenerate
if abs(a)>1e-6
t1 = (-b+sqrt(b^2-4*a*c))/(2*a);
t2 = (-b-sqrt(b^2-4*a*c))/(2*a);
else 
    if b~=0
    t1 = -c/b;
    t2 = t1;
%     disp('linear')
    else
        t1 = 0;
        t2 = 0;
        disp('bohoo')
    end
end
%Qe
Qe1 = [w;t1;0];
[sd_cap,sd] = get_sd(anchor, Qe1);
[s_cap,s] = get_s(node, Qe1);

if sign((ya-t1)/sd) == sign((t1-yn)/s)
    t = t1;
    Qe = Qe1;
    beta = acosd((ya-t1)/sd);
else %sign((anchor(2)-t2)/sd) == sign((t2-node(2))/s)
    t = t2;
    Qe2 = [w;t2;0];
    [sd_cap,sd] = get_sd(anchor, Qe2);
    [s_cap,s] = get_s(node, Qe2);
    beta = acosd((ya-t2)/sd);
    Qe = Qe2;
end


end