#!/bin/bash

profitabilty_threshold=0.2
nruns=3

# program args 
LUD_ARGS="-s 16384"
SRAD_ARGS="4096 4096 0 127 0 127 0.5 2"
NQU_ARGS="-g 15"

make bench_clean
cd benchmarks

echo "Bitonic Sort (BIT)"
cd BIT

for block_size in {32,64,128,256}
do
    echo "block size : ${block_size}"

    # compile
    BLOCK_SIZE=${block_size} PROFITABILITY_THRESHOLD=${profitabilty_threshold} make

    # run
    echo "baseline : " | tee -a speedup_results_${block_size}.txt
    for i in $(seq 1 1 ${nruns})
    do
        ./bitonic_sort_${block_size}.hip | tee -a speedup_results_${block_size}.txt
    done

    echo "branch fusion : " |  tee -a speedup_results_${block_size}.txt
    for i in $(seq 1 1 ${nruns})
    do
        ./bitonic_sort_${block_size}.bf | tee -a speedup_results_${block_size}.txt
    done

    echo "DARM : " |  tee -a speedup_results_${block_size}.txt
    for i in $(seq 1 1 ${nruns})
    do
        ./bitonic_sort_${block_size}_${profitabilty_threshold}.cfm | tee -a speedup_results_${block_size}.txt
    done
done
cd ..


echo "Partition and Concurrent Merge (PCM)"
cd PCM

for block_size in {32,64,128,256}
do
    echo "block size : ${block_size}"

    # compile
    # if [ ${block_size} == 128 ]
    # then 
    #   mkdir -p tmp
    #   . compile_command_cfm_128.sh
    #   BLOCK_SIZE=128 make pcm_${block_size}.hip
    #   BLOCK_SIZE=128 make pcm_${block_size}.bf
    # else
    #   BLOCK_SIZE=${block_size} PROFITABILITY_THRESHOLD=${profitabilty_threshold} make
    # fi
    BLOCK_SIZE=${block_size} PROFITABILITY_THRESHOLD=${profitabilty_threshold} make

    # run
    echo "baseline : " | tee -a speedup_results_${block_size}.txt
    for i in $(seq 1 1 ${nruns})
    do
        ./pcm_${block_size}.hip | tee -a speedup_results_${block_size}.txt
    done

    echo "branch fusion : " |  tee -a speedup_results_${block_size}.txt
    for i in $(seq 1 1 ${nruns})
    do
        ./pcm_${block_size}.bf | tee -a speedup_results_${block_size}.txt
    done

    echo "DARM : " |  tee -a speedup_results_${block_size}.txt
    for i in $(seq 1 1 ${nruns})
    do
        ./pcm_${block_size}_${profitabilty_threshold}.cfm | tee -a speedup_results_${block_size}.txt
    done
done
cd ..

echo "DCT Quantization (DCT)"
cd DCT

for block_size in {4,8,16}
do
    echo "block size : ${block_size}"

    # compile
    BLOCK_SIZE=${block_size} PROFITABILITY_THRESHOLD=${profitabilty_threshold} make

    # run
    echo "baseline : " | tee -a speedup_results_${block_size}.txt
    for i in $(seq 1 1 ${nruns})
    do
        ./dctq_${block_size}.hip | tee -a speedup_results_${block_size}.txt
    done

    echo "branch fusion : " |  tee -a speedup_results_${block_size}.txt
    for i in $(seq 1 1 ${nruns})
    do
        ./dctq_${block_size}.bf | tee -a speedup_results_${block_size}.txt
    done

    echo "DARM : " |  tee -a speedup_results_${block_size}.txt
    for i in $(seq 1 1 ${nruns})
    do
        ./dctq_${block_size}_${profitabilty_threshold}.cfm | tee -a speedup_results_${block_size}.txt
    done
done
cd ..

echo "Mergesort (MS)"
cd MS
for block_size in {32,64,128,256}
do
    echo "block size : ${block_size}"

    # compile
    BLOCK_SIZE=${block_size} PROFITABILITY_THRESHOLD=${profitabilty_threshold} make

    # run
    echo "baseline : " | tee -a speedup_results_${block_size}.txt
    for i in $(seq 1 1 ${nruns})
    do
        ./mergesort_${block_size}.hip | tee -a speedup_results_${block_size}.txt
    done

    echo "branch fusion : " |  tee -a speedup_results_${block_size}.txt
    for i in $(seq 1 1 ${nruns})
    do
        ./mergesort_${block_size}.bf | tee -a speedup_results_${block_size}.txt
    done

    echo "DARM : " |  tee -a speedup_results_${block_size}.txt
    for i in $(seq 1 1 ${nruns})
    do
        ./mergesort_${block_size}_${profitabilty_threshold}.cfm | tee -a speedup_results_${block_size}.txt
    done
done
cd ..



echo "LU Decomposition (LUD)"
cd LUD
for block_size in {8,16,32,64}
do
    echo "block size : ${block_size}"

    # compile
    BLOCK_SIZE=${block_size} PROFITABILITY_THRESHOLD=${profitabilty_threshold} make

    # run
    echo "baseline : " | tee -a speedup_results_${block_size}.txt
    for i in $(seq 1 1 ${nruns})
    do
        ./lud_kernel.hip.${block_size}_hip ${LUD_ARGS} | tee -a speedup_results_${block_size}.txt
    done

    echo "branch fusion : " |  tee -a speedup_results_${block_size}.txt
    for i in $(seq 1 1 ${nruns})
    do
        ./lud_kernel.hip.${block_size}_bf ${LUD_ARGS}  | tee -a speedup_results_${block_size}.txt
    done

    echo "DARM : " |  tee -a speedup_results_${block_size}.txt
    for i in $(seq 1 1 ${nruns})
    do
        ./lud_kernel.hip.${block_size}_${profitabilty_threshold}_cfm ${LUD_ARGS}  | tee -a speedup_results_${block_size}.txt
    done
done
cd ..


echo "Speckle Reducing Anisotropic Diffusion (SRAD)"
cd SRAD
for block_size in {16,32}
do
    echo "block size : ${block_size}"

    # compile
    BLOCK_SIZE=${block_size} PROFITABILITY_THRESHOLD=${profitabilty_threshold} make

    # run
    echo "baseline : " | tee -a speedup_results_${block_size}.txt
    for i in $(seq 1 1 ${nruns})
    do
        ./srad_${block_size}.hip ${SRAD_ARGS} | tee -a speedup_results_${block_size}.txt
    done

    echo "branch fusion : " |  tee -a speedup_results_${block_size}.txt
    for i in $(seq 1 1 ${nruns})
    do
        ./srad_${block_size}.bf ${SRAD_ARGS}  | tee -a speedup_results_${block_size}.txt
    done

    echo "DARM : " |  tee -a speedup_results_${block_size}.txt
    for i in $(seq 1 1 ${nruns})
    do
        ./srad_${block_size}_${profitabilty_threshold}.cfm ${SRAD_ARGS}  | tee -a speedup_results_${block_size}.txt
    done
done
cd ..

echo "N-Queen (NQU)"
cd NQU
for block_size in {64,96,128,256}
do
    echo "block size : ${block_size}"

    # compile
    BLOCK_SIZE=${block_size} PROFITABILITY_THRESHOLD=${profitabilty_threshold} make

    # run
    echo "baseline : " | tee -a speedup_results_${block_size}.txt
    for i in $(seq 1 1 ${nruns})
    do
        ./nqueen_${block_size}.hip ${NQU_ARGS} $((block_size*2)) | tee -a speedup_results_${block_size}.txt
    done

    echo "branch fusion : " |  tee -a speedup_results_${block_size}.txt
    for i in $(seq 1 1 ${nruns})
    do
        ./nqueen_${block_size}.bf ${NQU_ARGS} $((block_size*2))  | tee -a speedup_results_${block_size}.txt
    done

    echo "DARM : " |  tee -a speedup_results_${block_size}.txt
    for i in $(seq 1 1 ${nruns})
    do
        ./nqueen_${block_size}_${profitabilty_threshold}.cfm ${NQU_ARGS} $((block_size*2))  | tee -a speedup_results_${block_size}.txt
    done
done
cd ..

cd ..