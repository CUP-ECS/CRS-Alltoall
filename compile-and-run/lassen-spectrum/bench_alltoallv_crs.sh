#!/bin/bash
#BSUB -J alltoallv_crs
#BSUB -e alltoallv_crs.%J.err
#BSUB -o alltoallv_crs.%J.out
#BSUB -nnodes 32
#BSUB -q pbatch
#BSUB -W 00:15
#BSUB -G unm

source ./vars.sh

cd ${CRS_DIR}/mpi_advance/build_lassen/benchmarks
echo ${CRS_DIR}/mpi_advance/build_lassen/benchmarks
folder=${CRS_DIR}/benchmark_mats
for mat in delaunay_n22.pm dielFilterV2clx.pm germany_osm.pm human_gene1.pm NLR.pm
do
    echo $folder/$mat
    for (( nodes = 2; nodes <= 32; nodes*=2 ));
    do
        jsrun -a36 -c36 -r1 -n$nodes ./alltoallv_crs $folder/$mat
    done
done


