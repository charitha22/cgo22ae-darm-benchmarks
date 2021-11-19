python3 scripts/analyze_data.py --benchname=BIT --action=alu_mem --blocksize=64 --benchhome=${BENCH_HOME}
python3 scripts/analyze_data.py --benchname=PCM --action=alu_mem --blocksize=32 --benchhome=${BENCH_HOME}
python3 scripts/analyze_data.py --benchname=MS --action=alu_mem --blocksize=32 --benchhome=${BENCH_HOME}
python3 scripts/analyze_data.py --benchname=LUD --action=alu_mem --blocksize=8 --benchhome=${BENCH_HOME}
python3 scripts/analyze_data.py --benchname=NQU --action=alu_mem --blocksize=64 --benchhome=${BENCH_HOME}
python3 scripts/analyze_data.py --benchname=SRAD --action=alu_mem --blocksize=16 --benchhome=${BENCH_HOME}
python3 scripts/analyze_data.py --benchname=DCT --action=alu_mem --blocksize=16 --benchhome=${BENCH_HOME}

# plot alu
python3 plots/plot_alu.py alu.csv  alu
python3 plots/plot_alu.py raw_numbers/alu.csv alu_paper

# plot mem
python3 plots/plot_mem.py mem.csv  mem
python3 plots/plot_mem.py raw_numbers/mem.csv mem_paper