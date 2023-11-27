close all
clear all
clc
color = ["red","blue","cyan","green","black","magenta","yellow"];
markervec = ['^',"diamond",'o','x'];
anchor_configs = cell(1,1);
Nc = length(anchor_configs);
% digits(100)





%window height
wh = 1;
floor_height = 3.5;
fnvec = 1:7;
xnvec = (fnvec)*floor_height+floor_height/2;
ynvec = -10:0.01:10;
znvec = -1:-0.01:-20;
Nf = length(xnvec);

thetavec = 5:5:80;
Nt = length(thetavec);
P1 = zeros(size(thetavec));
xn  = (7)*floor_height+floor_height/2;
nodevec = [%xn,0,-5;
           xn,0,-7;
           xn,0,-15;
           xn,-2,-5;
           xn,-10,-10];
Nr = size(nodevec,1);
P2 = zeros(length(thetavec),Nr);

for ridx=1:Nr

    for tidx = 1:Nt


        xn  = nodevec(ridx,1);
        yn  = nodevec(ridx,2);
        zn  = nodevec(ridx,3);


        upper_edge_x_coord = xn + wh/2;
        lower_edge_x_coord = xn - wh/2;

        np = [xn;yn;zn];

        xa = xn-xn*cosd(thetavec(tidx));
        ya = 0;
        za = xn*sind(thetavec(tidx));

        %upper edge
        X1 = [upper_edge_x_coord;ynvec(1);0];
        X2 = [upper_edge_x_coord;ynvec(end);0];
        [Qe,~,flag,beta1,beta2] = get_qe([xa;ya;za],[xn;yn;zn],X1,X2);
        [beta1,beta2];
        gamma2 = real(beta1);
        [~,sd] = get_sd([xa;ya;za], Qe);
        [~,s2] = get_s([xn;yn;zn], Qe);
        qx2 = Qe(1);
        qy2 = Qe(2);
        qz2 = Qe(3);
        psid2 = 180 - acosd((qx2-xa)/(sqrt(za^2+(qx2-xa)^2)));
        psi2 = 360 - acosd((qx2-xn)/sqrt((qx2-xn)^2+zn^2));
        Ds2 = 1/sind(gamma2)*(1/cosd((psi2-psid2)/2) - 1/cosd((psi2+psid2)/2));


        %lower edge
        X1 = [lower_edge_x_coord;ynvec(1);0];
        X2 = [lower_edge_x_coord;ynvec(end);0];
        [Qe,~,flag,beta1,beta2] = get_qe([xa;ya;za],[xn;yn;zn],X1,X2);
        [beta1,beta2];
        gamma1 = real(beta1);
        [~,sd] = get_sd([xa;ya;za], Qe);
        [~,s1] = get_s([xn;yn;zn], Qe);
        qx1 = Qe(1);
        qy1 = Qe(2);
        qz1 = Qe(3);
        psid1 = acosd((qx1-xa)/(sqrt(za^2+(qx1-xa)^2)));
        psi1 = 180 + acosd((qx1-xn)/sqrt((qx1-xn)^2+zn^2));
        Ds1 = 1/sind(gamma1)*(1/cosd((psi1-psid1)/2) - 1/cosd((psi1+psid1)/2));

        P1(tidx) = 10*log10((1+cosd(thetavec(tidx)))/(1-cosd(thetavec(tidx))));

        P2(tidx,ridx) =10*log10((Ds2^2/Ds1^2) ...
            *(sind(gamma1)/sind(gamma2))^2 * ...
            ((qx1-xa)^2+za^2)/((qx2-xa)^2+za^2) * s1/s2);
        
    end
end
plot(thetavec,P1,'-x','MarkerSize',8,'LineWidth',1,'DisplayName',"Approx (Eq. 14)","Color",color(1))
hold on
for ridx = 1:Nr
    str="UE loc (m):["+string(nodevec(ridx,2))+", "+string(-nodevec(ridx,3))+", "+string(nodevec(ridx,1))+"]";
    plot(thetavec,P2(:,ridx),'Marker',markervec(ridx),'MarkerSize',8,'LineWidth',1, 'DisplayName',str, "Color",color(ridx+1))
    hold on
end
grid on
lgd = legend(Interpreter="latex");
fontsize(lgd,14,'points')
ylabel("Power Ratio (dB)")
xlabel("Elevation Angle \theta")
% title("Power Ratio of the Diffraction MPC")