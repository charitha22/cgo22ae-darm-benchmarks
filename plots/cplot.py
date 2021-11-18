import sys, os
import matplotlib.pyplot as plt
import numpy as np
import scipy.stats as stats
import pandas as pd

def plot_bench(filename, blocksizes, width, offsets, figname, error, nsynth, nreal, btexts):
        df = pd.read_csv(filename)

        benchmarks = list(df['Benchmark'][:])

        baseline = [1] * nsynth + [0] + [1] * nreal + [0]
        n = nsynth + nreal + 2

        index = np.arange(n)

        bars = []
        for block, offset in zip(blocksizes, offsets):
                if block is None:
                        plt.bar(index + offset, baseline, width, label='Baseline')
                else:
                        mmedians = list(df['Median-' + str(block)][:])
                        b = plt.bar(index + offset, mmedians, width)
                        bars.append(b)
                        
                        if error:
                                mmeans   = list(df['Mean-' + str(block)][:])
                                merrors  = list(df['Error-' + str(block)][:])
                                plt.errorbar(index + offset, mmeans, yerr=merrors, fmt='none', ecolor='black')
        # max performance
        mperf = list(df['Max-Perf'][:])
        xaxis = index+2.5*width
        xaxis[9] -= width
        plt.bar(xaxis, mperf, width, label='Max Performance')
        
        # adding text
        realb = np.arange(nsynth+1, n-1)
        for rb, text in zip(realb, btexts):
                i = 0
                while i < len(text):
                        rect = bars[i][rb]
                        height = rect.get_height()
                        plt.text(rect.get_x() + rect.get_width()/2.0, height+.02, 
                                 text[i], ha='center', va='bottom', rotation=90, fontsize='x-small')
                        i += 1

        # geomean
        gmsyn = stats.gmean(mperf[:nsynth])
        gm    = stats.gmean(mperf[nsynth+1:-1])
        # update
        gms = [0] * n
        gms[nsynth] = gmsyn
        gms[-1]     = gm
        
        plt.bar(index, gms, 2*width, label='Geo Mean')
        plt.axhline(y=1, color='black', linestyle='--', linewidth=.5)
        plt.axvline(x=nsynth+0.375, color='red', linestyle='dashdot')

        plt.ylim(0, 1.8)
        plt.xlim(-0.75, n-0.5)
        
        plt.ylabel('Normalized Performance', fontsize='small')
        plt.xticks(index, benchmarks, fontsize='small')
        plt.yticks(fontsize='small')
        plt.legend(loc='best', fontsize='x-small')
        
        plt.tight_layout()
        
        fig = plt.gcf()
        fig.set_size_inches((8.5, 3.5), forward=False)
        fig.savefig(figname, format='pdf', bbox_inches='tight', pad_inches=0)
        
        plt.show()
        plt.clf()

if __name__ == "__main__":
        
        opt = 'combined'
        blocksizes = [None, 1, 2, 3, 4]
        width = 0.15
        offsets = [-2.5*width, -1.5*width, -0.5*width, 0.5*width, 1.5*width]
        texts = [ ["16", "32", "64", "128"], 
                  ["32", "64", "128", "256"], 
                  ["4x4", "8x8", "16x16"],
                  ["32", "64", "128", "256"], 
                  ["32", "64", "128", "256"] ] 
        plot_bench(opt+".csv", blocksizes, width, offsets, opt+".pdf", error=False, nsynth=6, nreal=5, btexts=texts)