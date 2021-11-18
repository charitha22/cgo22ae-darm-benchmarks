ROCM_HOME=/opt/rocm
COMMAND_GEN_SCRIPT=$(DARM_HOME)/../scripts/gen_compile_command.py

# clang
HIP_CC = $(ROCM_HOME)/bin/hipcc
HIP_FLAGS = -O3 -fno-unroll-loops


SRC = gpu_example.cpp 
EXECUTABLE = gpu_example

all : $(EXECUTABLE)

$(EXECUTABLE) : $(SRC)
	mkdir -p tmp
	$(HIP_CC) -### $(HIP_FLAGS)  $^ -o $@ 2>&1 | python3 $(COMMAND_GEN_SCRIPT) --llvm-home=$(DARM_HOME) \
		--cfmelder-options="" \
		--output-loc=./tmp > ./tmp/compile_command.sh
	. ./tmp/compile_command.sh

clean :
	rm -rf $(EXECUTABLE) ./tmp
