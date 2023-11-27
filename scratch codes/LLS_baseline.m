close all
clear all
clc
color = ["red","yellow","blue","cyan","magenta","green","black"];
anchor_configs = cell(4,1);
Nc = length(anchor_configs);
% nlos_bias_mean = zeros(size(nlos_bias_mean));
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


Ntrials = 100000;

LLS_MSE = zeros(Ntrials,Nc);

%window height
wh = 1;
floor_height = 3.5;
fnvec = 1:7;
xnvec = (fnvec)*floor_height+floor_height/2;
ynvec = -10:0.01:10;
znvec = -1:-0.01:-20;
Nf = length(xnvec);
anchor_config_idx = 4;
delta = 1e-4;
for trial=1:Ntrials

    for cidx = anchor_config_idx

        a = anchor_config{cidx};
        Na = size(a,2);



        xn  = xnvec(ceil(length(xnvec)*rand(1)));
        zn  = znvec(ceil(length(znvec)*rand(1)));
        yn  = ynvec(ceil(length(ynvec)*rand(1)));


        upper_edge_x_coord = xn + wh/2;

        np = [xn;yn;zn];
        tvec = zeros(1,Na);
        Qevec = zeros(3,Na);
        sdvec = zeros(1,Na);
        svec = zeros(1,Na);
        r = zeros(Na,1);
        nlos_flag = 1*ones(Na,1);
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
        %
        r = r + 0.3*randn(Na,1);

        np_est = LLS_algo(r,a);

        %initial estimate

        if ~isnan(np_est)
            LLS_MSE(trial,cidx) = real(sqrt(sum((np_est-np).^2)));
        else
            LLS_MSE(trial,cidx) = 1e10;

        end
    end
end
% sum(isnan(MSE))/length(MSE)*100
edges = 0:0.01:11;
Nbins = length(edges)-1;
data = zeros(Nbins,1);
markervec = ['^',"diamond",'o','x'];

for cidx = anchor_config_idx
    h1 = histogram(LLS_MSE(:,cidx),edges,'EdgeColor',color(cidx),'Normalization','cdf','DisplayStyle','stairs','LineStyle','-.','LineWidth',2,'DisplayName','Config: '+string(cidx));
    data(:,1) = h1.Values';
    %     hold on
    %     xlim([0,10])
    %     ylim([0,1])

end
close all
algovec = ["LLS","IPPA:NM(ID,min)","IPPA:NM(ID,mean)"];
for algoidx=1
    plot(edges(1:Nbins),data(:,algoidx),'MarkerSize',10,'LineWidth',2,'MarkerIndices',1:100:length(edges),'Marker',markervec(algoidx),'DisplayName',string(algovec(algoidx)));
    hold on
end
xlim([0,10])
ylim([0,1])
legend('Interpreter','latex','Location','southeast')
grid on

title("LLS",'Interpreter','latex', FontSize=16)
xlabel("RMSE (m)",'Interpreter','latex', FontSize=16)
ylabel("CDF",'Interpreter','latex', FontSize=16)