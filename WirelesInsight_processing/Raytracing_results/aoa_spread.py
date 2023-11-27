import numpy as np
import pickle
import matplotlib.pyplot as plt
import matplotlib.colors as colors
import matplotlib.cm as cm
import os
import concurrent.futures



if not os.path.exists("output"):
    os.mkdir("output")

with open("WI", "rb") as fp:   # Unpickling
    WI = pickle.load(fp)



p_min = -140
p_max = -100

def process_rx(args):
    idrx = args[0]
    WI = args[1]
    paths = 0
    rx_data = np.zeros((WI.Nrx,25,8))
    rx = WI.rxlist[idrx]
    temp = 0*np.ones((25,8))
    for idp in range(0,rx.Npaths):
        path = rx.paths[idp]
        # print(path.prop)
        temp[idp,0] =  path.toa
        temp[idp,1] =  path.power
        temp[idp,3] =  path.aoa_theta
        temp[idp,4] =  path.aoa_phi
        temp[idp,5:8] = np.array(path.int_pos[0])
        #flag
        if "-D-" in path.prop and path.interactions==1:
            temp[idp,2] = 1
            # diff_paths = diff_paths + 1
        else:
            temp[idp,2] = 0
        paths = paths + 1

    fig = plt.figure()
    ax = fig.add_subplot()

    # multipath time wrt to first arriving multipath 
    temp[:,0] = 3e8*(temp[:,0] - np.min(temp[:,0]))# + 1e-7)
    rx_data[idrx,:,:] = temp[:,:]
    # axs.plot(rx_data[idrx,:,0],rx_data[idrx,:,4],"r+")
    
    dif_idx = np.nonzero(temp[:,2])

    # if len(dif_idx[0]) ==0:
        # continue
    
    ax.scatter(rx_data[idrx,:,0], rx_data[idrx,:,3], s=200,  c=rx_data[idrx,:,1], norm=colors.Normalize(vmin=p_min, vmax=p_max, clip=True) ,marker='o',cmap='jet')
    ax.scatter(rx_data[idrx,dif_idx,0], rx_data[idrx,dif_idx,3],s=200,  marker='x')
    
    ax.set_xlabel('path length (m)')
    ax.set_ylabel('aoa (degrees)')
    # ax.set_zlabel('Z Label')
    ax.set_ylim(0,180)
    ax.set_xlim(-1,30)
    fig.colorbar(cm.ScalarMappable(norm=colors.Normalize(vmin=p_min, vmax=p_max) , cmap='jet'), ax=ax)
    # plt.plot(group.x, group.y, marker='o', linestyle='', markersize=12, label=name)

    ax.set_title(f'{rx.rxpos}')
    plt.tight_layout()
    print(f'{idrx}')
    plt.savefig(os.path.join("output",f'{idrx}.png'))
    plt.close(fig) 
    return 0    

if __name__ == '__main__':
    # multiprocessing.freeze_support()
    result = []
    with concurrent.futures.ProcessPoolExecutor(max_workers=30) as executor:            
        for idrx in range(0,WI.Nrx):
            result.append(executor.submit(process_rx,([idrx,WI])))
    for future in result:
        future.result()                    
