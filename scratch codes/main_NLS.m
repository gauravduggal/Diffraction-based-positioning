close all
clear all
clc
color = ["red","yellow","blue","cyan","magenta","green","black"];
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


Ntrials = 1000;

NLS_MSE = zeros(Ntrials,Nc);
LLS_MSE = zeros(Ntrials,Nc);

%window height
wh = 1;
floor_height = 3.5;
fnvec = 1:7;
xnvec = (fnvec)*floor_height+floor_height/2;
ynvec = -10:0.01:10;
znvec = -1:-0.01:-20;
Nf = length(xnvec);
dims = 1:3;
parfor trial=1:Ntrials

    for cidx = 1:Nc

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
%         r = r + 0.3*randn(Na,1);
        Qevec;
        [xn;yn;zn];
        Niter = 100;

    
        %initial estimate
        estimates_vec = zeros(3,Nf);
        residuals_normvec = zeros(1,Nf);
        for fidx = 1:Nf
            yn_est = ynvec(ceil(length(ynvec)*rand(1)));
            zn_est = znvec(ceil(length(znvec)*rand(1)));
            upper_edge_x_coord = xnvec(fidx) + wh/2;
            X1 = [upper_edge_x_coord;ynvec(1);0];
            X2 = [upper_edge_x_coord;ynvec(end);0];

            np_est = [xnvec(fidx); yn_est;zn_est];
            %         np_est = np+0.1*ones(3,1);
            %         np_est = np;
            [estimates_vec(:,fidx),residuals_normvec(fidx)] = nls_3D_estimator(r,a,np_est, Niter,wh, X1,X2,np);
            %         np_est,np
        end
        [val, idx_val] = min(residuals_normvec);
        NLS_np_est = estimates_vec(:,idx_val);

%         LLS_estimates = zeros(3,Nf);
%         LLS_residuals_normvec = zeros(1,Nf);
        LLS_np_est = LLS_algo(r,a);

        if ~isnan(np_est)
            NLS_MSE(trial,cidx) = sqrt(sum((NLS_np_est(dims)-np(dims)).^2));
            %     MSE2(trial) = sqrt(sum((abs(np_est)-abs(np)).^2));
            %             [np,np_est]
            %            disp('h');
        else
            NLS_MSE(trial,cidx) = 1e10;
        end
        if ~isnan(LLS_np_est)
            LLS_MSE(trial,cidx) = sqrt(sum((LLS_np_est(dims)-np(dims)).^2));
        else
            LLS_MSE(trial,cidx) = 1e10;
        end

    end
end
% sum(isnan(MSE))/length(MSE)*100
edges = 0:0.01:11;
Nbins = length(edges)-1;
data = zeros(Nbins,Nc);
data2 = zeros(Nbins,Nc);
markervec = ['^',"diamond",'o','x'];
for cidx = 1:Nc
    h = histogram(NLS_MSE(:,cidx),edges,'EdgeColor',color(cidx),'Normalization','cdf','DisplayStyle','stairs','LineStyle','-.','LineWidth',2,'DisplayName','NLS Algo. Anchor Config: '+string(cidx));
    data(:,cidx) = h.Values';
    hold on
    h2 = histogram(LLS_MSE(:,cidx),edges,'EdgeColor',color(cidx),'Normalization','cdf','DisplayStyle','stairs','LineStyle','-.','LineWidth',2,'DisplayName','LLS Algo. Anchor Config: '+string(cidx));
    data2(:,cidx) = h2.Values';
    
    xlim([0,10])
    ylim([0,1])

end
close all
for cidx=1:Nc
    plot(edges(1:Nbins),data(:,cidx),'MarkerSize',10,'LineWidth',2,'MarkerIndices',1:100:length(edges),'Marker',markervec(cidx),'DisplayName','NLS Algo. Anchor Config: '+string(cidx));
    hold on
%     plot(edges(1:Nbins),data2(:,cidx),'MarkerSize',10,'LineWidth',2,'MarkerIndices',1:100:length(edges),'Marker',markervec(cidx),'DisplayName','LLS Algo. Anchor Config: '+string(cidx)); 
end
for cidx=1:Nc
%     plot(edges(1:Nbins),data(:,cidx),'MarkerSize',10,'LineWidth',2,'MarkerIndices',1:100:length(edges),'Marker',markervec(cidx),'DisplayName','NLS Algo. Anchor Config: '+string(cidx));
    hold on
    plot(edges(1:Nbins),data2(:,cidx),'MarkerSize',10,'LineWidth',2,'MarkerIndices',1:100:length(edges),'Marker',markervec(cidx),'DisplayName','LLS Algo. Anchor Config: '+string(cidx)); 
end

xlim([0,10])
ylim([0,1])
legend('Interpreter','latex','Location','southeast')
grid on

title("NLS dependence on Anchor Geometry",'Interpreter','latex', FontSize=14)
xlabel("RMSE (m)",'Interpreter','latex', FontSize=14)
ylabel("CDF",'Interpreter','latex', FontSize=14)