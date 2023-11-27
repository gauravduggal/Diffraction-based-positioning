close all
clear all
clc
color = ["red","yellow","blue","cyan","magenta","green","black"];
anchor_configs = cell(1,1);
% digits(100)

a =  [1,-5,20;
    -1,-5,20;
    1,5,20;
    -1,5,20;]';

Ntrials = 10000;

%window height
wh = 1;
floor_height = 3.5;
fnvec = (-10:1:10);
xnvec = (fnvec)*floor_height+floor_height/2;
ynvec = -10:0.01:10;
znvec = -1:-0.01:-20;
Nf = length(fnvec);
OFF1 = zeros(Ntrials,Nf);
OFF2 = zeros(Ntrials,Nf);

for trial=1:Ntrials

    for fidx = 1:Nf

        Na = size(a,2);


        xn  = xnvec(fidx);
        zn  = znvec(ceil(length(znvec)*rand(1)));
        yn  = ynvec(ceil(length(ynvec)*rand(1)));
        
        
        upper_edge_x_coord = xn + wh/2;

        np = [xn;yn;zn];
        tvec = zeros(1,Na);
        Qevec = zeros(3,Na);
        sdvec = zeros(1,Na);
        svec = zeros(1,Na);
        r = zeros(Na,1);
        for aidx = 1:Na
%             [t_true,Qe_true,svec(aidx),~,sdvec(aidx),~,~,a_t,b_t,c_t] = get_t3(a(:,aidx),np,upper_edge_x_coord);

            xa = a(1,aidx);
            ya = a(2,aidx);
            za = a(3,aidx);

            X1 = [upper_edge_x_coord;ynvec(1);0];


            X2 = [upper_edge_x_coord;ynvec(end);0];
            
            [Qe,~,flag,beta1,beta2] = get_qe([xa;ya;za],[xn;yn;zn],X1,X2);

            [beta1,beta2];
            Qevec(:,aidx) = Qe;
            [~,sdvec(aidx)] = get_sd([xa;ya;za], Qe);
            [~,svec(aidx)] = get_s([xn;yn;zn], Qe);
            r(aidx) = svec(aidx) + sdvec(aidx);
            
        end
%       r = r + 0.5*rand(4,1);
      OFF1(trial,fidx) = r(2)-r(1); 
      OFF2(trial,fidx) = r(4)-r(3); 
        
    end
end
% sum(isnan(MSE))/length(MSE)*100
% figure;
% for fidx = 1:Nf
%     histogram(OFF1(:,fidx),'EdgeColor','None','FaceColor',color(fidx),'Normalization','pdf','DisplayName','Floor: '+string(fidx));
%     hold on
% %     xlim([0,10])
% %     ylim([0,1])
%     xlabel("offset (m)")
%     ylabel("pdf")
% end
% title("RMSE of 3D pos. estimator across 7 floors")
% legend('Location','northwest')
% figure;
% for fidx = 1:Nf
%     histogram(OFF2(:,fidx),'EdgeColor','None','FaceColor',color(fidx),'Normalization','pdf','DisplayName','Floor: '+string(fidx));
%     hold on
% %     xlim([0,10])
% %     ylim([0,1])
%     xlabel("offset (m)")
%     ylabel("pdf")
% end
% 
% title("RMSE of 3D pos. estimator across 7 floors")
% legend('Location','northwest')

figure;
for fidx = 1:Nf
    plot(OFF1(:,fidx),OFF2(:,fidx),'o','DisplayName','Floor: '+string(fnvec(fidx)));
    hold on
%     xlim([0,10])
%     ylim([0,1])
    xlabel("offset (m)")
    ylabel("pdf")
end
legend('Location','northwest')