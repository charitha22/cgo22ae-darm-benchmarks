 /opt/rocm-4.2.0/llvm/bin/clang-offload-bundler -unbundle -type=a -inputs=/opt/rocm-4.2.0/llvm/bin/../lib/clang/12.0.0/lib/linux/libclang_rt.builtins-x86_64.a -targets=hip-amdgcn-amd-amdhsa-gfx906 -outputs=./tmp/libbc-clang_rt.builtins-x86_64-amdgcn-gfx906-65596e.a

 /opt/rocm-4.2.0/llvm/bin/clang-12 -cc1 -mllvm --amdhsa-code-object-version=4 -triple amdgcn-amd-amdhsa -aux-triple x86_64-unknown-linux-gnu -S -emit-llvm --mrelax-relocations -disable-free -disable-llvm-verifier -discard-value-names -main-file-name mergesort.cpp -mrelocation-model pic -pic-level 1 -fhalf-no-semantic-interposition -mframe-pointer=none -fno-rounding-math -aux-target-cpu x86-64 -mlink-builtin-bitcode ./tmp/libbc-clang_rt.builtins-x86_64-amdgcn-gfx906-65596e.a -fcuda-is-device -mllvm -amdgpu-internalize-symbols -fcuda-allow-variadic-functions -fvisibility hidden -fapply-global-visibility-to-externs -mlink-builtin-bitcode /opt/rocm-4.2.0/amdgcn/bitcode/hip.bc -mlink-builtin-bitcode /opt/rocm-4.2.0/amdgcn/bitcode/ocml.bc -mlink-builtin-bitcode /opt/rocm-4.2.0/amdgcn/bitcode/ockl.bc -mlink-builtin-bitcode /opt/rocm-4.2.0/amdgcn/bitcode/oclc_daz_opt_off.bc -mlink-builtin-bitcode /opt/rocm-4.2.0/amdgcn/bitcode/oclc_unsafe_math_off.bc -mlink-builtin-bitcode /opt/rocm-4.2.0/amdgcn/bitcode/oclc_finite_only_off.bc -mlink-builtin-bitcode /opt/rocm-4.2.0/amdgcn/bitcode/oclc_correctly_rounded_sqrt_on.bc -mlink-builtin-bitcode /opt/rocm-4.2.0/amdgcn/bitcode/oclc_wavefrontsize64_on.bc -mlink-builtin-bitcode /opt/rocm-4.2.0/amdgcn/bitcode/oclc_isa_version_906.bc -target-cpu gfx906 -fno-split-dwarf-inlining -debugger-tuning=gdb -resource-dir /opt/rocm-4.2.0/llvm/lib/clang/12.0.0 -internal-isystem /opt/rocm-4.2.0/llvm/lib/clang/12.0.0/include/cuda_wrappers -internal-isystem /opt/rocm-4.2.0/include -include __clang_hip_runtime_wrapper.h -isystem /opt/rocm-4.2.0/llvm/lib/clang/12.0.0/include/.. -isystem /opt/rocm-4.2.0/hsa/include -isystem /opt/rocm-4.2.0/hip/include -c-isystem /opt/rocm-4.2.0/llvm/include/ -c-isystem /home/min/a/cgusthin/local_installs/include/ -c-isystem . -internal-isystem /usr/lib/gcc/x86_64-linux-gnu/7.5.0/../../../../include/c++/7.5.0 -internal-isystem /usr/lib/gcc/x86_64-linux-gnu/7.5.0/../../../../include/x86_64-linux-gnu/c++/7.5.0 -internal-isystem /usr/lib/gcc/x86_64-linux-gnu/7.5.0/../../../../include/x86_64-linux-gnu/c++/7.5.0 -internal-isystem /usr/lib/gcc/x86_64-linux-gnu/7.5.0/../../../../include/c++/7.5.0/backward -internal-isystem /usr/lib/gcc/x86_64-linux-gnu/7.5.0/../../../../include/c++/7.5.0 -internal-isystem /usr/lib/gcc/x86_64-linux-gnu/7.5.0/../../../../include/x86_64-linux-gnu/c++/7.5.0 -internal-isystem /usr/lib/gcc/x86_64-linux-gnu/7.5.0/../../../../include/x86_64-linux-gnu/c++/7.5.0 -internal-isystem /usr/lib/gcc/x86_64-linux-gnu/7.5.0/../../../../include/c++/7.5.0/backward -internal-isystem /usr/local/include -internal-isystem /opt/rocm-4.2.0/llvm/lib/clang/12.0.0/include -internal-externc-isystem /usr/include/x86_64-linux-gnu -internal-externc-isystem /include -internal-externc-isystem /usr/include -internal-isystem /usr/local/include -internal-isystem /opt/rocm-4.2.0/llvm/lib/clang/12.0.0/include -internal-externc-isystem /usr/include/x86_64-linux-gnu -internal-externc-isystem /include -internal-externc-isystem /usr/include -O0 -disable-O0-optnone -std=c++11 -fdeprecated-macro -fno-autolink -fdebug-compilation-dir /home/min/a/cgusthin/git/gpu-benchmarks/mergesort_simple -ferror-limit 19 -fhip-new-launch-api -fgnuc-version=4.2.1 -fcxx-exceptions -fexceptions -vectorize-loops -vectorize-slp -mllvm -amdgpu-early-inline-all=true -mllvm -amdgpu-function-calls=false -fcuda-allow-variadic-functions -munsafe-fp-atomics -faddrsig -o ./tmp/mergesort-gfx906-916795.ll -x hip mergesort.cpp

/home/min/a/cgusthin/git/llvm-project-rocm/build_cfm/bin/opt -gvn -mem2reg -simplifycfg -O3  -S < ./tmp/mergesort-gfx906-916795.ll  > ./tmp/after_pass.ll 
/home/min/a/cgusthin/git/llvm-project-rocm/build_cfm/bin/llc  -O3  -mtriple amdgcn-amd-amdhsa -mcpu=gfx906 -filetype=obj ./tmp/after_pass.ll -o ./tmp/mergesort-gfx906-916795.o 
 /opt/rocm-4.2.0/llvm/bin/lld -flavor gnu --no-undefined -shared -plugin-opt=-amdgpu-internalize-symbols -plugin-opt=mcpu=gfx906 -plugin-opt=O3 -plugin-opt=-amdgpu-early-inline-all=true -plugin-opt=-amdgpu-function-calls=false -o ./tmp/mergesort-gfx906-1b72cf.out ./tmp/mergesort-gfx906-916795.o

 /opt/rocm-4.2.0/llvm/bin/clang-offload-bundler -type=o -bundle-align=4096 -targets=host-x86_64-unknown-linux,hipv4-amdgcn-amd-amdhsa--gfx906 -inputs=/dev/null,./tmp/mergesort-gfx906-1b72cf.out -outputs=./tmp/mergesort-978c6f.hipfb

 /opt/rocm-4.2.0/llvm/bin/clang-12 -cc1 -triple x86_64-unknown-linux-gnu -aux-triple amdgcn-amd-amdhsa -emit-obj  --mrelax-relocations -disable-free -disable-llvm-verifier -discard-value-names -main-file-name mergesort.cpp -mrelocation-model static -mframe-pointer=none -fmath-errno -fno-rounding-math -mconstructor-aliases -munwind-tables -target-cpu x86-64 -tune-cpu generic -fno-split-dwarf-inlining -debugger-tuning=gdb -resource-dir /opt/rocm-4.2.0/llvm/lib/clang/12.0.0 -internal-isystem /opt/rocm-4.2.0/llvm/lib/clang/12.0.0/include/cuda_wrappers -internal-isystem /opt/rocm-4.2.0/include -include __clang_hip_runtime_wrapper.h -isystem /opt/rocm-4.2.0/llvm/lib/clang/12.0.0/include/.. -isystem /opt/rocm-4.2.0/hsa/include -isystem /opt/rocm-4.2.0/hip/include -c-isystem /opt/rocm-4.2.0/llvm/include/ -c-isystem /home/min/a/cgusthin/local_installs/include/ -c-isystem . -internal-isystem /usr/lib/gcc/x86_64-linux-gnu/7.5.0/../../../../include/c++/7.5.0 -internal-isystem /usr/lib/gcc/x86_64-linux-gnu/7.5.0/../../../../include/x86_64-linux-gnu/c++/7.5.0 -internal-isystem /usr/lib/gcc/x86_64-linux-gnu/7.5.0/../../../../include/x86_64-linux-gnu/c++/7.5.0 -internal-isystem /usr/lib/gcc/x86_64-linux-gnu/7.5.0/../../../../include/c++/7.5.0/backward -internal-isystem /usr/lib/gcc/x86_64-linux-gnu/7.5.0/../../../../include/c++/7.5.0 -internal-isystem /usr/lib/gcc/x86_64-linux-gnu/7.5.0/../../../../include/x86_64-linux-gnu/c++/7.5.0 -internal-isystem /usr/lib/gcc/x86_64-linux-gnu/7.5.0/../../../../include/x86_64-linux-gnu/c++/7.5.0 -internal-isystem /usr/lib/gcc/x86_64-linux-gnu/7.5.0/../../../../include/c++/7.5.0/backward -internal-isystem /usr/local/include -internal-isystem /opt/rocm-4.2.0/llvm/lib/clang/12.0.0/include -internal-externc-isystem /usr/include/x86_64-linux-gnu -internal-externc-isystem /include -internal-externc-isystem /usr/include -internal-isystem /usr/local/include -internal-isystem /opt/rocm-4.2.0/llvm/lib/clang/12.0.0/include -internal-externc-isystem /usr/include/x86_64-linux-gnu -internal-externc-isystem /include -internal-externc-isystem /usr/include -O3 -std=c++11 -fdeprecated-macro -fdebug-compilation-dir /home/min/a/cgusthin/git/gpu-benchmarks/mergesort_simple -ferror-limit 19 -fhip-new-launch-api -fgnuc-version=4.2.1 -fcxx-exceptions -fexceptions -vectorize-loops -vectorize-slp -mllvm -amdgpu-early-inline-all=true -mllvm -amdgpu-function-calls=false -fcuda-include-gpubinary ./tmp/mergesort-978c6f.hipfb -fcuda-allow-variadic-functions -faddrsig -o ./tmp/mergesort-2206b4.o -x hip mergesort.cpp

 /usr/bin/ld -z relro --hash-style=gnu --eh-frame-hdr -m elf_x86_64 -dynamic-linker /lib64/ld-linux-x86-64.so.2 -o mergesort.hipcc /usr/lib/gcc/x86_64-linux-gnu/7.5.0/../../../x86_64-linux-gnu/crt1.o /usr/lib/gcc/x86_64-linux-gnu/7.5.0/../../../x86_64-linux-gnu/crti.o /usr/lib/gcc/x86_64-linux-gnu/7.5.0/crtbegin.o -L/opt/rocm-4.2.0/hip/lib -L/opt/rocm-4.2.0/llvm/bin/../lib/clang/12.0.0/lib/linux -L/usr/lib/gcc/x86_64-linux-gnu/7.5.0 -L/usr/lib/gcc/x86_64-linux-gnu/7.5.0/../../../x86_64-linux-gnu -L/lib/x86_64-linux-gnu -L/lib/../lib64 -L/usr/lib/x86_64-linux-gnu -L/usr/lib/gcc/x86_64-linux-gnu/7.5.0/../../.. -L/opt/rocm-4.2.0/llvm/bin/../lib -L/lib -L/usr/lib -lgcc_s -lgcc -lpthread -lm -lrt ./tmp/mergesort-2206b4.o --enable-new-dtags --rpath=/opt/rocm-4.2.0/hip/lib:/opt/rocm-4.2.0/lib -lamdhip64 -lclang_rt.builtins-x86_64 -lstdc++ -lm -lgcc_s -lgcc -lc -lgcc_s -lgcc /usr/lib/gcc/x86_64-linux-gnu/7.5.0/crtend.o /usr/lib/gcc/x86_64-linux-gnu/7.5.0/../../../x86_64-linux-gnu/crtn.o

