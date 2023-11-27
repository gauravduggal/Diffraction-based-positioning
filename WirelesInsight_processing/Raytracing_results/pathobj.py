import numpy as np

class pathobj:
    def __init__(self,idx, interactions, power, phase, toa, aoa_theta, aoa_phi, aod_theta, aod_phi):
        self.idx = idx
        self.interactions = int(interactions)
        self.power = power
        self.phase = phase
        self.toa = toa
        self.aoa_theta = aoa_theta
        self.aoa_phi = aoa_phi
        self.aod_theta = aod_theta
        self.aod_phi = aod_phi
        self.prop = ''
        self.int_pos = []

    def add_prop_mech(self,prop):
        self.prop = prop

    def add_int_pos(self,pos):
        self.int_pos.append(pos)
