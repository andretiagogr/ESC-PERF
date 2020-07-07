#!/bin/sh

set -x

#cd $HOME/ESC/TP4

output_dir=p1_output
mkdir -p $output_dir

sort_dir=prog_sort

module load gcc/5.3.0

function a_c {
    make -C $sort_dir clean
    make -C $sort_dir

    perf stat -e instructions,cycles,cache-misses,cache-references,branches,branch-misses $sort_dir/sort $1 1 100000000 2> $output_dir/1a_sort$1

    perf record -F 99 $sort_dir/sort $1 1 100000000
    perf report -n --stdio > $output_dir/1b_sort$1

    perf record -F 99 -ag $sort_dir/sort $1 1 100000000
    perf script | ./stackcollapse-perf.pl | ./flamegraph.pl> $output_dir/sort$1_O3.svg

    g++ $sort_dir/*.c $sort_dir/sort
    perf record -F 99 -ag $sort_dir/sort $1 1 100000000
    perf script | ./stackcollapse-perf.pl | ./flamegraph.pl> $output_dir/sort$1.svg
}

a_c 1
a_c 2
a_c 3
a_c 4

module unload gcc/5.3.0
