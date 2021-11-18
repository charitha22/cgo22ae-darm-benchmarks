metrics_loc=${BENCH_HOME}

profitabilty_threshold=0.2

# best block sizes for DARM
best_block_size_BIT=64
best_block_size_PCM=32
best_block_size_DCT=16
best_block_size_MS=32
best_block_size_LUD=8
best_block_size_SRAD=16
best_block_size_NQU=64


# prgram arguments 
BIT_args=""
PCM_args=""
DCT_args=""
MS_args=""
LUD_args="-s 8192"
SRAD_args="4096 4096 0 127 0 127 0.5 2"
NQU_args="-g 15"

make bench_clean
cd benchmarks

cd BIT
make clean
mkdir -p tmp_metrics

rm -rf ./tmp_metrics/*
BLOCK_SIZE=${best_block_size_BIT} PROFITABILITY_THRESHOLD=${profitabilty_threshold} make
rocprof -i ${metrics_loc}/metrics.xml --timestamp on --basenames on --stats -o hip_${best_block_size_BIT}.csv \
  -t tmp_metrics -d tmp_metrics \
  ./bitonic_sort_${best_block_size_BIT}.hip ${BIT_args}

rm -rf ./tmp_metrics/*
rocprof -i ${metrics_loc}/metrics.xml --timestamp on --basenames on --stats -o bf_${best_block_size_BIT}.csv \
  -t tmp_metrics -d tmp_metrics \
  ./bitonic_sort_${best_block_size_BIT}.bf ${BIT_args}

rm -rf ./tmp_metrics/*
rocprof -i ${metrics_loc}/metrics.xml --timestamp on --basenames on --stats -o darm_${best_block_size_BIT}.csv \
  -t tmp_metrics -d tmp_metrics \
  ./bitonic_sort_${best_block_size_BIT}_${profitabilty_threshold}.cfm ${BIT_args}
cd ..

cd PCM
make clean
mkdir -p tmp_metrics
rm -rf ./tmp_metrics/*

BLOCK_SIZE=${best_block_size_PCM} PROFITABILITY_THRESHOLD=${profitabilty_threshold} make
rocprof -i ${metrics_loc}/metrics.xml --timestamp on --basenames on --stats -o hip_${best_block_size_PCM}.csv \
  -t tmp_metrics -d tmp_metrics \
  ./pcm_${best_block_size_PCM}.hip ${PCM_args}

rm -rf ./tmp_metrics/*
rocprof -i ${metrics_loc}/metrics.xml --timestamp on --basenames on --stats -o bf_${best_block_size_PCM}.csv \
  -t tmp_metrics -d tmp_metrics \
  ./pcm_${best_block_size_PCM}.bf ${PCM_args}

rm -rf ./tmp_metrics/*
rocprof -i ${metrics_loc}/metrics.xml --timestamp on --basenames on --stats -o darm_${best_block_size_PCM}.csv \
  -t tmp_metrics -d tmp_metrics \
  ./pcm_${best_block_size_PCM}_${profitabilty_threshold}.cfm ${PCM_args}
cd ..

cd DCT
make clean
mkdir -p tmp_metrics
rm -rf ./tmp_metrics/*

BLOCK_SIZE=${best_block_size_DCT} PROFITABILITY_THRESHOLD=${profitabilty_threshold} make
rocprof -i ${metrics_loc}/metrics.xml --timestamp on --basenames on --stats -o hip_${best_block_size_DCT}.csv \
  -t tmp_metrics -d tmp_metrics \
  ./dctq_${best_block_size_DCT}.hip ${DCT_args}

rm -rf ./tmp_metrics/*
rocprof -i ${metrics_loc}/metrics.xml --timestamp on --basenames on --stats -o bf_${best_block_size_DCT}.csv \
  -t tmp_metrics -d tmp_metrics \
  ./dctq_${best_block_size_DCT}.bf ${DCT_args}

rm -rf ./tmp_metrics/*
rocprof -i ${metrics_loc}/metrics.xml --timestamp on --basenames on --stats -o darm_${best_block_size_DCT}.csv \
  -t tmp_metrics -d tmp_metrics \
  ./dctq_${best_block_size_DCT}_${profitabilty_threshold}.cfm ${DCT_args}
cd ..


cd MS
make clean
mkdir -p tmp_metrics
rm -rf ./tmp_metrics/*

BLOCK_SIZE=${best_block_size_MS} PROFITABILITY_THRESHOLD=${profitabilty_threshold} make
rocprof -i ${metrics_loc}/metrics.xml --timestamp on --basenames on --stats -o hip_${best_block_size_MS}.csv \
  -t tmp_metrics -d tmp_metrics \
  ./mergesort_${best_block_size_MS}.hip ${MS_args}

rm -rf ./tmp_metrics/*
rocprof -i ${metrics_loc}/metrics.xml --timestamp on --basenames on --stats -o bf_${best_block_size_MS}.csv \
  -t tmp_metrics -d tmp_metrics \
  ./mergesort_${best_block_size_MS}.bf ${MS_args}

rm -rf ./tmp_metrics/*
rocprof -i ${metrics_loc}/metrics.xml --timestamp on --basenames on --stats -o darm_${best_block_size_MS}.csv \
  -t tmp_metrics -d tmp_metrics \
  ./mergesort_${best_block_size_MS}_${profitabilty_threshold}.cfm ${MS_args}
cd ..


cd LUD
make clean
mkdir -p tmp_metrics
rm -rf ./tmp_metrics/*

BLOCK_SIZE=${best_block_size_LUD} PROFITABILITY_THRESHOLD=${profitabilty_threshold} make
rocprof -i ${metrics_loc}/metrics.xml --timestamp on --basenames on --stats -o hip_${best_block_size_LUD}.csv \
  -t tmp_metrics -d tmp_metrics \
  ./lud_kernel.hip.${best_block_size_LUD}_hip ${LUD_args}

rm -rf ./tmp_metrics/*
rocprof -i ${metrics_loc}/metrics.xml --timestamp on --basenames on --stats -o bf_${best_block_size_LUD}.csv \
  -t tmp_metrics -d tmp_metrics \
  ./lud_kernel.hip.${best_block_size_LUD}_bf ${LUD_args}

rm -rf ./tmp_metrics/*
rocprof -i ${metrics_loc}/metrics.xml --timestamp on --basenames on --stats -o darm_${best_block_size_LUD}.csv \
  -t tmp_metrics -d tmp_metrics \
  ./lud_kernel.hip.${best_block_size_LUD}_${profitabilty_threshold}_cfm ${LUD_args}
cd ..


cd SRAD
make clean
mkdir -p tmp_metrics
rm -rf ./tmp_metrics/*

BLOCK_SIZE=${best_block_size_SRAD} PROFITABILITY_THRESHOLD=${profitabilty_threshold} make
rocprof -i ${metrics_loc}/metrics.xml --timestamp on --basenames on --stats -o hip_${best_block_size_SRAD}.csv \
  -t tmp_metrics -d tmp_metrics \
  ./srad_${best_block_size_SRAD}.hip ${SRAD_args}

rm -rf ./tmp_metrics/*
rocprof -i ${metrics_loc}/metrics.xml --timestamp on --basenames on --stats -o bf_${best_block_size_SRAD}.csv \
  -t tmp_metrics -d tmp_metrics \
  ./srad_${best_block_size_SRAD}.bf ${SRAD_args}

rm -rf ./tmp_metrics/*
rocprof -i ${metrics_loc}/metrics.xml --timestamp on --basenames on --stats -o darm_${best_block_size_SRAD}.csv \
  -t tmp_metrics -d tmp_metrics \
  ./srad_${best_block_size_SRAD}_${profitabilty_threshold}.cfm ${SRAD_args}
cd ..

cd NQU
make clean
mkdir -p tmp_metrics
rm -rf ./tmp_metrics/*

BLOCK_SIZE=${best_block_size_NQU} PROFITABILITY_THRESHOLD=${profitabilty_threshold} make
rocprof -i ${metrics_loc}/metrics.xml --timestamp on --basenames on --stats -o hip_${best_block_size_NQU}.csv \
  -t tmp_metrics -d tmp_metrics \
  ./nqueen_${best_block_size_NQU}.hip ${NQU_args} $((best_block_size_NQU*2))

rm -rf ./tmp_metrics/*
rocprof -i ${metrics_loc}/metrics.xml --timestamp on --basenames on --stats -o bf_${best_block_size_NQU}.csv \
  -t tmp_metrics -d tmp_metrics \
  ./nqueen_${best_block_size_NQU}.bf ${NQU_args} $((best_block_size_NQU*2))

rm -rf ./tmp_metrics/*
rocprof -i ${metrics_loc}/metrics.xml --timestamp on --basenames on --stats -o darm_${best_block_size_NQU}.csv \
  -t tmp_metrics -d tmp_metrics \
  ./nqueen_${best_block_size_NQU}_${profitabilty_threshold}.cfm ${NQU_args} $((best_block_size_NQU*2))
cd ..


cd ..