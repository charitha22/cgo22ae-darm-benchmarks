import sys
import matplotlib.pyplot as plt
import numpy as np
import pandas as pd 

def plot_mem(input_csv, output_fname, nsynth, nreal, width, w, h, synth=False):
    df = pd.read_csv(input_csv)
    if synth:
        benchmarks = list(df['Benchmark'][:])
        n = nsynth + nreal
    else:
        benchmarks = list(df['Benchmark'][nsynth:])
        n = nreal

    index = np.arange(0, 2*n, 2)
    
    gap = 0.05
    if synth:
        plt.bar(index + -1.5 * width - gap, list(df['VMEM-RD+RW-DARM'][:]), width, label='Vector Mem RD+RW (DARM)', color='tab:blue', alpha=.99, hatch='////') 
        plt.bar(index + -0.5 * width - gap, list(df['VMEM-RD+RW-BF'][:]),   width, label='Vector Mem RD+RW (BF)',   color='tab:orange') 
        plt.bar(index +  0.5 * width + gap, list(df['LDS-INSTS-DARM'][:]),  width, label='Shared Mem (DARM)',       color='tab:green', alpha=.99, hatch='////')
        plt.bar(index +  1.5 * width + gap, list(df['LDS-INSTS-BF'][:]),    width, label='Shared Mem (BF)',         color='tab:red')
    else:
        plt.bar(index + -1.5 * width - gap, list(df['VMEM-RD+RW-DARM'][nsynth:]), width, label='Vector Mem RD+RW (DARM)', color='tab:blue', alpha=.99, hatch='////') 
        plt.bar(index + -0.5 * width - gap, list(df['VMEM-RD+RW-BF'][nsynth:]),   width, label='Vector Mem RD+RW (BF)',   color='tab:orange') 
        plt.bar(index +  0.5 * width + gap, list(df['LDS-INSTS-DARM'][nsynth:]),  width, label='Shared Mem (DARM)',       color='tab:green', alpha=.99, hatch='////')
        plt.bar(index +  1.5 * width + gap, list(df['LDS-INSTS-BF'][nsynth:]),    width, label='Shared Mem (BF)',         color='tab:red')
    
    if nsynth:
        plt.axvline(x=2*nsynth-1, color='black', linestyle='dashdot') 
    plt.axhline(y=1, color='black', linestyle='--')
    
    plt.ylim(0, 1.6)
    plt.xlim(-1, 2*n-1)
    
    plt.ylabel('Normalized Counters', fontsize='small')
    plt.xticks(index, benchmarks, fontsize='small', rotation=0)
    plt.yticks([0.0, 0.5, 1.0, 1.5], fontsize='x-small')
    plt.legend(loc='upper right', ncol=1, fontsize='x-small') 
    
    plt.tight_layout()
    plt.gcf().set_size_inches(w, h)
    plt.gcf().savefig(output_fname+'.pdf', format='pdf', bbox_inches='tight', pad_inches=0)
    plt.clf()

if __name__ == "__main__":

    input_csv = sys.argv[1]
    output_fname = sys.argv[2]
    
    plot_mem(input_csv, output_fname, 8, 7, 0.35, 5.0, 2.5)