import sys, os
import matplotlib.pyplot as plt
import numpy as np
import scipy.stats as stats
import pandas as pd

def plot_bench(filename, blocksizes, width, offsets, title, figname, error, real):
        df = pd.read_csv(filename)

        mbenchmarks = list(df['Benchmark'][:])

        nmbenchmarks = df.shape[0]
        mbaseline = [1] * (nmbenchmarks-1) + [0]

        index = np.arange(nmbenchmarks)

        for block, offset in zip(blocksizes, offsets):
                if block is None:
                        plt.bar(index + offset, mbaseline, width, label='Baseline')
                else:
                        mmedians = list(df['Median-' + str(block)][:])
                        plt.bar(index + offset, mmedians, width, label='Block Size '+str(block))
                        
                        if error:
                                mmeans   = list(df['Mean-' + str(block)][:])
                                merrors  = list(df['Error-' + str(block)][:])
                                plt.errorbar(index + offset, mmeans, yerr=merrors, fmt='none', ecolor='black')
        # max performance
        mperf = list(df['Max-Perf'][:])
        xaxis = index+2.5*width
        if real:
                xaxis[2] -= width
        plt.bar(xaxis, mperf, width, label='Max Performance')
        
        # geomean
        gm = stats.gmean(mperf[:-1])
        gms = [0] * nmbenchmarks
        gms[-1] = gm
        plt.bar(index, gms, 2*width)
        plt.axhline(y=1, color='black', linestyle='--')

        if not real:
                plt.ylim(0, 1.8)
        else:
                plt.ylim(0, 1.6)
        
        plt.ylabel('Normalized Performance', fontsize=15)
        plt.xlabel('Benchmarks', fontsize=15)
        plt.xticks(index, mbenchmarks, fontsize=15)
        plt.yticks(fontsize=15)
        plt.legend(loc='upper right', fontsize=10)
        
        plt.tight_layout()
        plt.gcf().set_size_inches((4, 3.5))
        plt.gcf().savefig(figname+'.pdf', format='pdf', dpi=500, bbox_inches='tight', pad_inches=0)
        
        plt.show()
        plt.clf()

def plot_profit(input_csv, output_fname, thresholds, width, offsets, show=False):
        df = pd.read_csv(input_csv)

        mbenchmarks = list(df['Benchmark'][:])
        nmbenchmarks = df.shape[0]
        index = np.arange(nmbenchmarks)

        for thresh, offset in zip(thresholds, offsets):
                key = 'Threshold['+str(thresh)+']'
                mmedians = list(df[key][:])
                plt.bar(index + offset, mmedians, width, label=str(thresh))
        
        plt.axhline(y=1, color='black', linestyle='--')

        plt.ylim(0, 1.6)
        plt.xlim(-0.75, nmbenchmarks-0.5)

        plt.ylabel('Speedup', fontsize='small')
        plt.xticks(index, mbenchmarks, fontsize='small')
        plt.yticks([0.0, 0.5, 1.0, 1.5], fontsize='x-small')
        plt.legend(loc='upper center', ncol=len(thresholds), fontsize='x-small')
        
        plt.tight_layout()
        plt.gcf().set_size_inches((5.0, 2.5))
        plt.gcf().savefig(output_fname+'.pdf', format='pdf', bbox_inches='tight', pad_inches=0)
    
        if show:
            plt.show()
        plt.clf()

if __name__ == "__main__":
        # if len(sys.argv) != 2:
        #         print("usage: python3 plots.py <option>")
        #         exit(-1)
        
        # opt = sys.argv[1]
        # if opt == "micro":
        #         blocksizes = [None, 32, 64, 128, 256]
        #         width = 0.15
        #         offsets = [-2.5*width, -1.5*width, -0.5*width, 0.5*width, 1.5*width]
        #         title = "Synthetic Benchmark Performance"
        #         plot_bench(opt+".csv", blocksizes, width, offsets, title, opt+".pdf", False, False)
        
        # elif opt == "real":
        #         blocksizes = [None, 1, 2, 3, 4]
        #         width = 0.15
        #         offsets = [-2.5*width, -1.5*width, -0.5*width, 0.5*width, 1.5*width]
        #         title = "Real World Benchmark Performance"
        #         plot_bench(opt+".csv", blocksizes, width, offsets, title, opt+".pdf", False, True)

        # elif opt == "profitability":
        input_csv = sys.argv[1]
        output_fname = sys.argv[2]

        thresholds = [0.1, 0.2, 0.3, 0.4, 0.5]
        width = 0.15
        offsets = [-2.5*width, -1.5*width, -0.5*width, 0.5*width, 1.5*width]
        plot_profit(input_csv, output_fname, thresholds, width, offsets)
        
        # else:
        #         print("invalid option")
        #         print("usage: python3 plots.py <option>")
        #         exit(-1)


