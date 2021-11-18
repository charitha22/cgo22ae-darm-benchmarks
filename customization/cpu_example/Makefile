clang=${DARM_HOME}/bin/clang
opt=${DARM_HOME}/bin/opt
lli=${DARM_HOME}/bin/lli


clang_flags=-emit-llvm -S -Xclang -disable-O0-optnone
opt_flags=-sroa -S
cfmerger_flags=-cfmelder  -S -force-cf-merging

prog_input=1 2 3 4 5 6

all : cpu_example.output.ll

cpu_example.ll : cpu_example.c
	${clang} ${clang_flags} $^
	
cpu_example.input.ll : cpu_example.ll
	${opt} ${opt_flags} < $^ > $@

cpu_example.output.ll : cpu_example.input.ll
	${opt}  ${cfmerger_flags} < $^ > $@

dot_cfg : cpu_example.output.ll cpu_example.input.ll
	${opt} -dot-cfg < cpu_example.input.ll > /dev/null
	mv .foo.dot before.dot
	${opt} -dot-cfg < cpu_example.output.ll > /dev/null
	mv .foo.dot after.dot

test : cpu_example.output.ll cpu_example.input.ll
	echo ${prog_input} | ${lli} cpu_example.input.ll 
	echo ${prog_input} | ${lli} cpu_example.output.ll 


clean :
	rm  -f *.ll output*.* .*.dot *.dot

