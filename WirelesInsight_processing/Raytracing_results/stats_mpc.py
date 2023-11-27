import numpy as np
import pickle
import matplotlib.pyplot as plt
import matplotlib.colors as colors
import matplotlib.cm as cm
import os
import concurrent.futures

if not os.path.exists("output"):
    os.mkdir("output")

with open("WI", "rb") as fp:  # Unpickling
    WI = pickle.load(fp)

p_min = -140
p_max = -100


def process_rx(args):
    idrx = args[0]
    WI = args[1]
    paths = 0
    # rx_data = np.zeros((WI.Nrx, 25, 8))
    rx = WI.rxlist[idrx]
    temp = -1 * np.ones((25, 6))
    temp2 = -1 * np.ones((25, 6))
    # aoa_diff = -1*np.ones((2,))
    # toa_diff = -1*np.ones((2,))
    # power_diff = -1 * np.ones((2,))
    # aoa_non_diff = -1 * np.ones((rx.Npaths,))
    # toa_non_diff = -1 * np.ones((rx.Npaths,))
    # power_non_diff = -1 * np.ones((rx.Npaths,))
    # idx_non_diff = 0
    # idx_diff = 0
    for idp in range(0, rx.Npaths):
        path = rx.paths[idp]
        temp[idp, 0] = path.toa
        temp[idp, 1] = path.power
        temp[idp, 3] = path.aoa_theta
        temp[idp, 4] = path.aoa_phi
        temp[idp, 5] = path.interactions
        if "Tx-Rx" in path.prop :
            temp[idp, 2] = 1
            temp2[idp,2] = temp2[idp,2] + path.toa
        if "Tx-D-Rx" in path.prop:
            temp[idp, 2] = 2
        if "Tx-R-Rx" in path.prop:
            temp[idp, 2] = 3
        if "Tx-R-R-" in path.prop or "Tx-D-R-" in path.prop:
            temp[idp, 2] = 4
        # if "Tx-R-D-" in path.prop or "Tx-D-R-" in path.prop:
        #     temp[idp, 2] = 4
            # aoa_non_diff[idx_non_diff] = path.aoa_theta
            # toa_non_diff[idx_non_diff] = path.toa
            # power_non_diff[idx_non_diff] = path.power
            # idx_non_diff = idx_non_diff + 1

        paths = paths + 1

    # fig = plt.figure()
    # ax = fig.add_subplot()
    max_pow = -300
    for idp in range(0,rx.Npaths):
        if temp[idp,2] != -1:
            if temp[idp, 1]<first_arriving_multipath:
                first_arriving_multipath = temp[idp,0]

    # find first arriving multipath
    first_arriving_multipath = 1e10
    for idp in range(0,rx.Npaths):
        if temp[idp,2] != -1:
            if temp[idp, 0]<first_arriving_multipath:
                first_arriving_multipath = temp[idp,0]
    #normalize wrt to first arriving multipath
    for idp in range(0,rx.Npaths):
        if temp[idp,2] != -1:
            temp[idp,0] = temp[idp,0] - first_arriving_multipath






    return temp#[aoa_diff,aoa_non_diff,toa_diff,toa_non_diff,power_diff, power_non_diff]

def prop_to_idx(prop):
    match path.prop:
        case "Tx-Rx":
            return 0
        case "Tx-R-Rx":
            return 1
        case "Tx-D-Rx":
            return 2
        case _:
            return 3

if __name__ == '__main__':
    # multiprocessing.freeze_support()

    N_fap = np.zeros((1,4))
    N_sap = np.zeros((1,4))
    N1 = 0
    N2 = 0
    N3 = 0
    N4 = 0
    first_arriving_mpc = 1e10*np.ones((WI.Nrx,4))
    avg_toa = np.zeros((WI.Nrx, 4))
    fap_rel_pow = np.zeros((WI.Nrx, 4))

    for idrx in range(0, WI.Nrx):
        # result = process_rx([idrx, WI])
        rx = WI.rxlist[idrx]
        max_pow = -500
        for idp in range(0,rx.Npaths):
            path = rx.paths[idp]
            if path.power > max_pow:
                max_pow = path.power
        for idp in range(0,rx.Npaths):
            path = rx.paths[idp]
            if path.toa < first_arriving_mpc[idrx,0]:
                first_arriving_mpc[idrx, 0] = path.toa
                first_arriving_mpc[idrx, 1] = prop_to_idx(path.prop)
                first_arriving_mpc[idrx, 2] = max_pow
                first_arriving_mpc[idrx, 3] = path.power

    avg_toa_final = np.zeros((1,4))
    prop_mech_rx_loc = np.zeros((1,4))
    #average pl for SAP averaged over rx
    T_sav =0
    P_sav = 0
    P_fap = np.zeros((4,))

    for idrx in range(0, WI.Nrx):
        # result = process_rx([idrx, WI])
        rx = WI.rxlist[idrx]
        for idx in range(0, 4):
            if (np.count_nonzero(first_arriving_mpc[idrx,1] == idx) > 0):
                N_fap[0, idx] = N_fap[0, idx] + 1
                fap_rel_pow[0,idx] = fap_rel_pow[0,idx] + first_arriving_mpc[idrx,2]
                P_fap[idx] =  P_fap[idx] + first_arriving_mpc[idrx, 2]
        path_prop_ctr = np.zeros((1,4))
        for idp in range(0, rx.Npaths):
            path = rx.paths[idp]
            path.toa = path.toa - first_arriving_mpc[idrx, 0]
            prop_idx = prop_to_idx(path.prop)
            avg_toa[idrx, prop_idx] = avg_toa[idrx, prop_idx] + path.toa
            path_prop_ctr[0, prop_idx] = path_prop_ctr[0, prop_idx] + 1
        for idx in range(0, 4):
            #atleast one path with idx prop. mechanism
            if path_prop_ctr[0, idx]>0:
                avg_toa[idrx, idx] = np.divide(avg_toa[idrx, idx], path_prop_ctr[0, idx])
                prop_mech_rx_loc[0,idx] = prop_mech_rx_loc[0,idx] + 1
        avg_toa_final[0,:] = avg_toa_final[0,:] + avg_toa[idrx, :]
    print(N_fap * 100 / WI.Nrx)
    print(N_fap)
    print(P_fap)
    # print((N_sap/WI.Nrx) * 3e8)

    P1=0
    P2=0
    P3=0
    P4=0
    ctr1=0
    ctr2=0
    ctr3=0
    ctr4=0
    for idrx in range(0,WI.Nrx):
        if (first_arriving_mpc[idrx,1] == 0):
            P1 = P1 + first_arriving_mpc[idrx,2]-first_arriving_mpc[idrx,3]
            ctr1 = ctr1 + 1
        if (first_arriving_mpc[idrx, 1] == 1):
            P2 = P2 + first_arriving_mpc[idrx, 2] - first_arriving_mpc[idrx, 3]
            ctr2=ctr2+1
        if (first_arriving_mpc[idrx, 1] == 2):
            P3 = P3 + first_arriving_mpc[idrx, 2] - first_arriving_mpc[idrx, 3]
            ctr3=ctr3+1
        if (first_arriving_mpc[idrx, 1] == 3):
            P4 = P4 + first_arriving_mpc[idrx, 2] - first_arriving_mpc[idrx, 3]
            ctr4=ctr4+1
    print(P1 / ctr1)
    print(P2 / ctr2)
    print(P3 / ctr3)
    print(P4/ctr4)
    # print(np.divide(P_fap,N_fap)/1600)
    # plt.plot(first_arriving_mpc[:,2]-first_arriving_mpc[:,3])
    # plt.show()
    # print(3e8*avg_toa_final/prop_mech_rx_loc)
    # print(100*prop_mech_rx_loc/WI.Nrx)



    # N1 = len(np.where(path_type_flag == 1)
        # N2 = np.where(path_type_flag == 2)
        # N3 = np.where(path_type_flag == 3)
        # diff_aoa.append(result[0].flatten().tolist())
        # diff_aoa.extend(result[0][:].tolist())
        # non_diff_aoa.extend(result[1][:].tolist())
        # diff_toa.extend(result[2][:].tolist())
        # non_diff_toa.extend(result[3][:].tolist())
        # diff_power.extend(result[4][:].tolist())
        # non_diff_power.extend(result[5][:].tolist())

        # print(result[1][:])
#     diff_aoa = [val for idx,val in enumerate(diff_aoa) if val!= -1]
#     non_diff_aoa = [val for idx, val in enumerate(non_diff_aoa) if val != -1]
#     diff_toa = [val for idx, val in enumerate(diff_toa) if val != -1]
#     diff_power = [val for idx, val in enumerate(diff_power) if val != -1]
#     # print(diff_aoa)
#     bins_val = np.concatenate((np.concatenate((np.arange(50,86,0.5),np.array([87,93]))),np.arange(94,130,0.5)))
#     bins_val = np.arange(50, 130, 1)
# #     # print(bins_val)
#     plt.hist(non_diff_aoa,bins=bins_val, density=True)
#     plt.hist(diff_aoa, bins=bins_val, density=True)
#     plt.plot(diff_toa,diff_power,'.')
#     plt.show()
# #
