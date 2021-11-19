nruns=5
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
LUD_args="-s 16384"
SRAD_args="4096 4096 0 127 0 127 0.5 2"
NQU_args="-g 15"

make bench_clean
cd benchmarks

cd BIT
make clean

# compile
BLOCK_SIZE=${best_block_size_BIT} PROFITABILITY_THRESHOLD=0.2 make bitonic_sort_${best_block_size_BIT}.hip

# run
echo "baseline : " | tee -a profit_results_${best_block_size_BIT}.txt
for i in $(seq 1 1 ${nruns})
do
    ./bitonic_sort_${best_block_size_BIT}.hip ${BIT_args} | tee -a profit_results_${best_block_size_BIT}.txt
done

# threshold
for threshold in $(seq 0.1 0.1 0.5)
do
  echo "DARM, profitability threshold = ${threshold}" | tee -a profit_results_${best_block_size_BIT}.txt
  make clean 
  BLOCK_SIZE=${best_block_size_BIT} PROFITABILITY_THRESHOLD=${threshold} make bitonic_sort_${best_block_size_BIT}_${threshold}.cfm
  for i in $(seq 1 1 ${nruns})
  do
    ./bitonic_sort_${best_block_size_BIT}_${threshold}.cfm ${BIT_args} | tee -a profit_results_${best_block_size_BIT}.txt
  done
done
cd ..

cd PCM
make clean

# compile
BLOCK_SIZE=${best_block_size_PCM} PROFITABILITY_THRESHOLD=0.2 make pcm_${best_block_size_PCM}.hip

# run
echo "baseline : " | tee -a profit_results_${best_block_size_PCM}.txt
for i in $(seq 1 1 ${nruns})
do
    ./pcm_${best_block_size_PCM}.hip ${PCM_args}| tee -a profit_results_${best_block_size_PCM}.txt
done

# threshold
for threshold in $(seq 0.1 0.1 0.5)
do
  echo "DARM, profitability threshold = ${threshold}" | tee -a profit_results_${best_block_size_PCM}.txt
  make clean 
  BLOCK_SIZE=${best_block_size_PCM} PROFITABILITY_THRESHOLD=${threshold} make pcm_${best_block_size_PCM}_${threshold}.cfm
  for i in $(seq 1 1 ${nruns})
  do
    ./pcm_${best_block_size_PCM}_${threshold}.cfm | tee -a profit_results_${best_block_size_PCM}.txt
  done
done
cd ..

cd DCT
make clean

# compile
BLOCK_SIZE=${best_block_size_DCT} PROFITABILITY_THRESHOLD=0.2 make dctq_${best_block_size_DCT}.hip

# run
echo "baseline : " | tee -a profit_results_${best_block_size_DCT}.txt
for i in $(seq 1 1 ${nruns})
do
    ./dctq_${best_block_size_DCT}.hip ${DCT_args}| tee -a profit_results_${best_block_size_DCT}.txt
done

# threshold
for threshold in $(seq 0.1 0.1 0.5)
do
  echo "DARM, profitability threshold = ${threshold}" | tee -a profit_results_${best_block_size_DCT}.txt
  make clean 
  BLOCK_SIZE=${best_block_size_DCT} PROFITABILITY_THRESHOLD=${threshold} make dctq_${best_block_size_DCT}_${threshold}.cfm
  for i in $(seq 1 1 ${nruns})
  do
    ./dctq_${best_block_size_DCT}_${threshold}.cfm | tee -a profit_results_${best_block_size_DCT}.txt
  done
done
cd ..

cd MS
make clean

# compile
BLOCK_SIZE=${best_block_size_MS} PROFITABILITY_THRESHOLD=0.2 make mergesort_${best_block_size_MS}.hip

# run
echo "baseline : " | tee -a profit_results_${best_block_size_MS}.txt
for i in $(seq 1 1 ${nruns})
do
    ./mergesort_${best_block_size_MS}.hip ${MS_args}| tee -a profit_results_${best_block_size_MS}.txt
done

# threshold
for threshold in $(seq 0.1 0.1 0.5)
do
  echo "DARM, profitability threshold = ${threshold}" | tee -a profit_results_${best_block_size_MS}.txt
  make clean 
  BLOCK_SIZE=${best_block_size_MS} PROFITABILITY_THRESHOLD=${threshold} make mergesort_${best_block_size_MS}_${threshold}.cfm
  for i in $(seq 1 1 ${nruns})
  do
    ./mergesort_${best_block_size_MS}_${threshold}.cfm | tee -a profit_results_${best_block_size_MS}.txt
  done
done
cd ..


cd LUD
make clean

# compile
BLOCK_SIZE=${best_block_size_LUD} PROFITABILITY_THRESHOLD=0.2 make lud_kernel.hip.${best_block_size_LUD}_hip

# run
echo "baseline : " | tee -a profit_results_${best_block_size_LUD}.txt
for i in $(seq 1 1 ${nruns})
do
    ./lud_kernel.hip.${best_block_size_LUD}_hip ${LUD_args}| tee -a profit_results_${best_block_size_LUD}.txt
done

# threshold
for threshold in $(seq 0.1 0.1 0.5)
do
  echo "DARM, profitability threshold = ${threshold}" | tee -a profit_results_${best_block_size_LUD}.txt
  make clean 
  BLOCK_SIZE=${best_block_size_LUD} PROFITABILITY_THRESHOLD=${threshold} make lud_kernel.hip.${best_block_size_LUD}_${threshold}_cfm
  for i in $(seq 1 1 ${nruns})
  do
    ./lud_kernel.hip.${best_block_size_LUD}_${threshold}_cfm  ${LUD_args} | tee -a profit_results_${best_block_size_LUD}.txt
  done
done
cd ..

cd SRAD
make clean

# compile
BLOCK_SIZE=${best_block_size_SRAD} PROFITABILITY_THRESHOLD=0.2 make srad_${best_block_size_LUD}.hip

# run
echo "baseline : " | tee -a profit_results_${best_block_size_SRAD}.txt
for i in $(seq 1 1 ${nruns})
do
    ./srad_${best_block_size_SRAD}.hip ${SRAD_args}| tee -a profit_results_${best_block_size_SRAD}.txt
done

# threshold
for threshold in $(seq 0.1 0.1 0.5)
do
  echo "DARM, profitability threshold = ${threshold}" | tee -a profit_results_${best_block_size_SRAD}.txt
  make clean 
  BLOCK_SIZE=${best_block_size_SRAD} PROFITABILITY_THRESHOLD=${threshold} make srad_${best_block_size_SRAD}_${threshold}.cfm
  for i in $(seq 1 1 ${nruns})
  do
    ./srad_${best_block_size_SRAD}_${threshold}.cfm  ${SRAD_args} | tee -a profit_results_${best_block_size_SRAD}.txt
  done
done
cd ..

cd NQU
make clean

# compile
BLOCK_SIZE=${best_block_size_NQU} PROFITABILITY_THRESHOLD=0.2 make nqueen_${best_block_size_NQU}.hip

# run
echo "baseline : " | tee -a profit_results_${best_block_size_NQU}.txt
for i in $(seq 1 1 ${nruns})
do
    ./nqueen_${best_block_size_NQU}.hip ${NQU_args} $((best_block_size_NQU*2)) | tee -a profit_results_${best_block_size_NQU}.txt
done

# threshold
for threshold in $(seq 0.1 0.1 0.5)
do
  echo "DARM, profitability threshold = ${threshold}" | tee -a profit_results_${best_block_size_NQU}.txt
  make clean 
  BLOCK_SIZE=${best_block_size_NQU} PROFITABILITY_THRESHOLD=${threshold} make nqueen_${best_block_size_NQU}_${threshold}.cfm
  for i in $(seq 1 1 ${nruns})
  do
    ./nqueen_${best_block_size_NQU}_${threshold}.cfm  ${NQU_args} $((best_block_size_NQU*2)) | tee -a profit_results_${best_block_size_NQU}.txt
  done
done
cd ..

cd ..
