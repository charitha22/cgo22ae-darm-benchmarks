import sys, os
import matplotlib.pyplot as plt
import numpy as np
import scipy.stats as stats
import pandas as pd
from matplotlib.patches import Patch

def plot_bench(input_csv, output_fname, width, gap, group, height, bbasenmperf=[], error=False, show=False):
    df = pd.read_csv(input_csv)

    colors = [[148/255.0,  53/255.0,  65/255.0],
              [ 80/255.0, 132/255.0, 167/255.0],
              [ 81/255.0, 196/255.0, 112/255.0],
              [241/255.0, 113/255.0,  84/255.0],
              [ 93/255.0,  70/255.0, 161/255.0],
              [113/255.0, 148/255.0,  65/255.0],
              [ 50/255.0, 150/255.0, 250/255.0],
              [220/255.0,  20/255.0, 190/255.0]]

    benchmarks = list(df['Benchmark'][:])
    n = len(benchmarks)
    
    index = np.arange(0, 3*(n + 1), 3) 
    dm_medians = list(df['DM-Median'][:])
    dm_means   = list(df['DM-Mean'][:])
    dm_errors  = list(df['DM-Error'][:])
    
    bf_medians = list(df['BF-Median'][:])
    bf_means   = list(df['BF-Mean'][:])
    bf_errors  = list(df['BF-Error'][:])

    dm_best_baseperf = [] 
    bf_best_baseperf = [] 
    
    i = 0
    if bbasenmperf == []:
        for l, c in zip(group, colors):
            alpha = 0.6
            for j in range(i, i+l):
                plt.bar(index[j]-width/2.0-gap, dm_medians[j], width, color=tuple(c+[alpha]), fill=True, ecolor='black', alpha=.99, hatch="////")
                plt.bar(index[j]+width/2.0+gap, bf_medians[j], width, color=tuple(c+[alpha]), fill=True)
                alpha += 0.1
            i += l
    else:
        for l, b, c in zip(group, bbasenmperf, colors):
            alpha = 0.6
            for j in range(i, i+l):
                plt.bar(index[j]-width/2.0-gap, dm_medians[j], width, color=tuple(c+[alpha]), fill=True, ecolor='black', alpha=.99, hatch="////")
                plt.bar(index[j]+width/2.0+gap, bf_medians[j], width, color=tuple(c+[alpha]), fill=True)

                if j is i+b: # best baseline
                    plt.text(index[j]-width/2.0-gap, dm_medians[j], '+', ha='center', va='bottom', fontsize='small')
                    dm_best_baseperf.append(dm_medians[j])
                    bf_best_baseperf.append(bf_medians[j])
                alpha += 0.1
            i += l
    
    if error:
        plt.errorbar(index[:-1]-width/2.0-gap, dm_means, yerr=dm_errors, fmt='none', ecolor='black')
        plt.errorbar(index[:-1]+width/2.0+gap, bf_means, yerr=bf_errors, fmt='none', ecolor='black')
    
    dm_gm = stats.gmean(dm_medians)
    bf_gm = stats.gmean(bf_medians)
    plt.bar(3*n-width/2.0-gap, dm_gm, width, color='red', fill=True, ecolor='black', alpha=.99, hatch="////")
    plt.bar(3*n+width/2.0+gap, bf_gm, width, color='red', fill=True)
    plt.text(3*n-width/2.0-gap, dm_gm, '%.2f' % dm_gm, ha='center', va='bottom', fontsize='x-small')

    if bbasenmperf != []:
        dm_gmb = stats.gmean(dm_best_baseperf)
        bf_gmb = stats.gmean(bf_best_baseperf)
        plt.bar(3*(n+1)-width/2.0-gap, dm_gmb, width, fill=True, color='green', ecolor='black', alpha=.99, hatch="////")
        plt.bar(3*(n+1)+width/2.0+gap, bf_gmb, width, fill=True, color='green') 
        plt.text(3*(n+1)-width/2.0-gap, dm_gmb, '%.2f' % dm_gmb, ha='center', va='bottom', fontsize='x-small')
    
    plt.ylim(0, max(dm_medians)+0.10)
    plt.xlim(-2*width, 3*(n+2)-width/2.0)
    plt.axhline(y=1, color='black', linestyle='dashed', linewidth=1)
    plt.ylabel("Speedup", fontsize='small')
    
    if bbasenmperf == []:
        plt.xticks(index, benchmarks + ['GM'] , fontsize='xx-small', rotation=40)
    else:
        plt.xticks(np.arange(0, 3*(n+2), 3), benchmarks + ['GM', 'GM-Best'] , fontsize='xx-small', rotation=40)
    plt.yticks(fontsize='small')

    legend_elems = [Patch(fill=False, alpha=.99, hatch="////", label="DARM"), 
                    Patch(fill=False, label="BF")]
    plt.legend(handles=legend_elems, loc='upper center', ncol=2, fontsize='x-small')
    
    plt.tight_layout()
    plt.gcf().set_size_inches((7.5, height))
    plt.gcf().savefig(output_fname+'.pdf', format='pdf', bbox_inches='tight', pad_inches=0)
    
    if show:
        plt.show()
    plt.clf()

if __name__ == "__main__":
    # plot_bench('lmicro', 1.3, 0.05, [4, 4, 4, 4, 4, 4, 4, 4], 2.0)
    input_csv = sys.argv[1]
    output_fname = sys.argv[2]

    plot_bench(input_csv, output_fname, 1.3, 0.05, [4, 4, 4, 4, 4, 2, 3], 2.5, [1, 0, 0, 1, 3, 1, 2])
