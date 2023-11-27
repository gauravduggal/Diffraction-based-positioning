function [df_dxn,df_dyn,df_dzn] = df_dn(anchor,node,X1,X2)

xa = anchor(1);
ya = anchor(2);
za = anchor(3);

xn = node(1);
yn = node(2);
zn = node(3);


[Qe,~,flag,~,~] = get_qe(anchor,node,X1,X2);

qx = Qe(1);
qy = Qe(2);
%z is 0
qz = Qe(3);



OPL = sqrt((xa-qx)^2+(ya-qy)^2+za^2);
IPL = sqrt((xn-qx)^2+(yn-qy)^2+zn^2);

x1 = X1(1);
y1 = X1(2);
x2 = X2(1);
y2 = X2(2);

%z1 and z2 are 0
z1 = X1(3);
z2 = X2(3);
a = (y1-y2)^2*(- (y2 - yn)^2 - (x2 - xa)^2 - (z2 - za)^2 + (x2 - xn)^2 + (y2 - yn)^2+ (z2 - zn)^2);
b= 2*(y1-y2)*((y2-ya)*((x2-xn)^2+(z2-zn)^2)-(y2-yn)*((x2-xa)^2+(z2-za)^2));
c = (y2-ya)^2*((x2-xn)^2+(z2-zn)^2) - (y2-yn)^2*((x2-xa)^2+(z2-za)^2);





dqy_dl = y1-y2;

%
da_dxn = -2*(y1-y2)^2*(x2-xn);
da_dyn = 0;
da_dzn = 2*(y1-y2)^2*(z2-zn);


db_dxn = -4*(y1-y2)*(y2-ya)*(x2-xn);
db_dyn = 2*(y1-y2)*((x2-xa)^2+(z2-za)^2);
db_dzn = -4*(y1-y2)*(y2-ya)*(z2-zn);


dc_dxn = -2*(y2-ya)^2*(x2-xn);
dc_dyn = 2*(y2-yn)*((x2-xa)^2+(z2-za)^2);
dc_dzn = -2*(y2-ya)^2*(z2-zn);

if flag == 1
    D = real(sqrt(b^2-4*a*c));
else
    D = -real(sqrt(b^2-4*a*c));
end


%  lambda = (-b+D)/(2*a);
if abs(D)<eps
dl_dxn = (-b*da_dxn -a*db_dxn)/(4*a^2);

dl_dyn = (-b*da_dyn -a*db_dyn)/(4*a^2);

dl_dzn = (-b*da_dzn -a*db_dzn)/(4*a^2);
else
dl_dxn = (2*(-b+D)-2*a*(-db_dxn+(b*db_dxn-2*(a*dc_dxn+c*da_dxn))/D))/(4*a^2);
dl_dyn = (2*(-b+D)-2*a*(-db_dyn+(b*db_dyn-2*(a*dc_dyn+c*da_dyn))/D))/(4*a^2);
dl_dzn = (2*(-b+D)-2*a*(-db_dzn+(b*db_dzn-2*(a*dc_dzn+c*da_dzn))/D))/(4*a^2);
end

dqy_dxn = dqy_dl*dl_dxn;
dqy_dyn = dqy_dl*dl_dyn;
dqy_dzn = dqy_dl*dl_dzn;


df_dxn = (ya-qy)*dqy_dxn/OPL + (xn-qx)/IPL - (yn-qy)*dqy_dxn/IPL;
df_dyn = (-(ya-qy)*dqy_dyn)/OPL + (yn-qy)*(1-dqy_dyn)/IPL;
df_dzn =   (-(yn-qy)*dqy_dyn+zn)/IPL;


end

