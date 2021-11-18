include ../../config.mk
COMMAND_GEN_SCRIPT := $(LLVM_HOME)/../scripts/gen_compile_command.py


# clang
HIPCC := $(ROCM_HOME)/bin/hipcc
HIPCC_FLAGS := -O3 


SRC = bitonic_sort.cpp
HIP_EXECUTABLE = bitonic_sort_$(BLOCK_SIZE).hip
CFM_EXECUTABLE = bitonic_sort_$(BLOCK_SIZE)_$(PROFITABILITY_THRESHOLD).cfm
BF_EXECUTABLE = bitonic_sort_$(BLOCK_SIZE).bf

all : $(HIP_EXECUTABLE) $(CFM_EXECUTABLE) $(BF_EXECUTABLE)

$(CFM_EXECUTABLE) : $(SRC)
	mkdir -p tmp
	$(HIPCC) -### $(HIPCC_FLAGS) -DBLOCK_SIZE=$(BLOCK_SIZE)  $< -o $@ 2>&1 | python3 $(COMMAND_GEN_SCRIPT) --llvm-home=$(LLVM_HOME) --output-loc=./tmp \
			 --ptx-opt-level=O0 --cfmelder-options="-stats --cf-merging-similarity-threshold=$(PROFITABILITY_THRESHOLD)" > ./tmp/compile_command_cfm.sh
	. ./tmp/compile_command_cfm.sh

$(HIP_EXECUTABLE) : $(SRC)
	mkdir -p tmp
	$(HIPCC) -### $(HIPCC_FLAGS) -DBLOCK_SIZE=$(BLOCK_SIZE)  $< -o $@ 2>&1 | python3 $(COMMAND_GEN_SCRIPT) --llvm-home=$(LLVM_HOME) --output-loc=./tmp \
			 --ptx-opt-level=O0 --disable-pass > ./tmp/compile_command.sh
	. ./tmp/compile_command.sh

$(BF_EXECUTABLE) : $(SRC)
	mkdir -p tmp
	$(HIPCC) -### $(HIPCC_FLAGS) -DBLOCK_SIZE=$(BLOCK_SIZE)  $< -o $@ 2>&1 | python3 $(COMMAND_GEN_SCRIPT) --llvm-home=$(LLVM_HOME) --output-loc=./tmp \
			 --ptx-opt-level=O0 --cfmelder-options="--run-branch-fusion-only" >  ./tmp/compile_command_bf.sh
	. ./tmp/compile_command_bf.sh


clean :
	@rm -rf bitonic_sort_*.cfm bitonic_sort_*.bf bitonic_sort_*.hip ./tmp *.o  \
		*.db *.csv *.sysinfo.txt *.json ./tmp_metrics/

results_clean :
	@rm -rf *_results_*.txt

