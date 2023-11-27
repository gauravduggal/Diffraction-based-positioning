close all
clear all
clc
color = ["red","yellow","blue","cyan","magenta","green","black"];
anchor_configs = cell(4,1);
Nc = length(anchor_configs);
load("nlos_bias_mean.mat")
load("nlos_bias_min.mat")
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


Ntrials = 10000;


IPPA_nlos_id_MSE = zeros(Ntrials,Nc);
IPPA_nlos_mean_MSE = zeros(Ntrials,Nc);
IPPA_nlos_min_MSE = zeros(Ntrials,Nc);
LLS_MSE = zeros(Ntrials,Nc);
NLS_MSE = zeros(Ntrials,Nc);

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
dims = 1:3;
parfor trial=1:Ntrials

    for cidx = anchor_config_idx

        a = anchor_config{cidx};
        Na = size(a,2);
%If you add noise and start with an estimate on the 7th floor, this will
%not converge
%         xn = 5.2500;
%         yn= -1.8900;
%         zn = -6.6500;

        
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
%         if rand(1)<0.16
%             r = r + 0.5;
%         end
        r = r + 0.3*randn(Na,1);
  
    
        %initial estimate
        
        IPPA_nlos_mean_estimates_vec = zeros(3,Nf);
        IPPA_nlos_mean_residuals_normvec = 1e10*ones(1,Nf);
        IPPA_nlos_min_estimates_vec = zeros(3,Nf);
        IPPA_nlos_min_residuals_normvec = 1e10*ones(1,Nf);
        IPPA_nlos_id_estimates_vec = zeros(3,Nf);
        IPPA_nlos_id_residuals_normvec = 1e10*ones(1,Nf);
        NLS_estimates = zeros(3,Nf);
        NLS_residuals_normvec = zeros(1,Nf);
        LLS_estimates = zeros(3,Nf);
        LLS_residuals_normvec = zeros(1,Nf);
        
        for fidx = 1:Nf
            xn_est = xnvec(fidx);
            yn_est = ynvec(ceil(length(ynvec)*rand(1)));
            zn_est = znvec(ceil(length(znvec)*rand(1)));
        
            np_start = [xn_est;yn_est;zn_est];
            [IPPA_nlos_mean_estimates_vec(:,fidx),IPPA_nlos_mean_residuals_normvec(fidx)] = ippa_floor(np_start, delta, a,r,nlos_flag, nlos_bias_mean(cidx,:,fidx),np);
            [IPPA_nlos_min_estimates_vec(:,fidx),IPPA_nlos_min_residuals_normvec(fidx)] = ippa_floor(np_start, delta, a,r,nlos_flag, nlos_bias_min(cidx,:,fidx),np);
            [IPPA_nlos_id_estimates_vec(:,fidx),IPPA_nlos_id_residuals_normvec(fidx)] = ippa_floor(np_start, delta, a,r,nlos_flag, zeros(7,1),np);        
            %NLS
            Niter = 100;
            upper_edge_x_coord = xn_est + wh/2;
            X1 = [upper_edge_x_coord;ynvec(1);0];
            X2 = [upper_edge_x_coord;ynvec(end);0];
            [NLS_estimates(:,fidx),NLS_residuals_normvec(fidx)] = nls_3D_estimator(r,a,np_start, Niter,wh, X1,X2,np);
%             [LLS_estimates(:,fidx),LLS_residuals_normvec(fidx)] = LLS_snapped_algo(r,a, xn_est);

        
        end
        [~, idx_val] = min(IPPA_nlos_mean_residuals_normvec);
        IPPA_nlos_mean_np_est = IPPA_nlos_mean_estimates_vec(:,idx_val);
        [~, idx_val] = min(IPPA_nlos_min_residuals_normvec);
        IPPA_nlos_min_np_est = IPPA_nlos_min_estimates_vec(:,idx_val);
        [~, idx_val] = min(IPPA_nlos_id_residuals_normvec);
        IPPA_nlos_id_np_est = IPPA_nlos_id_estimates_vec(:,idx_val);
        [~, idx_val] = min(NLS_residuals_normvec);
        NLS_np_est = NLS_estimates(:,idx_val);
%         [~, idx_val] = min(LLS_residuals_normvec);
%         LLS_np_est = LLS_estimates(:,idx_val);
        LLS_np_est = LLS_algo(r,a);
%         [IPPA_nlos_id_residuals_normvec;IPPA_nlos_min_residuals_normvec;IPPA_nlos_mean_residuals_normvec;NLS_residuals_normvec]
%         [LLS_np_est,IPPA_nlos_id_np_est,IPPA_nlos_min_np_est,IPPA_nlos_mean_np_est,NLS_np_est,np]
        
        if ~isnan(IPPA_nlos_id_np_est)
            IPPA_nlos_id_MSE(trial,cidx) = real(sqrt(sum((IPPA_nlos_id_np_est(dims)-np(dims)).^2)));
        else
            IPPA_nlos_id_MSE(trial,cidx) = 1e10;
        end
        if ~isnan(IPPA_nlos_mean_np_est)
            IPPA_nlos_mean_MSE(trial,cidx) = real(sqrt(sum((IPPA_nlos_mean_np_est(dims)-np(dims)).^2)));
        else
            IPPA_nlos_mean_MSE(trial,cidx) = 1e10;
        end
        if ~isnan(IPPA_nlos_min_np_est)
            IPPA_nlos_min_MSE(trial,cidx) = real(sqrt(sum((IPPA_nlos_min_np_est(dims)-np(dims)).^2)));
        else
            IPPA_nlos_min_MSE(trial,cidx) = 1e10;
        end
        if ~isnan(LLS_np_est)
            LLS_MSE(trial,cidx) = real(sqrt(sum((LLS_np_est(dims)-np(dims)).^2)));
        else
            LLS_MSE(trial,cidx) = 1e10;
        end
        if ~isnan(NLS_np_est)
            NLS_MSE(trial,cidx) = real(sqrt(sum((NLS_np_est(dims)-np(dims)).^2)));
        else
            NLS_MSE(trial,cidx) = 1e10;
        end
                
    end
end
% sum(isnan(MSE))/length(MSE)*100
edges = 0:0.01:30;
Nbins = length(edges)-1;
data = zeros(Nbins,5);
markervec = ['^',"diamond",'o','x','pentagram'];

for cidx = anchor_config_idx
    h1 = histogram(LLS_MSE(:,cidx),edges,'EdgeColor',color(cidx),'Normalization','cdf','DisplayStyle','stairs','LineStyle','-.','LineWidth',2,'DisplayName','Config: '+string(cidx));
    data(:,1) = h1.Values';
    h2 = histogram(IPPA_nlos_id_MSE(:,cidx),edges,'EdgeColor',color(cidx),'Normalization','cdf','DisplayStyle','stairs','LineStyle','-.','LineWidth',2,'DisplayName','Config: '+string(cidx));
    data(:,2) = h2.Values';
    h3 = histogram(IPPA_nlos_min_MSE(:,cidx),edges,'EdgeColor',color(cidx),'Normalization','cdf','DisplayStyle','stairs','LineStyle','-.','LineWidth',2,'DisplayName','Config: '+string(cidx));
    data(:,3) = h3.Values';
    h4 = histogram(IPPA_nlos_mean_MSE(:,cidx),edges,'EdgeColor',color(cidx),'Normalization','cdf','DisplayStyle','stairs','LineStyle','-.','LineWidth',2,'DisplayName','Config: '+string(cidx));
    data(:,4) = h4.Values';
    h5 = histogram(NLS_MSE(:,cidx),edges,'EdgeColor',color(cidx),'Normalization','cdf','DisplayStyle','stairs','LineStyle','-.','LineWidth',2,'DisplayName','Config: '+string(cidx));
    data(:,5) = h5.Values';
%     hold on
%     xlim([0,10])
%     ylim([0,1])

end
close all
algovec = ["LLS(baseline)","IPPA:NM(ID)","IPPA:NM(ID,min)","IPPA:NM(ID,mean)", "NLS"];
for algoidx=1:5
    plot(edges(1:Nbins),data(:,algoidx),'MarkerSize',10,'LineWidth',2,'MarkerIndices',1:100:length(edges),'Marker',markervec(algoidx),'DisplayName',string(algovec(algoidx)));
    hold on
end
xlim([0,10])
ylim([0,1])
legend('Interpreter','latex','Location','southeast')
grid on

% title("Dependence on Anchor Geometry",'Interpreter','latex', FontSize=14)
xlabel("RMSE (m)",'Interpreter','latex', FontSize=14)
ylabel("CDF",'Interpreter','latex', FontSize=14)