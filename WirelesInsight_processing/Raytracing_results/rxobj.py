import numpy as np

class rxobj:
    def __init__(self, rxidx, Npaths, rxpower, mean_toa, delay_spread):
        self.idx = rxidx
        self.Npaths = Npaths
        self.rxpower = rxpower
        self.mean_toa = mean_toa
        self.delay_spread = delay_spread
        self.paths = []
        self.rxpos = 0

    def add_path(self,path):
        self.paths.append(path)

    def add_rx_pos(self,pos):
        self.rxpos = pos