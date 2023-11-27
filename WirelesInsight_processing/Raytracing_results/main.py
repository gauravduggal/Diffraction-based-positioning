
from rxobj import *
from pathobj import *
from WIobj import *
import pickle


base_path = f"../data/"



# for idx in range(0,25):
#     print(WI.get_line(idx))
N_rx_line = 21
WI = WIobj(basepath= base_path)
Nrx=int(WI.get_line(N_rx_line))
WI.add_Nrx(Nrx)
print(f'Number of Receivers: {Nrx}')


## first receiver
rx_line = 22

# #first ray line
# # raylines
for idrx in range(0,Nrx):
    temp = WI.get_line_strip_space(rx_line)
    # print(f'{temp=}')
    rxidx = int(temp[0])
    Npaths = int(temp[1])
    print(f'rx id.: {rxidx} rays: {Npaths}')

    temp = WI.get_line_strip_space(rx_line+1)
    rxpower = float(temp[0])
    mean_toa = float(temp[1])
    delay_spread = float(temp[2])
    print(f'rx power: {rxpower}, mean toa: {mean_toa}, dp: {delay_spread}')
    rx = rxobj(rxidx=rxidx, Npaths=Npaths, rxpower=rxpower, mean_toa=mean_toa, delay_spread=delay_spread)
    
    raylines = 0 
    ray_id = 0
    rayline = rx_line + 2 
    for idray in range(0,Npaths):
        ray_id = idray
        temp = WI.get_line_strip_space(rayline)
        print(f'rayline {rayline+1},{temp=}')
        pidx = int(temp[0])
        n_interactions = int(temp[1])
        p_power = float(temp[2])
        p_phase = float(temp[3])
        p_toa = float(temp[4])
        p_aoa_theta = float(temp[5])
        p_aoa_phi = float(temp[6])
        p_aod_theta = float(temp[7])
        p_aod_phi = float(temp[8])            
        print(f'path idx: {pidx}, interactions: {n_interactions}')
        path = pathobj(idx=pidx,interactions=n_interactions, power=p_power, phase=p_phase, toa=p_toa, aoa_theta=p_aoa_theta, aoa_phi=p_aoa_phi, aod_theta= p_aod_theta, aod_phi=p_aod_phi )
        
        interactionline = rayline + 1 
        temp = WI.get_line_strip_space(interactionline)
        path.add_prop_mech(temp[0])

        # tx position
        interactionline = interactionline + 1 
        if idrx == 0:
            temp = WI.get_line_strip_space(interactionline)
            WI.add_tx_pos(temp)
            print(f'txpos: {temp}')



        for idz in range(0,n_interactions):
            interactionline = interactionline + 1 
            temp = WI.get_line_strip_space(interactionline)
            path.add_int_pos(temp)
            print(f'intpos: {temp}')
        
        # rx position
        interactionline = interactionline + 1 
        if idray == 0:
            temp = WI.get_line_strip_space(interactionline)
            rx.add_rx_pos(temp)
            print(f'rxpos: {temp}')
        
        rx.add_path(path)
        raylines = n_interactions + 4
        rayline = rayline + raylines
    rx_line = rayline
    WI.add_rx(rx)

 
with open("WI", "wb") as fp:   #Pickling
    pickle.dump(WI, fp)