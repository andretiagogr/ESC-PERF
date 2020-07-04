#!/bin/sh

set -x

#cd $HOME/ESC/TP4

gcc -ggdb naive.c -o naive

function parte_1 {
    perf stat -e cpu-clock,faults ./naive

    perf record -e cpu-clock,faults ./naive
    perf report --stdio --dsos=naive,libc-2.12.so

    perf annotate --stdio --dsos=naive --symbol=multiply_matrices --source

    # Devemos ter pelo menos 100 a 500 samples
    # Podemos usar --freq= para aumentar a frequência de sampling -> vai ter mais overhead

    # perf evlist -F
}

function parte_2 {
    gcc -ggdb naive.c -o naive -O3
    gcc -ggdb interchange.c -o interchange -O3
    
    perf stat -e cpu-cycles,instructions,cache-references,cache-misses,branch-instructions,branch-misses,L1-dcache-loads,L1-dcache-load-misses,L1-dcache-stores,L1-dcache-store-misses,L1-icache-loads,LLC-loads,LLC-load-misses,LLC-stores,LLC-store-misses,dTLB-load-misses,dTLB-store-misses,iTLB-load-misses,branch-loads,branch-load-misses ./naive
    
    perf stat -e cpu-cycles,instructions,cache-references,cache-misses,branch-instructions,branch-misses,L1-dcache-loads,L1-dcache-load-misses,L1-dcache-stores,L1-dcache-store-misses,L1-icache-loads,LLC-loads,LLC-load-misses,LLC-stores,LLC-store-misses,dTLB-load-misses,dTLB-store-misses,iTLB-load-misses,branch-loads,branch-load-misses ./interchange
    
    #bus-cycles
    #L1-icode-load-misses
}

#parte_1
parte_2
