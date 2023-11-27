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



nlos_bias_mean = zeros(size(nlos_bias,1),size(nlos_bias,2),size(nlos_bias,3));
nlos_bias_min = zeros(size(nlos_bias,1),size(nlos_bias,2),size(nlos_bias,3));


for cidx = 1:size(nlos_bias,1)
    a = anchor_config{cidx};
    Na = size(a,2);
    for aidx = 1:Na
        for xnidx = 1:Nf
        temp = nlos_bias(cidx,aidx,xnidx,:,:);
        nlos_bias_mean(cidx,aidx, xnidx) = mean(temp(:));
        nlos_bias_min(cidx,aidx, xnidx) = min(temp(:));
        end
    end
end
save("nlos_bias_mean.mat","nlos_bias_mean")
save("nlos_bias_min.mat","nlos_bias_min")