python3 scripts/analyze_data.py --benchname=BIT --action=profit_thresholds --blocksize=64 --benchhome=${BENCH_HOME}
python3 scripts/analyze_data.py --benchname=PCM --action=profit_thresholds--blocksize=32 --benchhome=${BENCH_HOME}
python3 scripts/analyze_data.py --benchname=MS --action=profit_thresholds --blocksize=32 --benchhome=${BENCH_HOME}
python3 scripts/analyze_data.py --benchname=LUD --action=profit_thresholds --blocksize=8 --benchhome=${BENCH_HOME}
python3 scripts/analyze_data.py --benchname=NQU --action=profit_thresholds --blocksize=64 --benchhome=${BENCH_HOME}
python3 scripts/analyze_data.py --benchname=SRAD --action=profit_thresholds --blocksize=16 --benchhome=${BENCH_HOME}
python3 scripts/analyze_data.py --benchname=DCT --action=profit_thresholds --blocksize=16 --benchhome=${BENCH_HOME}

# plot alu
python3 plots/plot_profit.py profitability.csv  profitability
python3 plots/plot_profit.py raw_numbers/profitability.csv profitability_paper