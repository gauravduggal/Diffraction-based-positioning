function [t1,t2] = get_t_edge2_formula(anchor,node,w)
xa = anchor(1);
ya = anchor(2);
za = anchor(3);

xn = node(1);
yn = node(2);
zn = node(3);

e = (xa+w)^2+ya^2+za^2;
d = (xn+w)^2+yn^2+zn^2;
l = sqrt((e-ya^2)*(ya-yn)^2*(d-yn^2));
% if ~isreal(l)
%     l = real(l);
%     xn = real(xn);
%     yn = real(yn);
%     zn = real(zn);
%     w = real(w);
%     d = (xn+w)^2+yn^2+zn^2;
% 
% end

% t2 = yn*(sqrt((xn+w)^2+zn^2)*sqrt((xa+w)^2+ya^2+za^2)-(xa+w)^2-ya^2-za^2)/((xn+w)^2+zn^2-(xa+w)^2-ya^2-za^2);

t2 = (ya*(d-yn^2) + l + ya^2*yn-e*yn)/(ya^2+d-yn^2-e);

t1 = (ya*(-d+yn^2) + l - ya^2*yn+e*yn)/(-ya^2-d+yn^2+e);

t2 = real(t2);
t1 = real(t1);

% a = (xn+w)^2+zn^2-(w+xa)^2-za^2;
% b = 2*(yn*((xa+w)^2+za^2)-ya*((xn+w)^2+zn^2));
% c = ya^2*(xn+w)^2-yn^2*(w+xa)^2+ya^2*zn^2-yn^2*za^2;
% 
% % t1 = (-b+sqrt(b^2-4*a*c))/(2*a);
% t1 = (-b-sqrt(b^2-4*a*c))/(2*a);

% t2 = sign(yn)/sign((xn+w)^2+zn^2-e)*(abs(yn)*sqrt((xn+w)^2+zn^2)*sqrt(e)-e*abs(yn))/abs((xn+w)^2+zn^2-e);

% t2 = (yn*sqrt((xn+w)^2+zn^2)*sqrt(e)-e*yn)/((xn+w)^2+zn^2-e);


end

