
all :
	

clean :
	rm -f *.pdf *.csv

bench_clean:
	cd benchmarks && make clean && make results_clean
