include ../../config.mk

# C compiler
CC = gcc
CC_FLAGS = -g -O2 -Icommon
HIPCC_FLAGS = -O2

HIPCC = $(ROCM_HOME)/bin/hipcc
HIPLD = $(HIPCC)
HIP_PLATFORM = hcc

COMMAND_GEN_SCRIPT := $(LLVM_HOME)/../scripts/gen_compile_command.py



$(TESTNAME): common/common.o lud_kernel.hip.o lud.hip.o
	$(HIPLD) $(CC_FLAGS) $^ -o $@ -lm

HIP_EXECUTABLE = lud_kernel.hip.$(BLOCK_SIZE)_hip
CFM_EXECUTABLE = lud_kernel.hip.$(BLOCK_SIZE)_$(PROFITABILITY_THRESHOLD)_cfm
BF_EXECUTABLE = lud_kernel.hip.$(BLOCK_SIZE)_bf

all : $(BF_EXECUTABLE) $(CFM_EXECUTABLE) $(HIP_EXECUTABLE)

common/common.o: common/common.c
	$(CC) $(CC_FLAGS) -c $< -o $@

lud.hip_$(BLOCK_SIZE).o: lud.hip.cpp
	$(HIPCC)  $(HIPCC_FLAGS) -DBLOCK_SIZE=$(BLOCK_SIZE)  -c $< -o $@

# lud_kernel.hip.o: lud_kernel.hip.cpp
# 	$(HIPCC)  $(HIPCC_FLAGS) -c $< -o $@

lud_kernel.hip.nocfm_$(BLOCK_SIZE).o : lud_kernel.hip.cpp
	mkdir -p tmp
	$(HIPCC) -### $(HIPCC_FLAGS) -DBLOCK_SIZE=$(BLOCK_SIZE)   -c $< -o $@ 2>&1 | python3 $(COMMAND_GEN_SCRIPT) --llvm-home=$(LLVM_HOME) --output-loc=./tmp \
	--disable-pass > ./tmp/compile_command.sh
	. ./tmp/compile_command.sh

lud_kernel.hip.cfm_$(BLOCK_SIZE)_$(PROFITABILITY_THRESHOLD).o : lud_kernel.hip.cpp
	mkdir -p tmp
	$(HIPCC) -### $(HIPCC_FLAGS) -DBLOCK_SIZE=$(BLOCK_SIZE)   -c $< -o $@ 2>&1 | python3 $(COMMAND_GEN_SCRIPT) --llvm-home=$(LLVM_HOME) --output-loc=./tmp \
	--cfmelder-options="-stats --cf-merging-similarity-threshold=$(PROFITABILITY_THRESHOLD)" > ./tmp/compile_command_cfm.sh
	. ./tmp/compile_command_cfm.sh

lud_kernel.hip.bf_$(BLOCK_SIZE).o : lud_kernel.hip.cpp
	mkdir -p tmp
	$(HIPCC) -### $(HIPCC_FLAGS) -DBLOCK_SIZE=$(BLOCK_SIZE)   -c $< -o $@ 2>&1 | python3 $(COMMAND_GEN_SCRIPT) --llvm-home=$(LLVM_HOME) --output-loc=./tmp \
	--cfmelder-options="-run-branch-fusion-only" > ./tmp/compile_command_bf.sh
	. ./tmp/compile_command_bf.sh

$(HIP_EXECUTABLE) : common/common.o lud_kernel.hip.nocfm_$(BLOCK_SIZE).o lud.hip_$(BLOCK_SIZE).o 
	$(HIPLD) $(CC_FLAGS) $^ -o $@ -lm

$(CFM_EXECUTABLE) : common/common.o lud_kernel.hip.cfm_$(BLOCK_SIZE)_$(PROFITABILITY_THRESHOLD).o lud.hip_$(BLOCK_SIZE).o 
	$(HIPLD) $(CC_FLAGS) $^ -o $@ -lm

$(BF_EXECUTABLE) : common/common.o lud_kernel.hip.bf_$(BLOCK_SIZE).o lud.hip_$(BLOCK_SIZE).o
	$(HIPLD) $(CC_FLAGS) $^ -o $@ -lm


clean:
	@rm -rf *.o common/*.o lud *.linkinfo *.perf *.ll ./tmp/* lud_kernel.hip.*_hip lud_kernel.hip.*_cfm lud_kernel.hip.*_bf \
	 lud_kernel.hip.*_bf *.db *.csv *.sysinfo.txt *.json ./tmp_metrics/ ./tmp

results_clean:
	@rm -f  *_results_*.txt
