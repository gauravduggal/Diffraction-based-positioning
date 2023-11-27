function [theta, phi] = mppa_floor(np_start, delta, a,r, nlos_flag, nlos_bias_mean,np)
theta = np_start;
phi = 0;
Na = size(a,2);
Nd = size(a,1);
itermax = 20;
idx = 0;
while true
    idx = idx + 1;
    if idx > itermax
%         abs(phi-phi_old)
%         disp('break')
        break
    end
    phi_old = phi;
    Pa = zeros(Nd,Na);
    r_test = zeros(Na,1);
    phi = 0;
    for aidx = 1:Na
        Aa = a(:,aidx);
        r_test(aidx) = sqrt(sum((theta-Aa).^2));
        Pa(:,aidx) = Aa + (r(aidx)-nlos_bias_mean(aidx))*(theta-Aa)/sqrt(sum((theta-Aa).^2));
        phi = phi + 1/Na*(r(aidx)-nlos_bias_mean(aidx)-sqrt(sum((theta-Aa).^2)))^2;
        
    end
    Np=0;
    temp = zeros(Nd,1);
%     temp(1) = np_start(1);
    for aidx = 1:Na
        % if the path is LOS or if the estimate lies outside the range
        % measurement circle, update theta in the direction of the anchor
        if ((nlos_flag(aidx)==1 && r_test(aidx) > r(aidx)-nlos_bias_mean(aidx)) || (nlos_flag(aidx)==0))
            temp(1:3) = temp(1:3) + Pa(1:3,aidx);
            Np = Np + 1;
        end
    end
    if (Np>0)
        theta(1:3) = temp(1:3)/Np;
    else
        break
    end
%     [np_start,theta,np]
%     abs(phi-phi_old)
%     idx
%     Np
    if abs(phi-phi_old) < delta
        break
    end
end


end