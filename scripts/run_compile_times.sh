
profitabilty_threshold=0.2

run() {
    BLOCK_SIZE=$1 PROFITABILITY_THRESHOLD=0.2 taskset 0x10 make $2
}

# number of runs
nruns=5

# best block sizes for DARM
blocksize_BIT=64
blocksize_PCM=32
blocksize_DCT=16
blocksize_MS=32
blocksize_LUD=8
blocksize_SRAD=16
blocksize_NQU=64


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
echo "baseline : " |  tee -a compile_time_results_${blocksize_BIT}.txt
for i in $(seq ${nruns}); do
  make clean
  { time run $blocksize_BIT "bitonic_sort_${blocksize_BIT}.hip" ;} 2>&1 | tee -a compile_time_results_${blocksize_BIT}.txt
done

echo "DARM : " |  tee -a compile_time_results_${blocksize_BIT}.txt
for i in $(seq ${nruns}); do
  make clean
  { time run $blocksize_BIT "bitonic_sort_${blocksize_BIT}_${profitabilty_threshold}.cfm" ;} 2>&1 | tee -a compile_time_results_${blocksize_BIT}.txt
done
cd ..

cd PCM
echo "baseline : " |  tee -a compile_time_results_${blocksize_PCM}.txt
for i in $(seq ${nruns}); do
  make clean
  { time run $blocksize_PCM "pcm_${blocksize_PCM}.hip" ;} 2>&1 | tee -a compile_time_results_${blocksize_PCM}.txt
done

echo "DARM : " |  tee -a compile_time_results_${blocksize_PCM}.txt
for i in $(seq ${nruns}); do
  make clean
  { time run $blocksize_PCM "pcm_${blocksize_PCM}_${profitabilty_threshold}.cfm" ;} 2>&1 | tee -a compile_time_results_${blocksize_PCM}.txt
done
cd ..

cd DCT
echo "baseline : " |  tee -a compile_time_results_${blocksize_DCT}.txt
for i in $(seq ${nruns}); do
  make clean
  { time run $blocksize_DCT "dctq_${blocksize_DCT}.hip" ;} 2>&1 | tee -a compile_time_results_${blocksize_DCT}.txt
done

echo "DARM : " |  tee -a compile_time_results_${blocksize_DCT}.txt
for i in $(seq ${nruns}); do
  make clean
  { time run $blocksize_DCT "dctq_${blocksize_DCT}_${profitabilty_threshold}.cfm" ;} 2>&1 | tee -a compile_time_results_${blocksize_DCT}.txt
done
cd ..

cd MS
echo "baseline : " |  tee -a compile_time_results_${blocksize_MS}.txt
for i in $(seq ${nruns}); do
  make clean
  { time run $blocksize_MS "mergesort_${blocksize_MS}.hip" ;} 2>&1 | tee -a compile_time_results_${blocksize_MS}.txt
done

echo "DARM : " |  tee -a compile_time_results_${blocksize_MS}.txt
for i in $(seq ${nruns}); do
  make clean
  { time run $blocksize_MS "mergesort_${blocksize_MS}_${profitabilty_threshold}.cfm" ;} 2>&1 | tee -a compile_time_results_${blocksize_MS}.txt
done
cd ..

cd LUD
echo "baseline : " |  tee -a compile_time_results_${blocksize_LUD}.txt
for i in $(seq ${nruns}); do
  make clean
  { time run $blocksize_LUD "lud_kernel.hip.${blocksize_LUD}_hip" ;} 2>&1 | tee -a compile_time_results_${blocksize_LUD}.txt
done

echo "DARM : " |  tee -a compile_time_results_${blocksize_LUD}.txt
for i in $(seq ${nruns}); do
  make clean
  { time run $blocksize_LUD "lud_kernel.hip.${blocksize_LUD}_${profitabilty_threshold}_cfm" ;} 2>&1 | tee -a compile_time_results_${blocksize_LUD}.txt
done
cd ..

cd SRAD
echo "baseline : " |  tee -a compile_time_results_${blocksize_SRAD}.txt
for i in $(seq ${nruns}); do
  make clean
  { time run $blocksize_SRAD "srad_${blocksize_SRAD}.hip" ;} 2>&1 | tee -a compile_time_results_${blocksize_SRAD}.txt
done

echo "DARM : " |  tee -a compile_time_results_${blocksize_SRAD}.txt
for i in $(seq ${nruns}); do
  make clean
  { time run $blocksize_SRAD "srad_${blocksize_SRAD}_${profitabilty_threshold}.cfm" ;} 2>&1 | tee -a compile_time_results_${blocksize_SRAD}.txt
done
cd ..


cd NQU
echo "baseline : " |  tee -a compile_time_results_${blocksize_NQU}.txt
for i in $(seq ${nruns}); do
  make clean
  { time run $blocksize_NQU "nqueen_${blocksize_NQU}.hip" ;} 2>&1 | tee -a compile_time_results_${blocksize_NQU}.txt
done

echo "DARM : " |  tee -a compile_time_results_${blocksize_NQU}.txt
for i in $(seq ${nruns}); do
  make clean
  { time run $blocksize_NQU "nqueen_${blocksize_NQU}_${profitabilty_threshold}.cfm" ;} 2>&1 | tee -a compile_time_results_${blocksize_NQU}.txt
done
cd ..

cd ..