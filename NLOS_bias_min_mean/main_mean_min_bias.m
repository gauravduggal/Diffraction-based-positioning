close all
clear all
clc
%% X axis vertical axis, Y axis is along the horizontal window edge, Z axis
% is into the building floor. 


%% This code calculates the nlos bias for every floor for all the anchors
% across all floor of the building



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




%window height
wh = 1;
floor_height = 3.5;
%floor index
fnvec = 1:7;
xnvec = (fnvec)*floor_height+floor_height/2;
%coordinates along the floor
ynvec = -10:0.01:10;
znvec = -1:-0.01:-20;
Nf = length(xnvec);
Ny = length(ynvec);
Nz = length(znvec);

nlos_bias = zeros(Nc,4,Nf,length(ynvec),length(znvec));

for cidx = Nc% 1:Nc
    a = anchor_config{cidx};
    Na = size(a,2);
    for aidx =1:Na
        [cidx,aidx]
        for xnidx = 1:Nf
            for ynidx = 1:Ny
                for znidx = 1:Nz
                    A = a(:,aidx);
                    xn = xnvec(xnidx);
                    upper_edge_x_coord = xn + wh/2;
                    X1 = [upper_edge_x_coord;ynvec(1);0];
                    X2 = [upper_edge_x_coord;ynvec(end);0];
                    N = [xn;ynvec(ynidx);znvec(znidx)];
                    [Qe,~,flag,beta1,beta2] = get_qe(A,N,X1,X2);

%                     [beta1,beta2];
                    [~,sd] = get_sd(A, Qe);
                    [~,s] = get_s(N, Qe);
                    r = s+sd;
                    nlos_bias(cidx,aidx,xnidx,ynidx,znidx) = r - sqrt(sum((A-N).^2));

                end
            end
        end
    end
end

save('nlos_bias.mat',"nlos_bias",'-v7.3')