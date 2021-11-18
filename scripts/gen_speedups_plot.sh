# BIT 
python3 scripts/analyze_data.py --benchname=BIT --action=speedups --blocksize=32 --benchhome=${BENCH_HOME}
python3 scripts/analyze_data.py --benchname=BIT --action=speedups --blocksize=64 --benchhome=${BENCH_HOME}
python3 scripts/analyze_data.py --benchname=BIT --action=speedups --blocksize=128 --benchhome=${BENCH_HOME}
python3 scripts/analyze_data.py --benchname=BIT --action=speedups --blocksize=256 --benchhome=${BENCH_HOME}

# PCM
python3 scripts/analyze_data.py --benchname=PCM --action=speedups --blocksize=32 --benchhome=${BENCH_HOME}
python3 scripts/analyze_data.py --benchname=PCM --action=speedups --blocksize=64 --benchhome=${BENCH_HOME}
python3 scripts/analyze_data.py --benchname=PCM --action=speedups --blocksize=128 --benchhome=${BENCH_HOME}
python3 scripts/analyze_data.py --benchname=PCM --action=speedups --blocksize=256 --benchhome=${BENCH_HOME}

# MS
python3 scripts/analyze_data.py --benchname=MS --action=speedups --blocksize=32 --benchhome=${BENCH_HOME}
python3 scripts/analyze_data.py --benchname=MS --action=speedups --blocksize=64 --benchhome=${BENCH_HOME}
python3 scripts/analyze_data.py --benchname=MS --action=speedups --blocksize=128 --benchhome=${BENCH_HOME}
python3 scripts/analyze_data.py --benchname=MS --action=speedups --blocksize=256 --benchhome=${BENCH_HOME}

# LUD
python3 scripts/analyze_data.py --benchname=LUD --action=speedups --blocksize=8 --benchhome=${BENCH_HOME}
python3 scripts/analyze_data.py --benchname=LUD --action=speedups --blocksize=16 --benchhome=${BENCH_HOME}
python3 scripts/analyze_data.py --benchname=LUD --action=speedups --blocksize=32 --benchhome=${BENCH_HOME}
python3 scripts/analyze_data.py --benchname=LUD --action=speedups --blocksize=64 --benchhome=${BENCH_HOME}

# NQU 
python3 scripts/analyze_data.py --benchname=NQU --action=speedups --blocksize=64 --benchhome=${BENCH_HOME}
python3 scripts/analyze_data.py --benchname=NQU --action=speedups --blocksize=96 --benchhome=${BENCH_HOME}
python3 scripts/analyze_data.py --benchname=NQU --action=speedups --blocksize=128 --benchhome=${BENCH_HOME}
python3 scripts/analyze_data.py --benchname=NQU --action=speedups --blocksize=256 --benchhome=${BENCH_HOME}

# SRAD
python3 scripts/analyze_data.py --benchname=SRAD --action=speedups --blocksize=16 --benchhome=${BENCH_HOME}
python3 scripts/analyze_data.py --benchname=SRAD --action=speedups --blocksize=32 --benchhome=${BENCH_HOME}

# DCT
python3 scripts/analyze_data.py --benchname=DCT --action=speedups --blocksize=4 --benchhome=${BENCH_HOME}
python3 scripts/analyze_data.py --benchname=DCT --action=speedups --blocksize=8 --benchhome=${BENCH_HOME}
python3 scripts/analyze_data.py --benchname=DCT --action=speedups --blocksize=16 --benchhome=${BENCH_HOME}

python3 plots/plot_speedup.py speedups.csv speedups
python3 plots/plot_speedup.py raw_numbers/lreal.csv speedups_paper