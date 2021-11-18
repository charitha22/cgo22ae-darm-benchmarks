import sys
import matplotlib.pyplot as plt
import numpy as np
import pandas as pd 

def plot_alu(input_csv, output_fname, nsynth, nreal, width, w, h, synth=False):
    df = pd.read_csv(input_csv)
    if synth:
        benchmarks = list(df['Benchmark'][:])
        n = nsynth + nreal
    else:
        benchmarks = list(df['Benchmark'][nsynth:])
        n = nreal

    index = np.arange(n)
    if synth:
        plt.bar(index + -1 * width, list(df['O3'][:]), width, label='O3', color=(148/255.0,  53/255.0,  65/255.0)) 
        plt.bar(index +  0 * width, list(df['DARM'][:]), width, label='DARM', color=(80/255.0, 132/255.0, 167/255.0), alpha=.99, hatch="////") 
        plt.bar(index +  1 * width, list(df['BF'][:]), width, label='BF', color=(81/255.0, 196/255.0, 112/255.0)) 
    else:
        plt.bar(index + -1 * width, list(df['O3'][nsynth:]), width, label='O3', color=(148/255.0,  53/255.0,  65/255.0)) 
        plt.bar(index +  0 * width, list(df['DARM'][nsynth:]), width, label='DARM', color=(80/255.0, 132/255.0, 167/255.0), alpha=.99, hatch="////") 
        plt.bar(index +  1 * width, list(df['BF'][nsynth:]), width, label='BF', color=(81/255.0, 196/255.0, 112/255.0)) 
    
    if synth:
        plt.axvline(x=nsynth-0.5, color='black', linestyle='dashdot') 
    
    plt.ylim(0, 105)
    plt.xlim(-0.75, n-0.25)
    
    plt.ylabel('ALU Utilization (%)', fontsize='small')
    plt.xticks(index, benchmarks, fontsize='small', rotation=0)
    plt.yticks([0, 20, 40, 60, 80, 100], fontsize='x-small')
    plt.legend(loc='upper left', ncol=3, fontsize='small') 
        
    plt.tight_layout()
    plt.gcf().set_size_inches(w,h)
    plt.gcf().savefig(output_fname+'.pdf', format='pdf', bbox_inches='tight', pad_inches=0)
    plt.clf()


if __name__ == "__main__":
    input_csv = sys.argv[1]
    output_fname = sys.argv[2]

    plot_alu(input_csv, output_fname, 8, 7, 0.25, 5.0, 2.5)