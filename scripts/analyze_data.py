import sys
import statistics
from optparse import OptionParser
import csv
import re
import glob



def print_speedups(options):
  print("----------------------------------------------------")
  print(f"benchmark \t: {options.benchname}")
  print(f"block size  \t: {options.blocksize}")
  f = open(f"{options.benchhome}/benchmarks/{options.benchname}/speedup_results_{options.blocksize}.txt", 'r')
  lines = f.readlines()

  baseline = []
  bf = []
  darm = []

  baseline_flag = False 
  bf_flag = False
  darm_flag = False

  for l in lines:
    if "baseline" in l:
      baseline_flag = True
      bf_flag = False
      darm_flag = False
      continue
    if "branch fusion" in l:
      baseline_flag = False
      bf_flag = True
      darm_flag = False
      continue
    if "DARM" in l:
      baseline_flag = False
      bf_flag = False
      darm_flag = True
      continue

    if "execution time" in l:
      exec_time = float(l.split("=")[1].lstrip())
      if baseline_flag:
        baseline.append(exec_time)
      elif bf_flag:
        bf.append(exec_time)
      else:
        darm.append(exec_time)
    
  median_baseline = statistics.median(baseline)
  median_bf = statistics.median(bf)
  median_darm = statistics.median(darm)

  speedup_darm = median_baseline/median_darm
  speedup_bf = median_baseline/median_bf

  print(f"speedup for branch fusion \t= {speedup_bf}")
  print(f"speedup for DARM \t\t= {speedup_darm}")

  # write to csv file
  if len(glob.glob(f"{options.benchhome}/speedups.csv")) == 0:
    with open(f"{options.benchhome}/speedups.csv", "w") as speedups_f:
      speedups_f.write("Benchmark,DM-Median,DM-Mean,DM-Error,BF-Median,BF-Mean,BF-Error\n")
  
  with open(f"{options.benchhome}/speedups.csv", "a") as speedups_f:
    speedups_f.write(f"{options.benchname}{options.blocksize},{speedup_darm},{1.0},{1.0},{speedup_bf},{1.0},{1.0}\n")

  

def print_mem_alu(options):
  hip_csv = f"{options.benchhome}/benchmarks/{options.benchname}/hip_{options.blocksize}.csv"
  bf_csv = f"{options.benchhome}/benchmarks/{options.benchname}/bf_{options.blocksize}.csv"
  darm_csv = f"{options.benchhome}/benchmarks/{options.benchname}/darm_{options.blocksize}.csv"
  
  baseline_alu_util = 0
  bf_alu_util = 0
  darm_alu_util = 0

  baseline_vec_rdwr = 0
  bf_vec_rdwr = 0
  darm_vec_rdwr = 0
  
  baseline_sh_mem = 0
  bf_sh_mem = 0
  darm_sh_mem = 0

  baseline_calls = 0
  bf_calls = 0
  darm_calls = 0

  with open(hip_csv, newline='') as csv_file:
    reader = csv.DictReader(csv_file)
    for row in reader:
      baseline_alu_util += int(row['VALUUtilization'])
      baseline_vec_rdwr += int(row['SQ_INSTS_VMEM_WR']) + int(row['SQ_INSTS_VMEM_RD'])
      baseline_sh_mem += int(row['SQ_INSTS_LDS'])
      baseline_calls += 1

  with open(bf_csv, newline='') as csv_file:
    reader = csv.DictReader(csv_file)
    for row in reader:
      bf_alu_util += int(row['VALUUtilization'])
      bf_vec_rdwr += int(row['SQ_INSTS_VMEM_WR']) + int(row['SQ_INSTS_VMEM_RD'])
      bf_sh_mem += int(row['SQ_INSTS_LDS'])
      bf_calls += 1

  with open(darm_csv, newline='') as csv_file:
    reader = csv.DictReader(csv_file)
    for row in reader:
      darm_alu_util += int(row['VALUUtilization'])
      darm_vec_rdwr += int(row['SQ_INSTS_VMEM_WR']) + int(row['SQ_INSTS_VMEM_RD'])
      darm_sh_mem += int(row['SQ_INSTS_LDS'])
      darm_calls += 1
  
  baseline_alu_util_avg = baseline_alu_util/baseline_calls
  bf_alu_util_avg = bf_alu_util/bf_calls
  darm_alu_util_avg = darm_alu_util/darm_calls

  print(f"ALU utilization")
  print(f"----------------")
  print(f"baseline \t: {baseline_alu_util_avg:.4f}")
  print(f"branch fusion \t: {bf_alu_util_avg:.4f}")
  print(f"DARM \t\t: {darm_alu_util_avg:.4f}")
  print(f"")

  baseline_vec_rdwr_norm = baseline_vec_rdwr/baseline_vec_rdwr if baseline_vec_rdwr != 0 else 0.0
  bf_vec_rdwr_norm = bf_vec_rdwr/baseline_vec_rdwr if baseline_vec_rdwr != 0 else 0.0
  darm_vec_rdwr_norm = darm_vec_rdwr/baseline_vec_rdwr if baseline_vec_rdwr != 0 else 0.0

  print(f"Vector memory reads + writes (normalized)")
  print(f"-----------------------------------------")
  print(f"baseline \t: {baseline_vec_rdwr} ({baseline_vec_rdwr_norm:.4f})")
  print(f"branch fusion \t: {bf_vec_rdwr} ({bf_vec_rdwr_norm:.4f})")
  print(f"DARM \t\t: {darm_vec_rdwr} ({darm_vec_rdwr_norm:.4f})")
  print(f"")

  basline_sh_mem_norm = baseline_sh_mem/baseline_sh_mem if baseline_sh_mem != 0 else 0.0
  bf_sh_mem_norm = bf_sh_mem/baseline_sh_mem if baseline_sh_mem != 0 else 0.0
  darm_sh_mem_norm = darm_sh_mem/baseline_sh_mem if baseline_sh_mem != 0 else 0.0

  print(f"Shared memory instructions (normalized)")
  print(f"-----------------------------------------")
  print(f"baseline \t: {baseline_sh_mem} ({basline_sh_mem_norm:.4f})")
  print(f"branch fusion \t: {bf_sh_mem} ({bf_sh_mem_norm:.4f})")
  print(f"DARM \t\t: {darm_sh_mem} ({darm_sh_mem_norm:.4f})")

  # write alu to csv file
  if len(glob.glob(f"{options.benchhome}/alu.csv")) == 0:
    with open(f"{options.benchhome}/alu.csv", "w") as alu_f:
      alu_f.write("Benchmark,O3,DARM,BF\n")
      alu_f.write("SB1,73.0000,99.0000,99.0000\n")
      alu_f.write("SB1-R,25.0000,39.0000,39.0000\n")
      alu_f.write("SB2,24.0000,35.0000,24.0000\n")
      alu_f.write("SB2-R,24.0000,35.0000,24.0000\n")
      alu_f.write("SB3,26.0000,44.0000,26.0000\n")
      alu_f.write("SB3-R,11.0000,20.0000,11.0000\n")
      alu_f.write("SB4,38.0000,93.0000,54.0000\n")
      alu_f.write("SB4-R,37.0000,89.0000,53.0000\n")
  
  with open(f"{options.benchhome}/alu.csv", "a") as alu_f:
    alu_f.write(f"{options.benchname},{baseline_alu_util_avg:.4f},{darm_alu_util_avg:.4f},{bf_alu_util_avg:.4f}\n")

  # write mem to csv file
  if len(glob.glob(f"{options.benchhome}/mem.csv")) == 0:
    with open(f"{options.benchhome}/mem.csv", "w") as mem_f:
      mem_f.write("Benchmark,VMEM-RD+RW-DARM,VMEM-RD+RW-BF,LDS-INSTS-DARM,LDS-INSTS-BF,FLAT-INSTS-DARM,FLAT-INSTS-BF\n")
      mem_f.write("SB1,1.0000,1.0000,0.8000,0.8000,1.0000,1.0000\n") 
      mem_f.write("SB1-R,1.0000,1.0000,0.6671,0.6671,1.0000,1.0000\n") 
      mem_f.write("SB2,1.0000,1.0000,0.8889,1.0000,1.0000,1.0000\n")
      mem_f.write("SB2-R,1.0000,1.0000,0.8889,1.0000,1.0000,1.0000\n")
      mem_f.write("SB3,1.0000,1.0000,0.8334,1.0000,1.0000,1.0000\n")
      mem_f.write("SB3-R,1.0000,1.0000,0.8560,1.0000,1.0000,1.0000\n")
      mem_f.write("SB4,1.0000,1.0000,0.7273,0.9091,1.0000,1.0000\n")
      mem_f.write("SB4-R,1.0000,1.0000,0.7273,0.9091,1.0000,1.0000\n")
  
  with open(f"{options.benchhome}/mem.csv", "a") as mem_f:
    mem_f.write(f"{options.benchname},{darm_vec_rdwr_norm:.4f},{bf_vec_rdwr_norm:.4f},{darm_sh_mem_norm:.4f},{bf_sh_mem_norm:.4f},{1.0},{1.0}\n")


def print_compile_times(options):
  print("----------------------------------------------------")
  print(f"benchmark \t: {options.benchname}")
  print(f"block size  \t: {options.blocksize}")
  f = open(f"{options.benchhome}/benchmarks/{options.benchname}/compile_time_results_{options.blocksize}.txt", 'r')
  lines = f.readlines()

  baseline = []
  darm = []

  baseline_flag = False 
  darm_flag = False

  for l in lines:
    if "baseline" in l:
      baseline_flag = True
      darm_flag = False
      continue
    if "DARM" in l:
      baseline_flag = False
      darm_flag = True
      continue

    if "real" in l:
      decimals = re.findall('\d*\.?\d+',l)
      assert len(decimals) == 2, "invalid time output"
      compile_time = float(decimals[1]) + 60 * float(decimals[0]) 
      if baseline_flag:
        baseline.append(compile_time)
      else:
        darm.append(compile_time)
    
  mean_baseline = statistics.mean(baseline)
  mean_darm = statistics.mean(darm)

  print(f"average compile time for baseline \t= {mean_baseline:.4f} sec")
  print(f"average compile time for DARM \t\t= {mean_darm:.4f} sec")

def print_profit_thresholds(options):
  f = open(f"{options.benchhome}/benchmarks/{options.benchname}/profit_results_{options.blocksize}.txt", 'r')
  lines = f.readlines()

  baseline = []
  darm = []

  baseline_flag = False 
  darm_flag = False

  for l in lines:
    if "baseline" in l:
      baseline_flag = True
      darm_flag = False
      continue
    if "DARM" in l:
      baseline_flag = False
      darm_flag = True
      continue

    if "execution time" in l:
      exec_time = float(l.split("=")[1].lstrip())
      
      if baseline_flag:
        baseline.append(exec_time)
      else:
        darm.append(exec_time)
    
  median_baseline = statistics.median(baseline)
  elems_per_threshold = int(len(darm) / 5)
  median_darm_theshold1 = statistics.median(darm[0:elems_per_threshold])
  median_darm_theshold2 = statistics.median(darm[elems_per_threshold:2*elems_per_threshold])
  median_darm_theshold3 = statistics.median(darm[2*elems_per_threshold:3*elems_per_threshold])
  median_darm_theshold4 = statistics.median(darm[3*elems_per_threshold:4*elems_per_threshold])
  median_darm_theshold5 = statistics.median(darm[4*elems_per_threshold:5*elems_per_threshold])

  threshold1_norm = median_baseline/median_darm_theshold1
  threshold2_norm = median_baseline/median_darm_theshold2
  threshold3_norm = median_baseline/median_darm_theshold3
  threshold4_norm = median_baseline/median_darm_theshold4
  threshold5_norm = median_baseline/median_darm_theshold5
  

  print(f"DARM's median speedup for profitibility threshold 0.1 \t\t= {threshold1_norm:.4f}")
  print(f"DARM's median speedup for profitibility threshold 0.2 \t\t= {threshold2_norm:.4f}")
  print(f"DARM's median speedup for profitibility threshold 0.3 \t\t= {threshold3_norm:.4f}")
  print(f"DARM's median speedup for profitibility threshold 0.4 \t\t= {threshold4_norm:.4f}")
  print(f"DARM's median speedup for profitibility threshold 0.5 \t\t= {threshold5_norm:.4f}")

  # write speedups to a csv
  if len(glob.glob(f"{options.benchhome}/profitability.csv")) == 0:
    with open(f"{options.benchhome}/profitability.csv", "w") as profit_f:
      profit_f.write("Benchmark,Threshold[0.1],Threshold[0.2],Threshold[0.3],Threshold[0.4],Threshold[0.5]\n")
  
  with open(f"{options.benchhome}/profitability.csv", "a") as profit_f:
    profit_f.write(f"{options.benchname},{threshold1_norm:.4f},{threshold2_norm:.4f},{threshold3_norm:.4f},{threshold4_norm:.4f},{threshold5_norm:.4f}\n")



def main():
  parser = OptionParser()
  parser.add_option("--benchname", action="store", dest="benchname")
  parser.add_option("--action", action="store",  dest="action")
  parser.add_option("--blocksize", type="int", dest="blocksize")
  parser.add_option("--benchhome", action="store", dest="benchhome")
  (options, args) = parser.parse_args()

  if options.action == "speedups":
    print_speedups(options)
  elif options.action == "alu_mem":
    print_mem_alu(options)
  elif options.action == "compile_time":
    print_compile_times(options)
  elif options.action == "profit_thresholds":
    print_profit_thresholds(options)



if __name__ == "__main__":
  main()