### CGO-2022 artifact evaluation instructions for the paper DARM: Control-Flow Melding for SIMT Thread Divergence Reduction

### Installation
Connect to the remote machine using provide IP address, username and password. Download and build the source code using following set of commands.
```
$ export HOME=$(pwd)
$ git clone https://github.com/charitha22/cgo22ae−darm−code.git $ cd cgo22ae-darm-code && mkdir build build install
$ export DARM HOME=$(pwd)/build
$ . scripts/run cmake.sh && make -j4
```
This compilation process will take approximately 1 hour. Make sure you use the same shell terminal to execute all the commands/scripts to preserve environment variables. Continue to use the same terminal when running evaluation scripts in the next section.

### Evaluation and expected result

Download the benchmarks and evaluation scripts using,
```
$ cd ${HOME} && git clone https://github.com/charitha22/cgo22ae−darm−benchmarks.git
$ cd cgo22ae-darm−benchmarks && export DARM HOME=$(pwd)
```

To generate the speedups plot (Figure 7) run following commands,
```
$ . scripts/run_speedups.sh
$ . scripts/gen_speedups_plot.sh
```
Note that speedups.pdf is generated based on the current experiment results and speedups paper.pdf is generated from the raw numbers used for our paper.

To generate the ALU utilization plot (Figure 8) and memory instruction counters plot (Figure 9) use the following commands,
```
$ . scripts/run_alu_memory_numbers.sh 
$ . scripts/gen_alu_mem_plot.sh
```
`alu.pdf` and `mem.pdf` are generated based on current experiment results and `alu_paper.pdf` and `mem_paper.pdf` are generated using raw numbers used in the paper.

Following commands can be used to generate the melding prof- itability threshold plot (Figure 10).
```
$ . scripts/run_profitability_threshold.sh 
$ . scripts/gen_profit_plot.sh
```

Similar to above, `profitability.pdf` is generated based on current experiment results and `profitability_paper.pdf` is generated based on raw numbers.

Run following commands to obtain the compile times of benchmarks (Table II).
```
$ . scripts/run compile times.sh 
$ . scripts/print compile times.sh
```
This will print out the compile times for DARM and baseline into the standard output.
You can use scp from your local machine to download the PDF files to your local machine.
```
$ scp <username>@tgrogers−pc05.ecn.purdue.edu:< location of pdf file> .
```
### Experiment customization and reusability
## Using our method on a new GPU kernel
Our compiler can be used on any GPU kernel written in HIP language. The following commands can be used to compile a GPU kernel with our transformation enabled.
```
$ mkdir −p tmp
$ hipcc −### −O3 <kernel name>.cpp −o <executable name> 2>&1 | python3 ${DARM HOME}/../scripts/gen_compile_command.py −−llvm−home=${DARM_HOME} --cfmelder−options="" −−output−loc=./tmp > ./tmp/compile command.sh 
$ . ./tmp/compile command.sh
```
These commands automatically generate and runs a sequence of compilation commands that is instrumented with our transformation pass. To demonstrate above compilation process we provide a synthetic HIP kernel (`gpu_example.cpp`). To compile and run this kernel use the following command.
```
$ cd {BENCH HOME}/customization/gpu_example 
$ make && ./gpu_example
```
This kernel contains a divergent if-then-else branch inside a two-nested loop. If and then sections of the branch contain if-then regions with random computations. This control-flow structure provides multiple melding opportunities for our method. You can visualize how DARM changed the control-flow of the program using the following commands.
```
$ ${DARM HOME}/bin/opt −dot−cfg < ./tmp/gpu_example*.ll > / dev/null
$ mv .*foo*.dot before.dot
$ ${DARM HOME}/bin/opt −dot−cfg < ./tmp/after_pass.ll > /dev/null
$ mv .*foo*.dot after.dot
```
These commands generate `.dot` files `before.dot` and `after.dot` that contains the control-flow graphs of the program before and after the DARM transformation. You can view the `.dot` files using any [online graph viewer](https://dreampuf.github.io/GraphvizOnline/).

Our compiler provides several options that can be used to customize the experiments.
* `–cfmelder-analysis-only` : Only runs the DARM analysis (Section IV-C) and does not modify the program. Analysis can be used to see what parts of the control-flow graph has profitable melding opportunities.
* `–cf-merging-similarity-threshold=<threshold>` : Adjusts the melding profitability threshold (Section VI-E). threshold must be a value in the range [0.0, 0.5]. Setting threshold to 0.0 will meld any meldable subgraphs (regardless of its profitability), and setting it to 0.5 will only meld subgraphs that are maximally profitable.
* `-run-cfmelding-on-function=<function_name>` : Runs the DARM transformation on a specific function only.
* `–run-cfmelding-once` : Disables applying melding recursively. When this option is enabled transformation terminates after performing only one melding.
You modify the `–cfmelder-options` field in the compilation compilation command above to use any of these options. For example, following modified command will on meld control-flow subgrpahs only if they are maximally profitable (i.e. threshold is 0.5).
```
$ mkdir −p tmp
$ hipcc −### −O3 <kernel_name>.cpp −o <executable name> 2>&1 | python3 ${DARM HOME}/../scripts/gen_compile_command.py −−llvm−home=#{DARM_HOME} −−cfmelder−options=”−−cf−merging−similarity−threshold=0.5” −−output−loc=./tmp > ./tmp/compile_command.sh 
$ . ./tmp/compile_command.sh
```
You can also update the `–cfmelder-options` field in the provided Makefile to achieve the same.

## Using our method on a CPU program

DARM is implemented a general compiler transformation pass and integrated with `LLVM opt`. Therefore it can be used on CPU programs as well. To demonstrate this we provide a synthetic program written in `C`. Run compile this program run,
```
$ cd ${BENCH HOME}/customization/cpu_example 
$ make
```
This will generate LLVM-IR files `cpu_example.input.ll` and `cpu_example.output.ll` that contains the program before and after applying DARM transformation. To visualize the control-flow graphs of the two programs run,
```
$ make dot_cfg
```
This will create two `.dot` files `before.dot` and `after.dot` that contains the control-flow graph structure of the original and transformed program. You can copy the content of the `.dot` files into an online graph visualizer to view them.

Following command will run the original and transformed programs using `LLVM lli` and also prints the output of the two programs to stdout.
```
$ make test
```
You can customize `cpu_example.c` to inspect how DARM transformation works on different contorl-flow graphs. For example, you can comment out lines `11−14` and `23−27` to get a program with different control-flow structure and use above commands to transform and run the programs.
