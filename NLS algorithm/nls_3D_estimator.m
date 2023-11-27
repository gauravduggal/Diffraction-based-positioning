function [np_est, residual_norm2] = fn_3D_estimator(r,a,initial_estimate, Niter, wh, X1,X2,np)

np_est = initial_estimate;

Na = size(a,2);
Qe_est_vec = zeros(3,Na);
s_est_vec = zeros(1,Na);
sd_est_vec = zeros(1,Na);
for iter = 1:Niter
%     np_est(1) = np(1);
%     X1(1) = np_est(1) + wh/2;
%     X2(1) = X1(1);
    for aidx = 1:Na
            [Qe_est_vec(:,aidx),~,~,~,~] = get_qe(a(:,aidx),np_est,X1,X2);
            [~,sd_est_vec(aidx)] = get_sd(a(:,aidx), Qe_est_vec(:,aidx));
            [~,s_est_vec(aidx)] = get_s(np_est, Qe_est_vec(:,aidx));
            
    end
    H = get_H(a,np_est,X1,X2);
    H = H(:,2:3);
%     if rank(H)<3
%         disp("Stop")
%     end
    H_pseudo = pinv(H);
    %             np_est
    residual_2 = (r-transpose(s_est_vec+sd_est_vec));
    np_est(2:3) = np_est(2:3) + H_pseudo*(residual_2);
    
    
%     residual = (r-transpose(s_est_vec+sd_est_vec));
%     
%     np_est = np_est + H_pseudo*(residual);
%     iter;
    [initial_estimate,np_est,np];
    
end
residual_norm2 = sqrt(sum(residual_2.^2));
end