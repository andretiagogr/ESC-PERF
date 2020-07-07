#!/bin/sh

set -x

#cd $HOME/ESC/TP4

output_dir=p2_output
mkdir -p $output_dir

function parte_1 {
    gcc -ggdb naive.c -o naive

    perf record -e cpu-clock,faults ./naive
    perf report --stdio --dsos=naive,libc-2.12.so > $output_dir/p1_report

    perf annotate --stdio --dsos=naive --symbol=multiply_matrices --source > $output_dir/p1_annotate
}

function parte_2 {
    gcc naive.c -o naive -O3
    gcc interchange.c -o interchange -O3
    
    perf stat -e cpu-cycles,instructions,cache-references,cache-misses,branch-instructions,branch-misses,L1-dcache-loads,L1-dcache-load-misses,L1-dcache-stores,L1-dcache-store-misses,L1-icache-loads,LLC-loads,LLC-load-misses,LLC-stores,LLC-store-misses,dTLB-load-misses,dTLB-store-misses,iTLB-load-misses,branch-loads,branch-load-misses ./naive 2> $output_dir/p2_naive
    
    perf stat -e cpu-cycles,instructions,cache-references,cache-misses,branch-instructions,branch-misses,L1-dcache-loads,L1-dcache-load-misses,L1-dcache-stores,L1-dcache-store-misses,L1-icache-loads,LLC-loads,LLC-load-misses,LLC-stores,LLC-store-misses,dTLB-load-misses,dTLB-store-misses,iTLB-load-misses,branch-loads,branch-load-misses ./interchange 2> $output_dir/p2_interchange
}

function parte_3 {
    gcc -ggdb naive.c -o naive
    
    perf record -e cpu-cycles -c 100000 ./naive
    perf report -n --no-source --stdio --percent-limit 0.01 > $output_dir/p3_report
    perf annotate --stdio --dsos=naive --symbol=multiply_matrices --no-source > $output_dir/p3_annotate

    perf record -c 100000 -e cpu-cycles -ag ./naive
    perf script | ./stackcollapse-perf.pl | ./flamegraph.pl > naive_cpu-cycles_C100000.svg

    perf record -F 99 -e cpu-cycles -ag ./naive
    perf script | ./stackcollapse-perf.pl | ./flamegraph.pl > naive_cpu-cycles_F99.svg

    gcc -O3 naive.c -o naive
    perf record -e cpu-cycles,instructions -c 100000 ./naive
    perf report -n --stdio > $output_dir/p3_cpu-cycles_instructions
    
    perf record -e cache-references,cache-misses -c 100000 ./naive 
    perf report -n --stdio > $output_dir/p3_cache-references_cache-misses
    
    perf record -e LLC-loads,LLC-load-misses -c 100000 ./naive 
    perf report -n --stdio > $output_dir/p3_LLC-loads_LLC-load-misses
    
    perf record -e branch-loads,branch-load-misses -c 100000 ./naive 
    perf report -n --stdio > $output_dir/p3_branch-loads_branch-load-misses
}

parte_1
parte_2
parte_3
