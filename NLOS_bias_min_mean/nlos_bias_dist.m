close all
clear all
clc
load('nlos_bias.mat');
Nf = size(nlos_bias,3);
anchor_configs = cell(4,1);
Nc = length(anchor_configs);
% digits(100)

anchor_config{1} =  [0,-10,10;
    0,0,10;
    0,10,10;]';

anchor_config{2} =  [0,-10,20;
    0,0,10;
    0,10,20;]';

anchor_config{3} =  [0,-10,10;
    0,0,10;
    -10,0,10;
    0,10,10;]';

anchor_config{4} =  [0,-10,20;
    0,0,10;
    -10,0,10;
    0,10,20;]';



nlos_bias_mean = zeros(size(nlos_bias,1),size(nlos_bias,2),size(nlos_bias,3),size(nlos_bias,4)*size(nlos_bias,5));
for cidx = 1:size(nlos_bias,1)
    a = anchor_config{cidx};
    Na = size(a,2);
    for aidx = 1:Na
        for xnidx = 1:Nf
        temp = nlos_bias(cidx,aidx,xnidx,:,:);
        nlos_bias_mean(cidx,aidx, xnidx,:) = temp(:);
        end
    end
end

color = ["red","yellow","blue","cyan","magenta","green","black"];


edges = 0:0.01:11;
Nbins = length(edges)-1;
% data = zeros(4,7);
markervec = ['^',"diamond",'o','x'];
for aidx=1:4
figure;
for fidx = 1:7
    h = histogram(nlos_bias_mean(4,aidx, fidx,:),edges,'EdgeColor','none','FaceColor',color(fidx),'Normalization','pdf','DisplayName','Floor: '+string(fidx));
%     data(:,cidx) = h.Values';
    hold on
    xlim([0,9])
    ylim([0,5])
end
legend('Interpreter','latex','Location','northeast')
grid on
% title("NLOS Bias UAV-BS:"+string(aidx),'Interpreter','latex')
xlabel("meters",'Interpreter','latex')
ylabel("PDF",'Interpreter','latex')
end
% close all
% for cidx=1:Nc
%     plot(edges(1:Nbins),data(:,cidx),'MarkerSize',10,'LineWidth',2,'MarkerIndices',1:100:length(edges),'Marker',markervec(cidx),'DisplayName','Config: '+string(cidx));
%     hold on
% end
% xlim([0,10])
% ylim([0,1])
% legend('Interpreter','latex','Location','southeast')
% grid on
% 
% title("IPPA:NLOS-id: RMSE of 3D pos. estimator across 7 floors",'Interpreter','latex', FontSize=16)
% xlabel("RMSE (m)",'Interpreter','latex', FontSize=16)
% ylabel("CDF",'Interpreter','latex', FontSize=16)