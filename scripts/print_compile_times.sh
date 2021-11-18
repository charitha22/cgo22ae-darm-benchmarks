python3 scripts/analyze_data.py --benchname=BIT --action=compile_time --blocksize=64 --benchhome=${BENCH_HOME}
python3 scripts/analyze_data.py --benchname=PCM --action=compile_time --blocksize=32 --benchhome=${BENCH_HOME}
python3 scripts/analyze_data.py --benchname=MS --action=compile_time --blocksize=32 --benchhome=${BENCH_HOME}
python3 scripts/analyze_data.py --benchname=LUD --action=compile_time --blocksize=8 --benchhome=${BENCH_HOME}
python3 scripts/analyze_data.py --benchname=NQU --action=compile_time --blocksize=64 --benchhome=${BENCH_HOME}
python3 scripts/analyze_data.py --benchname=SRAD --action=compile_time --blocksize=16 --benchhome=${BENCH_HOME}
python3 scripts/analyze_data.py --benchname=DCT --action=compile_time --blocksize=16 --benchhome=${BENCH_HOME}