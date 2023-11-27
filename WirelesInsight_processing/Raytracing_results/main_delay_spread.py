import numpy as np
import pickle
import matplotlib.pyplot as plt
import os

if not os.path.exists("output"):
    os.mkdir("output")

with open("WI", "rb") as fp:   # Unpickling
    WI = pickle.load(fp)

diff_paths_1 = 0
diff_paths = 0
ref_paths_1 = 0
ref_paths = 0
paths = 0
rx_data = np.zeros((WI.Nrx,25,5))
max_pow_per = 0
first_path_per = 0
aoa_first_path_per = 0
for idrx in range(0,WI.Nrx):
    # print(idrx)
    rx = WI.rxlist[idrx]
    temp = -1*np.ones((25,5))
    for idp in range(0,rx.Npaths):
        path = rx.paths[idp]
        # print(path.prop)
        temp[idp,0] =  path.toa
        temp[idp,1] =  path.power
        if "-D-" in path.prop and path.interactions==1:
            temp[idp,2] = 1
            diff_paths = diff_paths + 1
        else:
            temp[idp,2] = 0
        if "-R-" in path.prop and path.interactions==1:
            ref_paths = ref_paths + 1
        temp[idp,3] =  path.aoa_theta
        temp[idp,4] =  path.aoa_phi
        
        paths = paths + 1
    # fig, axs = plt.subplots(1, 1, figsize=(8, 16), dpi=100)

    # sort by min to highest toa
    temp = temp[temp[:,0].argsort()]
    # multipath time wrt to first arriving multipath 
    temp[:,0] = temp[:,0] - temp[0,0] + 1e-7
    rx_data[idrx,:,:] = temp[:,:]
    # axs.plot(rx_data[idrx,:,0],rx_data[idrx,:,1],"r+")
    
    dif_idx = np.nonzero(temp[:,2])
    # axs.plot(rx_data[idrx,dif_idx,0],rx_data[idrx,dif_idx,1],"bo")
    
    #if no diffraction paths in ground truth it is automatically counted as failure
    if len(dif_idx[0]) ==0:
        continue

    
    # print(f'{len(dif_idx)=},{len(dif_idx[0])=}')
    
    max_pow = np.max(temp[:,1])
    diff_pow = np.max(temp[dif_idx,1])
    first_path_pow = temp[0,1]
    # print(dif_idx)
    
    if diff_pow == max_pow: 
        max_pow_per = max_pow_per + 1

    if diff_pow == first_path_pow:
        first_path_per = first_path_per + 1
    
   
    # axs.set_xlim(left=0, right=4e-7)
    # axs.set_ylim(bottom=-180, top=-60)
    # plt.tight_layout()
    # plt.savefig(os.path.join("output", f'{idrx}.png'))
    print(f'rx:{idrx}')
    # plt.close() 

print(100*max_pow_per/WI.Nrx)
print(100*first_path_per/WI.Nrx)
 