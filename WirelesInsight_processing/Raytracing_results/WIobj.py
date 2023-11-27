import glob
import os
class WIobj:
    def __init__(self,basepath):
        self.df = glob.glob(os.path.join(basepath,"*.p2m"))[0]
        print(f'{self.df}')
        self.lines = self.read_file()
        self.txpos = 0
        self.rxlist = []
        self.Nrx = 0
        
    def read_file(self):
        with open(self.df,"r") as fp:
            lines = fp.readlines()
            print(f'Number of lines: {len(lines)}')
        return lines

    def get_line(self,linenum):
        return self.lines[linenum].strip('\n')

    def get_line_strip_space(self,linenum):
        return self.get_line(linenum).split(' ')

    def add_tx_pos(self,pos):
        self.txpos = pos

    def add_rx(self,rx):
        self.rxlist.append(rx)

    def add_Nrx(self,Nrx):
        self.Nrx = Nrx